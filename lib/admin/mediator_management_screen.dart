import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/mock_data.dart';
import '../l10n/app_localizations.dart';

class MediatorManagementScreen extends StatefulWidget {
  const MediatorManagementScreen({super.key});

  @override
  State<MediatorManagementScreen> createState() =>
      _MediatorManagementScreenState();
}

class _MediatorManagementScreenState extends State<MediatorManagementScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediators = MockDataService.getMockMediators();
    final filtered = mediators.where((m) {
      if (_search.isNotEmpty &&
          !m.name.toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.mediatorManagement,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showAddMediatorDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.addMediator),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: l10n.searchMediators,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
            const SizedBox(height: 16),

            // Summary cards
            Row(
              children: [
                _summaryCard(l10n.totalLabel, '${filtered.length}', AppColors.primary),
                const SizedBox(width: 12),
                _summaryCard(l10n.active, '${filtered.where((m) => m.isActive).length}', AppColors.success),
                const SizedBox(width: 12),
                _summaryCard(l10n.avgCommission, '₹12,000', AppColors.accent),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final m = filtered[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Text(m.name[0],
                                    style: const TextStyle(
                                        color: Colors.white)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(m.name,
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold)),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2),
                                          decoration: BoxDecoration(
                                            color: m.isActive
                                                ? AppColors.success
                                                    .withValues(alpha: 0.1)
                                                : Colors.red
                                                    .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            m.isActive
                                                ? l10n.active
                                                : l10n.inactive,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: m.isActive
                                                  ? AppColors.success
                                                  : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${m.phone} · ${m.district}, ${m.state}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (v) {},
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                      value: 'edit',
                                      child: Text(l10n.editItem)),
                                  PopupMenuItem(
                                      value: 'toggle',
                                      child: Text(l10n.toggleStatus)),
                                  PopupMenuItem(
                                      value: 'delete',
                                      child: Text(l10n.deleteItem)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              _statItem(l10n.profiles,
                                  '${m.totalProfiles}'),
                              _statItem(l10n.matches,
                                  '${m.activeMatches}'),
                              _statItem(l10n.commission,
                                  '₹${m.commissionEarned.toStringAsFixed(0)}'),
                              _statItem(l10n.wallet,
                                  '₹${m.walletBalance.toStringAsFixed(0)}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color)),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  void _showAddMediatorDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addNewMediator),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(decoration: InputDecoration(labelText: l10n.nameLabel)),
            const SizedBox(height: 10),
            TextFormField(decoration: InputDecoration(labelText: l10n.phoneLabel)),
            const SizedBox(height: 10),
            TextFormField(decoration: InputDecoration(labelText: l10n.district)),
            const SizedBox(height: 10),
            TextFormField(decoration: InputDecoration(labelText: l10n.commissionRate)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(l10n.mediatorAdded),
                    backgroundColor: AppColors.success),
              );
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }
}
