import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../models/profile_model.dart';
import '../widgets/verified_badge.dart';
import '../widgets/user_bottom_navigation.dart';

/// Full profile detail page for a match
class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile =
        ModalRoute.of(context)!.settings.arguments as ProfileModel;

    return Consumer<AppState>(
      builder: (context, state, _) {
        final isShortlisted = state.isShortlisted(profile.id);
        final canViewContact = state.isSubscribed || state.unlockCount > 0;

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
                                child: const Row(
                                  children: [
                                    Icon(Icons.verified_user,
                                        size: 14, color: Colors.greenAccent),
                                    SizedBox(width: 4),
                                    Text('Photo Verified',
                                        style: TextStyle(
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
                                child: const Row(
                                  children: [
                                    Icon(Icons.auto_graph,
                                        size: 14, color: Colors.orangeAccent),
                                    SizedBox(width: 4),
                                    Text('View Horoscope',
                                        style: TextStyle(
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

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.close, size: 18),
                              label: const Text("Don't Show"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                state.sendInterest(profile.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Interest sent to ${profile.name}'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.favorite, size: 18),
                              label: const Text('Send Interest'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Contact section
                      _ContactSection(
                        canView: canViewContact,
                        phone: '+91 90*** *****X',
                        onUpgrade: () =>
                            Navigator.of(context).pushNamed('/subscription'),
                        onUnlock: () {
                          if (state.useUnlock()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Contact unlocked!')),
                            );
                          }
                        },
                      ),

                      const Divider(height: 32),

                      // About
                      _SectionTitle('About ${profile.name}'),
                      const SizedBox(height: 8),
                      Text(
                        profile.aboutMe.isNotEmpty
                            ? profile.aboutMe
                            : 'No description provided.',
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5),
                      ),

                      const Divider(height: 32),

                      // Basic Details
                      _SectionTitle('Basic Details'),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        'Age': '${profile.age} years',
                        'Height': profile.height,
                        'Marital Status': profile.maritalStatus,
                        'Mother Tongue': profile.motherTongue,
                        'Religion': profile.religion,
                        'Caste': profile.caste,
                        'Diet': profile.diet,
                      }),

                      const Divider(height: 32),

                      // Education & Career
                      _SectionTitle('Education & Career'),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        'Education': profile.education,
                        'Occupation': profile.occupation,
                        'Employed In': profile.employedIn,
                        'Annual Income': profile.annualIncome,
                      }),

                      const Divider(height: 32),

                      // Family
                      _SectionTitle('Family Details'),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        'Family Type': profile.familyType,
                        'Family Status': profile.familyStatus,
                        'Brothers': '${profile.brothers}',
                        'Sisters': '${profile.sisters}',
                      }),

                      const Divider(height: 32),

                      // Location
                      _SectionTitle('Location'),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        'City': profile.city,
                        'State': profile.state,
                        'Country': profile.country,
                      }),

                      if (profile.star != null || profile.rasi != null) ...[
                        const Divider(height: 32),
                        _SectionTitle('Horoscope'),
                        const SizedBox(height: 8),
                        _DetailGrid(items: {
                          if (profile.star != null) 'Star': profile.star!,
                          if (profile.rasi != null) 'Rasi': profile.rasi!,
                          if (profile.dosham != null)
                            'Dosham': profile.dosham!,
                          if (profile.dob != null) 'DOB': profile.dob!,
                        }),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushNamed('/horoscope'),
                            icon: const Icon(Icons.auto_graph),
                            label:
                                const Text('Check Horoscope Compatibility'),
                          ),
                        ),
                      ],

                      const Divider(height: 32),

                      // Partner Preferences
                      _SectionTitle('Partner Preferences'),
                      const SizedBox(height: 8),
                      _DetailGrid(items: {
                        'Age': profile.partnerAgeRange,
                        'Height': profile.partnerHeightRange,
                        'Education': profile.partnerEducation,
                        'Occupation': profile.partnerOccupation,
                        'Location': profile.partnerLocation,
                      }),

                      const Divider(height: 32),

                      // Report
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Profile reported.')),
                            );
                          },
                          icon: const Icon(Icons.flag_outlined,
                              color: AppColors.error),
                          label: const Text('Report this Profile',
                              style: TextStyle(color: AppColors.error)),
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
  final VoidCallback? onUpgrade;
  final VoidCallback? onUnlock;

  const _ContactSection({
    required this.canView,
    required this.phone,
    this.onUpgrade,
    this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: canView ? AppColors.success.withValues(alpha: 0.05) : Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
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
            if (!canView) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onUpgrade,
                      child: const Text('Upgrade to View'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onUnlock,
                    child: const Text('Unlock (1)'),
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
