import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/mock_data.dart';
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
    final profiles = MockDataService.getMockProfiles();

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
              Tab(text: l10n.pendingLabel(profiles.where((p) => !p.isVerified).length)),
              Tab(text: l10n.approvedLabel(profiles.where((p) => p.isVerified).length)),
              Tab(text: l10n.rejectedLabel),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileList(profiles.where((p) => !p.isVerified).toList(), 'pending'),
                _buildProfileList(profiles.where((p) => p.isVerified).toList(), 'approved'),
                Center(
                    child: Text(l10n.noRejectedProfiles,
                        style: const TextStyle(color: AppColors.textSecondary))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileList(List profiles, String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final p = profiles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(
                          p.photos.isNotEmpty
                              ? p.photos.first
                              : 'assets/images/profiles/profile_68.jpg'),
                      onBackgroundImageError: (_, _) {},
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text(
                            '${p.age} yrs · ${p.education} · ${p.occupation}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                          Text(
                            '${p.city}, ${p.state} · ${p.religion} / ${p.caste}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (type == 'pending') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(AppLocalizations.of(context)!.rejectedName(p.name)),
                                  backgroundColor: Colors.red),
                            );
                          },
                          icon: const Icon(Icons.close, size: 16),
                          label: Text(AppLocalizations.of(context)!.reject),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.approvedName(p.name)),
                                backgroundColor: AppColors.success),
                          );
                          },
                          icon: const Icon(Icons.check, size: 16),
                          label: Text(AppLocalizations.of(context)!.approve),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
