import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/mock_data.dart';
import '../widgets/powered_by_footer.dart';

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
    final mediators = MockDataService.getMockMediators();
    final filtered = mediators.where((m) {
      if (_search.isNotEmpty &&
          !m.name.toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      bottomSheet: const PoweredByFooter(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mediator Management',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showAddMediatorDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Mediator'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                hintText: 'Search mediators...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
            const SizedBox(height: 16),

            // Summary cards
            Row(
              children: [
                _summaryCard('Total', '${filtered.length}', AppColors.primary),
                const SizedBox(width: 12),
                _summaryCard('Active', '${filtered.where((m) => m.isActive).length}', AppColors.success),
                const SizedBox(width: 12),
                _summaryCard('Avg Commission', '₹12,000', AppColors.accent),
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
                                                ? 'Active'
                                                : 'Inactive',
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
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit')),
                                  PopupMenuItem(
                                      value: 'toggle',
                                      child: Text('Toggle Status')),
                                  PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete')),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              _statItem('Profiles',
                                  '${m.totalProfiles}'),
                              _statItem('Matches',
                                  '${m.activeMatches}'),
                              _statItem('Commission',
                                  '₹${m.commissionEarned.toStringAsFixed(0)}'),
                              _statItem('Wallet',
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Mediator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextFormField(decoration: const InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 10),
            TextFormField(decoration: const InputDecoration(labelText: 'District')),
            const SizedBox(height: 10),
            TextFormField(decoration: const InputDecoration(labelText: 'Commission Rate (%)')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Mediator added!'),
                    backgroundColor: AppColors.success),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
