import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../models/profile_model.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
            Text(l10n.search),
          ],
        ),
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
          const _ByCriteriaTab(),
          _ByProfileIdTab(controller: _profileIdController),
          const _SavedSearchTab(),
        ],
      ),
    );
  }
}

// 
// By Criteria Tab � fully functional filtering
// 

class _ByCriteriaTab extends StatefulWidget {
  const _ByCriteriaTab();

  @override
  State<_ByCriteriaTab> createState() => _ByCriteriaTabState();
}

class _ByCriteriaTabState extends State<_ByCriteriaTab> {
  final _nameController = TextEditingController();
  Map<String, dynamic> _filters = {};
  bool _showAll = false;
  bool _nearbyEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<ProfileModel> _applyFilters(List<ProfileModel> all) {
    final query = _nameController.text.trim().toLowerCase();

    return all.where((p) {
      // Name / keyword filter
      if (query.isNotEmpty &&
          !p.name.toLowerCase().contains(query) &&
          !p.occupation.toLowerCase().contains(query) &&
          !p.city.toLowerCase().contains(query) &&
          !p.caste.toLowerCase().contains(query)) {
        return false;
      }

      // Age
      final ageMin = _filters['ageMin'] as int?;
      final ageMax = _filters['ageMax'] as int?;
      if (ageMin != null && p.age < ageMin) return false;
      if (ageMax != null && p.age > ageMax) return false;

      // Religion
      final religion = _filters['religion'] as String?;
      if (religion != null && religion != 'Any' && p.religion != religion) {
        return false;
      }

      // Caste
      final caste = _filters['caste'] as String?;
      if (caste != null && caste != 'Any' && p.caste != caste) return false;

      // Education (loose partial match)
      final education = _filters['education'] as String?;
      if (education != null && education != 'Any') {
        final key = education.split('/')[0].toLowerCase().replaceAll('.', '').replaceAll(' ', '');
        final pEdu = p.education.toLowerCase().replaceAll('.', '').replaceAll(' ', '');
        if (!pEdu.contains(key)) return false;
      }

      // Location / city
      final location = _filters['location'] as String?;
      if (location != null && location != 'Any' && p.city != location) {
        return false;
      }

      // Marital status
      final marital = _filters['maritalStatus'] as String?;
      if (marital != null && marital != 'Any' && p.maritalStatus != marital) {
        return false;
      }

      // Nearby � restrict to Tamil Nadu
      if (_nearbyEnabled && p.state != 'Tamil Nadu') return false;

      return true;
    }).toList();
  }

  Future<void> _openFilters() async {
    final result = await FilterBottomSheet.show(context);
    if (result != null) {
      setState(() {
        _filters = result;
        _showAll = false;
      });
    }
  }

