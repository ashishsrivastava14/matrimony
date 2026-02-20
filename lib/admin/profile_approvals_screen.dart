import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/profile_model.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

class ProfileApprovalsScreen extends StatefulWidget {
  const ProfileApprovalsScreen({super.key});

  @override
  State<ProfileApprovalsScreen> createState() =>
      _ProfileApprovalsScreenState();
}

class _ProfileApprovalsScreenState extends State<ProfileApprovalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();

    final pending = appState.pendingProfiles;
    final approved = appState.approvedProfiles;
    final rejected = appState.rejectedProfiles;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.profileApprovals,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(l10n.reviewApproveProfiles,
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n.pendingLabel(pending.length)),
              Tab(text: l10n.approvedLabel(approved.length)),
              Tab(text: l10n.rejectedLabel(rejected.length)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(context, pending, 'pending', appState),
                _buildList(context, approved, 'approved', appState),
                rejected.isEmpty
                    ? Center(
                        child: Text(l10n.noRejectedProfiles,
                            style: const TextStyle(
                                color: AppColors.textSecondary)))
                    : _buildList(context, rejected, 'rejected', appState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<ProfileModel> profiles,
      String type, AppState appState) {
    if (profiles.isEmpty) {
      return Center(
        child: Text(
          type == 'pending'
              ? 'No profiles pending review'
              : type == 'approved'
                  ? 'No approved profiles'
                  : 'No rejected profiles',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final p = profiles[index];
        return _ProfileApprovalCard(
          profile: p,
          type: type,
          onApprove: () => _handleApprove(context, appState, p),
          onReject: () => _showRejectDialog(context, appState, p),
          onUndoReject: () => _handleUndoReject(context, appState, p),
          onRevoke: () => _showRevokeDialog(context, appState, p),
          onViewDetail: () => _showProfileDetail(context, p),
        );
      },
    );
  }

  void _handleApprove(
      BuildContext context, AppState appState, ProfileModel p) {
    appState.approveProfile(p.id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${p.name} approved'),
      backgroundColor: AppColors.success,
      duration: const Duration(seconds: 2),
    ));
  }

  void _showRejectDialog(
      BuildContext context, AppState appState, ProfileModel p) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rejecting profile of ${p.name}.'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Reason (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Enter reason for rejection...'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              appState.rejectProfile(p.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${p.name} rejected'
                    '${reasonCtrl.text.isNotEmpty ? ': ${reasonCtrl.text}' : ''}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ));
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _handleUndoReject(
      BuildContext context, AppState appState, ProfileModel p) {
    appState.undoRejectProfile(p.id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${p.name} moved back to pending'),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showRevokeDialog(
      BuildContext context, AppState appState, ProfileModel p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Approval'),
        content: Text(
            'Are you sure you want to revoke approval for ${p.name}? The profile will move back to pending.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(ctx);
              appState.rejectProfile(p.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Approval revoked for ${p.name}'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 2),
              ));
            },
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }

  void _showProfileDetail(BuildContext context, ProfileModel p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.92,
        builder: (_, ctrl) => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: ctrl,
            children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2))),
              ),
              Center(
                child: CircleAvatar(
                  radius: 42,
                  backgroundImage: p.photos.isNotEmpty
                      ? AssetImage(p.photos.first)
                      : null,
                  backgroundColor: AppColors.primary,
                  onBackgroundImageError: p.photos.isNotEmpty
                      ? (_, __) {}
                      : null,
                  child: p.photos.isEmpty
                      ? Text(p.name[0],
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white))
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                  child: Text(p.name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
              Center(
                  child: Text('${p.age} yrs, ${p.gender}',
                      style: const TextStyle(
                          color: AppColors.textSecondary))),
              const SizedBox(height: 16),
              const Divider(),
              _DetailRow(Icons.school, 'Education', p.education),
              _DetailRow(Icons.work, 'Occupation', p.occupation),
              _DetailRow(Icons.location_on, 'Location',
                  '${p.city}, ${p.state}'),
              _DetailRow(Icons.temple_hindu, 'Religion / Caste',
                  '${p.religion} / ${p.caste}'),
              _DetailRow(Icons.monetization_on, 'Income',
                  p.annualIncome),
              _DetailRow(Icons.assignment_ind, 'Membership ID',
                  p.membershipId),
              if (p.star != null)
                _DetailRow(Icons.star, 'Star / Rasi',
                    '${p.star} / ${p.rasi ?? '-'}'),
              if (p.aboutMe.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('About',
                    style:
                        TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(p.aboutMe,
                    style: const TextStyle(
                        color: AppColors.textSecondary)),
              ],
              if (p.photos.length > 1) ...[
                const SizedBox(height: 12),
                const Text('Photos',
                    style:
                        TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: p.photos.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 8),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(p.photos[i],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.person))),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

//  Profile card 
class _ProfileApprovalCard extends StatelessWidget {
  final ProfileModel profile;
  final String type;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onUndoReject;
  final VoidCallback onRevoke;
  final VoidCallback onViewDetail;

  const _ProfileApprovalCard({
    required this.profile,
    required this.type,
    required this.onApprove,
    required this.onReject,
    required this.onUndoReject,
    required this.onRevoke,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final p = profile;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onViewDetail,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: p.photos.isNotEmpty
                        ? AssetImage(p.photos.first)
                        : null,
                    backgroundColor: AppColors.primary,
                    onBackgroundImageError:
                        p.photos.isNotEmpty ? (_, __) {} : null,
                    child: p.photos.isEmpty
                        ? Text(p.name[0],
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white))
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onViewDetail,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(p.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(width: 6),
                            _StatusBadge(type: type),
                          ],
                        ),
                        Text(
                          '${p.age} yrs  ${p.education}  ${p.occupation}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                        Text(
                          '${p.city}, ${p.state}  ${p.religion} / ${p.caste}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20),
                  color: AppColors.textSecondary,
                  onPressed: onViewDetail,
                  tooltip: 'View Details',
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (type == 'pending') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onReject,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve'),
                    ),
                  ),
                ],
              ),
            ] else if (type == 'approved') ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onRevoke,
                  icon: const Icon(Icons.undo, size: 16),
                  label: const Text('Revoke Approval'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.orange),
                ),
              ),
            ] else if (type == 'rejected') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onUndoReject,
                      icon: const Icon(Icons.restore, size: 16),
                      label: const Text('Move to Pending'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onApprove,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve Anyway'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String type;
  const _StatusBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (type) {
      'approved' => (AppColors.success, 'Approved'),
      'rejected' => (Colors.red, 'Rejected'),
      _ => (Colors.orange, 'Pending'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4))),
      child: Text(label,
          style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
                Text(value,
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
