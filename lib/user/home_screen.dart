import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../l10n/app_localizations.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/profile_card.dart';
import '../widgets/premium_banner.dart';

/// User home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<AppState>(
      builder: (context, state, _) {
        final profiles = state.profiles;
        final recentlyJoined = profiles.take(6).toList();
        final suggested = profiles.reversed.take(5).toList();

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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset('assets/icon/app_icon.png', width: 20, height: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.appTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 11,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.poweredBy,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Notification bell
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Badge(
                    label: Text('${state.unreadNotifications}'),
                    isLabelVisible: state.unreadNotifications > 0,
                    child: const Icon(Icons.notifications_outlined, color: Colors.white),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/notifications'),
                ),
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
                  title: l10n.recentlyJoined,
                  subtitle: l10n.newProfilesOnPlatform,
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
                  title: l10n.suggestedMatches,
                  subtitle: l10n.matchesBasedOnPreferences('${profiles.length}'),
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
                              content: Text(l10n.interestSentTo(p.name)),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        onDontShow: () => state.hideProfile(p.id),
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
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.hiName(name),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  completion < 80
                      ? l10n.completeProfileForMatches
                      : l10n.profileLookingGreat,
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
              child: Text(l10n.completeButton),
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
    final l10n = AppLocalizations.of(context)!;
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
              child: Text(l10n.viewAll),
            ),
        ],
      ),
    );
  }
}
