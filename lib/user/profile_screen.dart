import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';

/// User profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<AppState>(
      builder: (context, state, _) {
        final user = state.currentUser;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00897B),
                    Color(0xFF26A69A),
                    Color(0xFF00796B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: Row(
              children: [
                Image.asset('assets/icon/app_icon.png', height: 24, width: 24),
                const SizedBox(width: 10),
                Text(l10n.myProfile),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile header card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user?.profileImage != null
                            ? AssetImage(user!.profileImage!)
                            : null,
                        child: user?.profileImage == null
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (user?.isVerified ?? false) ...[
                            const Icon(Icons.verified,
                                size: 16, color: AppColors.verified),
                            const SizedBox(width: 4),
                            const Text('Verified',
                                style: TextStyle(
                                    color: AppColors.verified, fontSize: 13)),
                            const SizedBox(width: 12),
                          ],
                          if (state.isSubscribed) ...[
                            const Icon(Icons.workspace_premium,
                                size: 16, color: AppColors.accent),
                            const SizedBox(width: 4),
                            const Text('Premium Member',
                                style: TextStyle(
                                    color: AppColors.accent, fontSize: 13)),
                          ] else ...[
                            const Text('Free Member',
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13)),
                          ],
                        ],
                      ),
                      if (!state.isSubscribed) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushNamed('/subscription'),
                            icon: const Icon(Icons.star, size: 18),
                            label: Text(l10n.upgradeToPremium),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Quick stats
              Row(
                children: [
                  _QuickStat(
                    label: 'Profile\nCompletion',
                    value: '${state.profileCompletion}%',
                    icon: Icons.pie_chart_outline,
                  ),
                  _QuickStat(
                    label: 'Interests\nSent',
                    value: '${state.sentInterests.length}',
                    icon: Icons.favorite_border,
                  ),
                  _QuickStat(
                    label: 'Interests\nReceived',
                    value: '${state.receivedInterests.length}',
                    icon: Icons.mail_outline,
                  ),
                  _QuickStat(
                    label: 'Profile\nViews',
                    value: '24',
                    icon: Icons.visibility_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Menu items
              Card(
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () =>
                          Navigator.of(context).pushNamed('/profile-creation'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.bookmark,
                      title: 'Shortlisted Profiles',
                      badge: '${state.shortlisted.length}',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.favorite,
                      title: 'Interest Management',
                      onTap: () =>
                          Navigator.of(context).pushNamed('/interests'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.auto_graph,
                      title: 'Horoscope Matching',
                      onTap: () =>
                          Navigator.of(context).pushNamed('/horoscope'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.card_membership,
                      title: 'Subscription Plans',
                      onTap: () =>
                          Navigator.of(context).pushNamed('/subscription'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      badge: state.unreadNotifications > 0
                          ? '${state.unreadNotifications}'
                          : null,
                      onTap: () =>
                          Navigator.of(context).pushNamed('/notifications'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Settings',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Logout
              Card(
                child: _MenuTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  color: AppColors.error,
                  onTap: () {
                    state.logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/role-selection', (_) => false);
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _QuickStat(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final Color? color;
  final VoidCallback? onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.badge,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
      onTap: onTap,
    );
  }
}
