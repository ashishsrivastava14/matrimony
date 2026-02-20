import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import '../l10n/app_localizations.dart';

class MediatorDashboard extends StatelessWidget {
  const MediatorDashboard({super.key});

  // ── Gradient presets for stat cards ──────────────────────────
  static const _cardGradients = [
    [Color(0xFF00897B), Color(0xFF26A69A)],
    [Color(0xFFFF6F00), Color(0xFFFFB74D)],
    [Color(0xFF43A047), Color(0xFF80C783)],
    [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final mediators = MockDataService.getMockMediators();
    final mediator = mediators.isNotEmpty ? mediators.first : null;
    final profiles = MockDataService.getMockProfiles();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          // ── Gradient SliverAppBar ──────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF00897B), Color(0xFF26A69A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -40,
                      right: -30,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    // Profile info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFB74D), Color(0xFFFF6F00)],
                              ),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 34),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.welcomeMediator(mediator?.name ?? 'Mediator'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.badge_outlined, color: Colors.white70, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            mediator?.id ?? 'MED-001',
                                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.location_on_outlined, color: Colors.white70, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            mediator?.district ?? 'Chennai',
                                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
                icon: const Badge(
                  label: Text('3'),
                  child: Icon(Icons.notifications_outlined, color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () {
                  appState.logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/role-selection', (_) => false);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
            title: const Text('Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stat Cards ──────────────────────────────────
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.55,
                    children: [
                      _gradientStatCard(
                        label: l10n.totalProfiles,
                        value: '${mediator?.totalProfiles ?? 45}',
                        icon: Icons.people_alt_rounded,
                        gradientColors: _cardGradients[0],
                      ),
                      _gradientStatCard(
                        label: l10n.activeMatches,
                        value: '${mediator?.activeMatches ?? 12}',
                        icon: Icons.handshake_rounded,
                        gradientColors: _cardGradients[1],
                      ),
                      _gradientStatCard(
                        label: l10n.commission,
                        value: '₹${mediator?.commissionEarned.toStringAsFixed(0) ?? "25,000"}',
                        icon: Icons.currency_rupee_rounded,
                        gradientColors: _cardGradients[2],
                      ),
                      _gradientStatCard(
                        label: l10n.walletBalance,
                        value: '₹${mediator?.walletBalance.toStringAsFixed(0) ?? "8,500"}',
                        icon: Icons.account_balance_wallet_rounded,
                        gradientColors: _cardGradients[3],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Performance Overview ─────────────────────────
                  _sectionHeader(l10n.performanceOverview, icon: Icons.bar_chart_rounded),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildProgressRow(l10n.profileApprovals, 22, 24, _cardGradients[0]),
                        const SizedBox(height: 16),
                        _buildProgressRow(l10n.successfulMatches, 8, 24, _cardGradients[1]),
                        const SizedBox(height: 16),
                        _buildProgressRow(l10n.pendingReviews, 2, 24, _cardGradients[2]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Recent Profiles ─────────────────────────────
                  _sectionHeader(l10n.recentProfiles,
                      icon: Icons.person_search_rounded,
                      trailing: TextButton(
                        onPressed: () {},
                        child: Text(l10n.viewAll,
                            style: const TextStyle(
                                color: AppColors.primary, fontWeight: FontWeight.w600)),
                      )),
                  const SizedBox(height: 10),
                  ...profiles.take(5).map((p) => _profileCard(context, p, l10n)),

                  const SizedBox(height: 24),

                  // ── Recent Matches ──────────────────────────────
                  _sectionHeader(l10n.recentSuccessfulMatches, icon: Icons.favorite_rounded),
                  const SizedBox(height: 10),
                  _matchTile('Karthick S.', 'Priya D.', '₹2,000', 'Completed'),
                  _matchTile('Rajesh K.', 'Meena R.', '₹2,000', 'Completed'),
                  _matchTile('Suresh M.', 'Divya S.', '₹2,000', 'Processing'),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Gradient stat card
  // ─────────────────────────────────────────────────────────────
  Widget _gradientStatCard({
    required String label,
    required String value,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Section header
  // ─────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, {required IconData icon, Widget? trailing}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        ?trailing,
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Progress row
  // ─────────────────────────────────────────────────────────────
  Widget _buildProgressRow(String label, int current, int total, List<Color> gradientColors) {
    final pct = current / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$current / $total',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: pct,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Profile card
  // ─────────────────────────────────────────────────────────────
  Widget _profileCard(BuildContext context, dynamic p, dynamic l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              p.photos.isNotEmpty
                  ? p.photos.first
                  : 'assets/images/profiles/profile_68.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.primary.withValues(alpha: 0.15),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ),
        ),
        title: Text(p.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            '${p.age} yrs · ${p.education}',
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: p.isVerified
                  ? [const Color(0xFF43A047), const Color(0xFF80C783)]
                  : [const Color(0xFFFF6F00), const Color(0xFFFFB74D)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            p.isVerified ? l10n.verified : l10n.pendingTab,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        onTap: () =>
            Navigator.pushNamed(context, '/match-detail', arguments: p),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Match tile
  // ─────────────────────────────────────────────────────────────
  Widget _matchTile(String groom, String bride, String commission, String status) {
    final isCompleted = status == 'Completed';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFFF06292)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
        ),
        title: Text(
          '$groom & $bride',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            'Commission: $commission',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCompleted
                  ? [const Color(0xFF43A047), const Color(0xFF80C783)]
                  : [const Color(0xFFFF6F00), const Color(0xFFFFB74D)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
