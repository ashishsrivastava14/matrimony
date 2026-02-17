import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../models/profile_model.dart';
import '../widgets/filter_bottom_sheet.dart';

/// Search screen with quick search, filters, and results
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _profileIdController = TextEditingController();
  bool _nearbyEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _profileIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'By Criteria'),
            Tab(text: 'By Profile ID'),
            Tab(text: 'Saved Search'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ByCriteriaTab(nearbyEnabled: _nearbyEnabled, onNearbyToggle: (v) {
            setState(() => _nearbyEnabled = v);
          }),
          _ByProfileIdTab(controller: _profileIdController),
          const _SavedSearchTab(),
        ],
      ),
    );
  }
}

class _ByCriteriaTab extends StatelessWidget {
  final bool nearbyEnabled;
  final ValueChanged<bool> onNearbyToggle;

  const _ByCriteriaTab({
    required this.nearbyEnabled,
    required this.onNearbyToggle,
  });

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<AppState>().profiles;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Nearby toggle
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on, color: AppColors.primary),
            title: const Text('Nearby Profiles'),
            subtitle: const Text('Matches near your location'),
            trailing: Switch(
              value: nearbyEnabled,
              onChanged: onNearbyToggle,
              activeColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Filter button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => FilterBottomSheet.show(context),
            icon: const Icon(Icons.tune),
            label: const Text('Advanced Filters'),
          ),
        ),
        const SizedBox(height: 16),

        // Search results
        ...profiles.take(4).map((p) => _SearchResultCard(profile: p)),

        const SizedBox(height: 16),
        Center(
          child: Text(
            '${profiles.length} matches based on your preferences',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('View More'),
          ),
        ),
      ],
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final ProfileModel profile;

  const _SearchResultCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          '/match-detail',
          arguments: profile,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Photo
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      profile.profileImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person),
                      ),
                    ),
                  ),
                  if (profile.isPhotoVerified)
                    Positioned(
                      bottom: 2,
                      left: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_user,
                                size: 10, color: Colors.greenAccent),
                            SizedBox(width: 2),
                            Text('Photo Verified',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 7)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (profile.isVerified)
                          const Icon(Icons.verified,
                              size: 14, color: AppColors.verified),
                        if (profile.isVerified) const SizedBox(width: 4),
                        if (profile.isPremium)
                          const Icon(Icons.workspace_premium,
                              size: 14, color: AppColors.accent),
                        if (profile.isPremium) const SizedBox(width: 4),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${profile.age} yrs, ${profile.height} • ${profile.caste} • ${profile.education}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '• ${profile.occupation} • ${profile.city}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ByProfileIdTab extends StatelessWidget {
  final TextEditingController controller;

  const _ByProfileIdTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.badge_outlined,
              size: 48, color: AppColors.primary),
          const SizedBox(height: 16),
          const Text(
            'Search by Profile ID',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter the member ID to find a specific profile',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Profile ID',
              hintText: 'e.g., M1234567',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Searching...')),
                );
              },
              child: const Text('Search'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedSearchTab extends StatelessWidget {
  const _SavedSearchTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No Saved Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Save your search criteria for quick access',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
