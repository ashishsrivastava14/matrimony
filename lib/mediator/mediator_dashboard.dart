import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import '../widgets/stat_card.dart';
import '../l10n/app_localizations.dart';

class MediatorDashboard extends StatelessWidget {
  const MediatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final mediators = MockDataService.getMockMediators();
    final mediator = mediators.isNotEmpty ? mediators.first : null;
    final profiles = MockDataService.getMockProfiles();

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
            Text(l10n.mediatorDashboard),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(
            onPressed: () {
              appState.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/role-selection', (_) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome
            Text(
              l10n.welcomeMediator(mediator?.name ?? 'Mediator'),
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'ID: ${mediator?.id ?? "MED-001"} · ${mediator?.district ?? "Chennai"}, ${mediator?.state ?? "Tamil Nadu"}',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Stats grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                StatCard(
                  title: l10n.totalProfiles,
                  value: '${mediator?.totalProfiles ?? 24}',
                  icon: Icons.people,
                  color: AppColors.primary,
                ),
                StatCard(
                  title: l10n.activeMatches,
                  value: '${mediator?.activeMatches ?? 8}',
                  icon: Icons.handshake,
                  color: AppColors.accent,
                ),
                StatCard(
                  title: l10n.commission,
                  value:
                      '₹${mediator?.commissionEarned.toStringAsFixed(0) ?? "15,000"}',
                  icon: Icons.currency_rupee,
                  color: AppColors.success,
                ),
                StatCard(
                  title: l10n.walletBalance,
                  value:
                      '₹${mediator?.walletBalance.toStringAsFixed(0) ?? "8,500"}',
                  icon: Icons.account_balance_wallet,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Performance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.performanceOverview,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildProgressRow(
                        l10n.profileApprovals, 22, 24, AppColors.success),
                    const SizedBox(height: 12),
                    _buildProgressRow(
                        l10n.successfulMatches, 8, 24, AppColors.primary),
                    const SizedBox(height: 12),
                    _buildProgressRow(
                        l10n.pendingReviews, 2, 24, AppColors.accent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recent profiles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.recentProfiles,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...profiles.take(5).map((p) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          p.photos.isNotEmpty
                              ? p.photos.first
                              : 'assets/images/profiles/profile_68.jpg'),
                      onBackgroundImageError: (_, _) {},
                    ),
                    title: Text(p.name,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      '${p.age} yrs · ${p.education} · ${p.city}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.isVerified
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        p.isVerified ? l10n.verified : l10n.pendingTab,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: p.isVerified
                              ? AppColors.success
                              : AppColors.accent,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/match-detail',
                        arguments: p),
                  ),
                )),

            const SizedBox(height: 20),

            // Recent matches
            Text(l10n.recentSuccessfulMatches,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...[
              _matchRow('Karthick S.', 'Priya D.', '₹2,000', 'Completed'),
              _matchRow('Rajesh K.', 'Meena R.', '₹2,000', 'Completed'),
              _matchRow('Suresh M.', 'Divya S.', '₹2,000', 'Processing'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(
      String label, int current, int total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('$current / $total',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _matchRow(
      String groom, String bride, String commission, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.favorite, color: Colors.white, size: 18),
        ),
        title: Text('$groom & $bride',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: Text('Commission: $commission',
            style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: status == 'Completed'
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: status == 'Completed'
                  ? AppColors.success
                  : AppColors.accent,
            ),
          ),
        ),
      ),
    );
  }
}
