import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/profile_card.dart';

/// Matches screen with tabs: All, Newly Joined, filters
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'Relevance';

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
    return Consumer<AppState>(
      builder: (context, state, _) {
        final profiles = state.profiles;

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
                const SizedBox(width: 8),
                // Regular / Prime toggle
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Regular',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('PRIME',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 3),
                      Icon(Icons.star, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.translate),
                onPressed: () {},
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                const Tab(text: 'All Matches'),
                Tab(text: 'Newly Joined (${profiles.length})'),
                const Tab(text: 'More'),
              ],
            ),
          ),
          body: Column(
            children: [
              // Match count + filter bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      '${profiles.length} Matches based on your ',
                      style: const TextStyle(fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Partner Preferences',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Filter chips
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        icon: Icons.filter_alt_outlined,
                        label: 'Filter',
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Sort by',
                        icon: Icons.sort,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => _SortSheet(
                              selected: _sortBy,
                              onSelect: (v) {
                                setState(() => _sortBy = v);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(label: 'Newly Joined', onTap: () {}),
                      const SizedBox(width: 8),
                      _FilterChip(label: 'Not Seen', onTap: () {}),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),

              // Profile list
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _MatchList(profiles: profiles, state: state),
                    _MatchList(
                        profiles: profiles.where((p) => p.age < 27).toList(),
                        state: state),
                    _MatchList(
                        profiles:
                            profiles.where((p) => p.isPremium).toList(),
                        state: state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MatchList extends StatelessWidget {
  final List profiles;
  final AppState state;

  const _MatchList({required this.profiles, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      itemCount: profiles.length,
      itemBuilder: (_, i) {
        final p = profiles[i];
        return ProfileCard(
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
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const _FilterChip({required this.label, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _SortSheet({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = [
      'Relevance',
      'Newest First',
      'Last Active',
      'Age: Low to High',
      'Age: High to Low'
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...options.map((o) => ListTile(
                title: Text(o),
                trailing: selected == o
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => onSelect(o),
              )),
        ],
      ),
    );
  }
}
