import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import '../l10n/app_localizations.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final users = MockDataService.getMockUsers();
    final filtered = users.where((u) {
      if (_searchQuery.isNotEmpty &&
          !u.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_filterStatus == 'Verified' && !u.isVerified) return false;
      if (_filterStatus == 'Premium' && !u.isPremium) return false;
      if (_filterStatus == 'Blocked' && !appState.blockedUsers.contains(u.id)) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.userManagement,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final user = filtered[index];
                  final isBlocked =
                      appState.blockedUsers.contains(user.id);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(user.name[0]),
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified,
                                color: AppColors.verified, size: 16),
                          ],
                          if (user.isPremium) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.workspace_premium,
                                color: AppColors.accent, size: 16),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '${user.email} · ${user.role}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) {
                          if (action == 'block') {
                            appState.toggleUserBlock(user.id);
                          } else if (action == 'verify') {
                            appState.toggleUserVerification(user.id);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'verify',
                            child: Text(user.isVerified
                                ? 'Unverify'
                                : 'Verify'),
                          ),
                          PopupMenuItem(
                            value: 'block',
                            child: Text(
                                isBlocked ? 'Unblock' : 'Block'),
                          ),
                          const PopupMenuItem(
                            value: 'view',
                            child: Text('View Profile'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
