import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../models/profile_model.dart';
import '../widgets/verified_badge.dart';
import '../widgets/user_bottom_navigation.dart';
import '../l10n/app_localizations.dart';

/// Full profile detail page for a match
class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile =
        ModalRoute.of(context)!.settings.arguments as ProfileModel;

    return Consumer<AppState>(
      builder: (context, state, _) {
        final isShortlisted = state.isShortlisted(profile.id);
        final canViewContact = state.isProfileUnlocked(profile.id);

        return Scaffold(
          bottomNavigationBar: const UserBottomNavigation(),
          body: CustomScrollView(
            slivers: [
              // Profile image sliver app bar
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        profile.profileImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.person, size: 80),
                        ),
                      ),
                      // Gradient overlay
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                            stops: [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Photo count + verified badge
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            if (profile.isPhotoVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.verified_user,
                                        size: 14, color: Colors.greenAccent),
                                    const SizedBox(width: 4),
                                    Text(l10n.photoVerified,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '1/${profile.photos.length}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/horoscope'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.auto_graph,
                                        size: 14, color: Colors.orangeAccent),
                                    const SizedBox(width: 4),
                                    Text(l10n.viewHoroscope,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isShortlisted ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () => state.toggleShortlist(profile),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges
                      VerifiedBadge(
                        isVerified: profile.isVerified,
                        isPremium: profile.isPremium,
                      ),
                      const SizedBox(height: 10),

                      // Name & basic
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${profile.membershipId} | Last active at ${_timeAgo(profile.lastActive)}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${profile.age} yrs, ${profile.height}, ${profile.caste}, ${profile.education}, ${profile.occupation}',
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textSecondary),
                      ),
                      Text(
                        profile.city,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textSecondary),
                      ),

                      const SizedBox(height: 16),

                      // Action buttons — all in one row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Don't Show
                          _ActionIcon(
                            icon: Icons.close,
                            label: l10n.dontShow,
                            color: AppColors.error,
                            filled: false,
                            onTap: () {
                              state.hideProfile(profile.id);
                              Navigator.of(context).pop();
                            },
                          ),
                          // Send Interest
                          _ActionIcon(
                            icon: Icons.favorite,
                            label: l10n.sendInterest,
                            color: AppColors.accent,
                            filled: true,
                            onTap: () {
                              state.sendInterest(profile.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      l10n.interestSentTo(profile.name)),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                          ),
                          if (!canViewContact) ...[(
                            // Upgrade to View
                            _ActionIcon(
                              icon: Icons.workspace_premium,
                              label: 'Upgrade',
                              color: AppColors.premiumGold,
                              filled: true,
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/subscription'),
                            )
                          ), (
                            // Unlock
                            _ActionIcon(
                              icon: Icons.lock_open,
                              label: 'Unlock (1)',
                              color: AppColors.primary,
                              filled: false,
                              onTap: () {
                                if (state.useUnlock(profile.id)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(l10n.contactUnlocked)),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'No unlocks remaining. Please upgrade.'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              },
                            )
                          )],
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Contact section (phone display only)
                      _ContactSection(
                        canView: canViewContact,
                        phone: '+91 90*** *****X',
                      ),

                      const Divider(height: 32),

                      // About
                      _SectionTitle(l10n.aboutProfile(profile.name)),
                      const SizedBox(height: 8),
                      Text(
                        profile.aboutMe.isNotEmpty
                            ? profile.aboutMe
                            : l10n.noDescriptionProvided,
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5),
                      ),

                      const Divider(height: 32),

                      // Basic Details
                      _SectionTitle(l10n.basicDetails),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        l10n.age: l10n.ageYears(profile.age.toString()),
                        l10n.height: profile.height,
                        l10n.maritalStatus: profile.maritalStatus,
                        l10n.motherTongue: profile.motherTongue,
                        l10n.religion: profile.religion,
                        l10n.caste: profile.caste,
                        l10n.diet: profile.diet,
                      }),

                      const Divider(height: 32),

                      // Education & Career
                      _SectionTitle(l10n.educationAndCareer),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        l10n.education: profile.education,
                        l10n.occupation: profile.occupation,
                        l10n.employedIn: profile.employedIn,
                        l10n.annualIncome: profile.annualIncome,
                      }),

                      const Divider(height: 32),

                      // Family
                      _SectionTitle(l10n.familyDetailsTitle),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        l10n.familyType: profile.familyType,
                        l10n.familyStatus: profile.familyStatus,
                        l10n.brothers: '${profile.brothers}',
                        l10n.sisters: '${profile.sisters}',
                      }),

                      const Divider(height: 32),

                      // Location
                      _SectionTitle(l10n.locationTitle),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        l10n.city: profile.city,
                        l10n.state: profile.state,
                        l10n.country: profile.country,
                      }),

                      if (profile.star != null || profile.rasi != null) ...[  
                        const Divider(height: 32),
                        _SectionTitle(l10n.horoscopeTitle),
                        const SizedBox(height: 8),
                        _DetailGrid(items: {
                          if (profile.star != null) l10n.star: profile.star!,
                          if (profile.rasi != null) l10n.rasi: profile.rasi!,
                          if (profile.dosham != null)
                            l10n.dosham: profile.dosham!,
                          if (profile.dob != null) l10n.dateOfBirth: profile.dob!,
                        }),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              if (!state.canAccessHoroscope) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(l10n.horoscopeMatching),
                                    content: Text(l10n.allowHoroscopeCompatibility),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(l10n.cancel),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).pushNamed('/subscription');
                                        },
                                        child: Text(l10n.subscriptionPlans),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                              Navigator.of(context).pushNamed('/horoscope');
                            },
                            icon: const Icon(Icons.auto_graph),
                            label:
                                Text(l10n.checkHoroscopeCompatibility),
                          ),
                        ),
                      ],

                      const Divider(height: 32),

                      // Partner Preferences
                      _SectionTitle(l10n.partnerPreferencesTitle),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        l10n.age: profile.partnerAgeRange,
                        l10n.height: profile.partnerHeightRange,
                        l10n.education: profile.partnerEducation,
                        l10n.occupation: profile.partnerOccupation,
                        l10n.location: profile.partnerLocation,
                      }),

                      const Divider(height: 32),

                      // Report
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(l10n.profileReported)),
                            );
                          },
                          icon: const Icon(Icons.flag_outlined,
                              color: AppColors.error),
                          label: Text(l10n.reportThisProfile,
                              style: const TextStyle(color: AppColors.error)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      return '${h}h ${m}m ago';
    }
    return '${diff.inDays}d ago';
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _DetailGrid extends StatelessWidget {
  final Map<String, String> items;
  const _DetailGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: items.entries.map((e) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 24,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.key,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  e.value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ContactSection extends StatelessWidget {
  final bool canView;
  final String phone;

  const _ContactSection({
    required this.canView,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: canView
          ? AppColors.success.withValues(alpha: 0.05)
          : Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.phone,
                color: canView ? AppColors.success : AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                canView ? '+91 98765 43211' : phone,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: canView
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback? onTap;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? color : color.withValues(alpha: 0.07),
              border: filled ? null : Border.all(color: color, width: 1.8),
              boxShadow: filled
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.38),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: filled ? Colors.white : color,
              size: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: filled ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