  bool get _hasActiveFilters {
    if (_filters.isEmpty) return false;
    return _filters.entries.any((e) {
      if (e.value == null || e.value == 'Any') return false;
      if (e.key == 'ageMin' && e.value == 21) return false;
      if (e.key == 'ageMax' && e.value == 35) return false;
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allProfiles = context.watch<AppState>().profiles;
    final filtered = _applyFilters(allProfiles);
    final displayed = _showAll ? filtered : filtered.take(6).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _nameController,
            onChanged: (_) => setState(() => _showAll = false),
            decoration: InputDecoration(
              hintText: 'Search by name, occupation, city',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _nameController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _nameController.clear();
                        setState(() => _showAll = false);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
          ),
        ),

        // Filter / nearby row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openFilters,
                  icon: Icon(
                    Icons.tune,
                    color: _hasActiveFilters ? AppColors.primary : null,
                  ),
                  label: Text(
                    _hasActiveFilters ? 'Filters applied' : l10n.advancedFilters,
                    style: TextStyle(
                      color: _hasActiveFilters ? AppColors.primary : null,
                    ),
                  ),
                  style: _hasActiveFilters
                      ? OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Nearby'),
                selected: _nearbyEnabled,
                onSelected: (v) => setState(() {
                  _nearbyEnabled = v;
                  _showAll = false;
                }),
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                checkmarkColor: AppColors.primary,
              ),
            ],
          ),
        ),

        // Result count row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${filtered.length} profile${filtered.length == 1 ? '' : 's'} found',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (_hasActiveFilters || _nameController.text.isNotEmpty || _nearbyEnabled)
                TextButton(
                  onPressed: () => setState(() {
                    _filters = {};
                    _nameController.clear();
                    _nearbyEnabled = false;
                    _showAll = false;
                  }),
                  child: const Text('Clear all'),
                ),
            ],
          ),
        ),

        // Results
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Text(
                        'No profiles match your search',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() {
                          _filters = {};
                          _nameController.clear();
                          _nearbyEnabled = false;
                        }),
                        child: const Text('Reset filters'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  itemCount: displayed.length +
                      (!_showAll && filtered.length > 6 ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i < displayed.length) {
                      return _SearchResultCard(profile: displayed[i]);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ElevatedButton(
                        onPressed: () => setState(() => _showAll = true),
                        child: Text('View all ${filtered.length} results'),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// 
// Search Result Card
// 

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
                      errorBuilder: (_, _, _) => Container(
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
                        if (profile.isVerified) ...[
                          const Icon(Icons.verified,
                              size: 14, color: AppColors.verified),
                          const SizedBox(width: 4),
                        ],
                        if (profile.isPremium) ...[
                          const Icon(Icons.workspace_premium,
                              size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          profile.membershipId,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${profile.age} yrs, ${profile.height}  ${profile.caste}  ${profile.education}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${profile.occupation}  ${profile.city}',
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

// 
// By Profile ID Tab � functional search
// 

class _ByProfileIdTab extends StatefulWidget {
  final TextEditingController controller;

  const _ByProfileIdTab({required this.controller});

  @override
  State<_ByProfileIdTab> createState() => _ByProfileIdTabState();
}

class _ByProfileIdTabState extends State<_ByProfileIdTab> {
  List<ProfileModel> _results = [];
  bool _searched = false;
  bool _loading = false;

  void _doSearch(BuildContext context) async {
    final query = widget.controller.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a Profile ID, Member ID, or name')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _searched = false;
      _results = [];
    });

    final allProfiles = context.read<AppState>().profiles;

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final lower = query.toLowerCase();

    final matches = allProfiles.where((p) {
      return p.id.toLowerCase() == lower ||
          p.membershipId.toLowerCase() == lower ||
          p.membershipId.toLowerCase().contains(lower) ||
          p.name.toLowerCase().contains(lower);
    }).toList();

    if (mounted) {
      setState(() {
        _results = matches;
        _searched = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.badge_outlined, size: 48, color: AppColors.primary),
        const SizedBox(height: 16),
        const Text(
          'Search by Profile ID',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter Profile ID (e.g. P011), Member ID (e.g. M1234577), or name',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: widget.controller,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _doSearch(context),
          onChanged: (_) {
            if (_searched) setState(() => _searched = false);
          },
          decoration: InputDecoration(
            labelText: 'Profile ID / Member ID / Name',
            hintText: 'e.g., P011  or  M1234577  or  Divya',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                      setState(() {
                        _results = [];
                        _searched = false;
                      });
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _loading ? null : () => _doSearch(context),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Text(l10n.search),
          ),
        ),
        const SizedBox(height: 24),

        if (_searched && _results.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  'No profile found for "${widget.controller.text}"',
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

        if (_results.isNotEmpty) ...[
          Text(
            '${_results.length} result${_results.length == 1 ? '' : 's'} found',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          ..._results.map((p) => _SearchResultCard(profile: p)),
        ],
      ],
    );
  }
}

// 
// Saved Search Tab
// 

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
