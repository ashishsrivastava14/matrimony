import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/user_model.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<UserModel> _applyFilter(List<UserModel> users) {
    return users.where((u) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!u.name.toLowerCase().contains(q) &&
            !u.email.toLowerCase().contains(q) &&
            !u.phone.toLowerCase().contains(q)) {
          return false;
        }
      }
      switch (_filterStatus) {
        case 'Verified':
          return u.isVerified && !u.isBlocked;
        case 'Premium':
          return u.isPremium && !u.isBlocked;
        case 'Blocked':
          return u.isBlocked;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final filtered = _applyFilter(appState.allUsers);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.userManagement,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                FilledButton.icon(
                  onPressed: () => _showUserDialog(context, appState),
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Add User'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search & filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchUsersHint,
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _filterStatus,
                  items: ['All', 'Verified', 'Premium', 'Blocked']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _filterStatus = v!),
                  underline: const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text('${filtered.length} users found',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),

            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('No users match the current filter.'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final user = filtered[index];
                        return _UserTile(
                          user: user,
                          appState: appState,
                          onEdit: () =>
                              _showUserDialog(context, appState, user: user),
                          onView: () => _showUserDetail(context, user),
                          onDelete: () =>
                              _confirmDelete(context, appState, user),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //  Add / Edit dialog 
  void _showUserDialog(BuildContext context, AppState appState,
      {UserModel? user}) {
    final isEdit = user != null;
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    String role = user?.role ?? 'user';
    bool isVerified = user?.isVerified ?? false;
    bool isPremium = user?.isPremium ?? false;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setLocal) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit User' : 'Add New User'),
          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person)),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Enter valid email'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: const InputDecoration(
                          labelText: 'Role',
                          prefixIcon: Icon(Icons.badge)),
                      items: ['user', 'paid', 'mediator', 'admin']
                          .map((r) =>
                              DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (v) => setLocal(() => role = v!),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Verified'),
                      value: isVerified,
                      onChanged: (v) => setLocal(() => isVerified = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Premium'),
                      value: isPremium,
                      onChanged: (v) => setLocal(() => isPremium = v),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                if (isEdit) {
                  appState.updateUser(user.copyWith(
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    role: role,
                    isVerified: isVerified,
                    isPremium: isPremium,
                  ));
                } else {
                  final newId =
                      'U${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
                  appState.addUser(UserModel(
                    id: newId,
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    role: role,
                    isVerified: isVerified,
                    isPremium: isPremium,
                  ));
                }
                Navigator.pop(ctx);
                _showSnack(
                    context,
                    isEdit
                        ? 'User updated successfully'
                        : 'User added successfully');
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      }),
    );
  }

  //  View user detail 
  void _showUserDetail(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        builder: (_, ctrl) => Padding(
          padding: const EdgeInsets.all(24),
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
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: Text(user.name[0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 28, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(user.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              Center(child: _RoleBadge(role: user.role)),
              const SizedBox(height: 20),
              const Divider(),
              _DetailRow(Icons.email, 'Email', user.email),
              _DetailRow(Icons.phone, 'Phone', user.phone),
              _DetailRow(Icons.fingerprint, 'User ID', user.id),
              _DetailRow(
                  Icons.calendar_today,
                  'Joined',
                  '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'),
              _DetailRow(Icons.verified, 'Verification',
                  user.isVerified ? 'Verified ' : 'Not Verified'),
              _DetailRow(Icons.workspace_premium, 'Premium',
                  user.isPremium ? 'Yes ' : 'No'),
              _DetailRow(
                  Icons.block, 'Status', user.isBlocked ? 'Blocked' : 'Active'),
            ],
          ),
        ),
      ),
    );
  }

  //  Delete confirm 
  void _confirmDelete(
      BuildContext context, AppState appState, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
            'Are you sure you want to delete "${user.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              appState.deleteUser(user.id);
              _showSnack(context, '${user.name} deleted');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }
}

//  User tile 
class _UserTile extends StatelessWidget {
  final UserModel user;
  final AppState appState;
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const _UserTile({
    required this.user,
    required this.appState,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              user.isBlocked ? Colors.red.shade100 : AppColors.primary,
          child: Text(user.name[0].toUpperCase(),
              style: TextStyle(
                  color: user.isBlocked ? Colors.red : Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(user.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration:
                          user.isBlocked ? TextDecoration.lineThrough : null)),
            ),
            if (user.isVerified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified, color: AppColors.verified, size: 16),
            ],
            if (user.isPremium) ...[
              const SizedBox(width: 4),
              const Icon(Icons.workspace_premium,
                  color: AppColors.accent, size: 16),
            ],
            if (user.isBlocked) ...[
              const SizedBox(width: 4),
              const Icon(Icons.block, color: Colors.red, size: 16),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${user.email}  ${user.phone}',
                style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 2),
            _RoleBadge(role: user.role, small: true),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            switch (action) {
              case 'view':
                onView();
                break;
              case 'edit':
                onEdit();
                break;
              case 'verify':
                appState.toggleUserVerification(user.id);
                break;
              case 'block':
                appState.toggleUserBlock(user.id);
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(children: [
                Icon(Icons.person, size: 18),
                SizedBox(width: 8),
                Text('View Profile'),
              ]),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(children: [
                Icon(Icons.edit, size: 18),
                SizedBox(width: 8),
                Text('Edit'),
              ]),
            ),
            PopupMenuItem(
              value: 'verify',
              child: Row(children: [
                Icon(user.isVerified ? Icons.unpublished : Icons.verified,
                    size: 18),
                const SizedBox(width: 8),
                Text(user.isVerified ? 'Unverify' : 'Verify'),
              ]),
            ),
            PopupMenuItem(
              value: 'block',
              child: Row(children: [
                Icon(user.isBlocked ? Icons.lock_open : Icons.block,
                    size: 18,
                    color: user.isBlocked ? AppColors.success : Colors.red),
                const SizedBox(width: 8),
                Text(user.isBlocked ? 'Unblock' : 'Block',
                    style: TextStyle(
                        color:
                            user.isBlocked ? AppColors.success : Colors.red)),
              ]),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Row(children: [
                Icon(Icons.delete_forever, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

//  Helpers 
class _RoleBadge extends StatelessWidget {
  final String role;
  final bool small;
  const _RoleBadge({required this.role, this.small = false});

  Color get _color => switch (role) {
        'admin' => Colors.deepPurple,
        'paid' => AppColors.accent,
        'mediator' => Colors.blue,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: small ? 6 : 8, vertical: small ? 2 : 3),
      decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _color.withValues(alpha: 0.4))),
      child: Text(role.toUpperCase(),
          style: TextStyle(
              fontSize: small ? 9 : 11,
              color: _color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
