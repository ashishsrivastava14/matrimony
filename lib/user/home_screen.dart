import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/profile_card.dart';
import '../widgets/premium_banner.dart';
import '../widgets/powered_by_footer.dart';

/// User home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final profiles = state.profiles;
        final recentlyJoined = profiles.take(6).toList();
        final suggested = profiles.reversed.take(5).toList();

        return Scaffold(
          bottomSheet: const PoweredByFooter(),
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.favorite, size: 24),
                const SizedBox(width: 8),
                const Text('AP Matrimony'),
              ],
            ),
            actions: [
              // Notification bell
              IconButton(
                icon: Badge(
                  label: Text('${state.unreadNotifications}'),
                  isLabelVisible: state.unreadNotifications > 0,
                  child: const Icon(Icons.notifications_outlined),
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/notifications'),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                // Profile completion card
                _ProfileCompletionCard(
                  completion: state.profileCompletion,
                  name: state.currentUser?.name ?? 'User',
                ),

                // Premium banner (only for non-premium)
                if (!state.isSubscribed)
                  PremiumBanner(
                    onUpgrade: () =>
                        Navigator.of(context).pushNamed('/subscription'),
                  ),

                const SizedBox(height: 16),

                // Recently Joined
                _SectionHeader(
                  title: 'Recently Joined',
                  subtitle: 'New profiles on the platform',
                  onViewAll: () {},
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recentlyJoined.length,
                    itemBuilder: (_, i) => ProfileCardCompact(
                      profile: recentlyJoined[i],
                      onTap: () => Navigator.of(context).pushNamed(
                        '/match-detail',
                        arguments: recentlyJoined[i],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Suggested Matches
                _SectionHeader(
                  title: 'Suggested Matches',
                  subtitle: '${profiles.length} matches based on your preferences',
                  onViewAll: () {},
                ),
                ...suggested.map((p) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ProfileCard(
                        profile: p,
                        onTap: () => Navigator.of(context).pushNamed(
                          '/match-detail',
                          arguments: p,
                        ),
                        onSendInterest: () {
                          state.sendInterest(p.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Interest sent to ${p.name}'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        onDontShow: () {},
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileCompletionCard extends StatelessWidget {
  final int completion;
  final String name;

  const _ProfileCompletionCard({
    required this.completion,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 36,
            lineWidth: 6,
            percent: completion / 100,
            center: Text(
              '$completion%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
            progressColor: AppColors.primary,
            backgroundColor: AppColors.divider,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi $name!',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  completion < 80
                      ? 'Complete your profile to get more matches'
                      : 'Your profile is looking great!',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (completion < 80)
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/profile-creation'),
              child: const Text('Complete'),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onViewAll;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
        ],
      ),
    );
  }
}
