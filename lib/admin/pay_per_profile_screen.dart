import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/mock_data.dart';

class PayPerProfileScreen extends StatelessWidget {
  const PayPerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bundles = MockDataService.getMockBundles();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pay Per Profile Settings',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showAddBundleDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Bundle'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                _statCard('Total Unlocks Sold', '3,428', AppColors.primary),
                const SizedBox(width: 12),
                _statCard('Revenue', '₹3.5L', AppColors.success),
                const SizedBox(width: 12),
                _statCard('Avg Per User', '2.4', AppColors.accent),
              ],
            ),
            const SizedBox(height: 24),

            // Active bundles
            const Text('Active Bundles',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...bundles.map((b) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${b.unlockCount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${b.unlockCount} Profile Unlock${b.unlockCount > 1 ? "s" : ""}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Text(
                                '₹${(b.price / b.unlockCount).toStringAsFixed(0)} per profile',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${b.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent),
                        ),
                        const SizedBox(width: 8),
                        PopupMenuButton<String>(
                          onSelected: (v) {},
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                                value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete')),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 24),

            // Recent purchases
            const Text('Recent Purchases',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._recentPurchases.map((p) => Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(p['name']![0])),
                    title: Text(p['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    subtitle: Text('${p['bundle']} · ${p['date']}',
                        style: const TextStyle(fontSize: 12)),
                    trailing: Text(p['amount']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBundleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Bundle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Number of Unlocks'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price (₹)'),
              keyboardType: TextInputType.number,
            ),
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
                    content: Text('Bundle added!'),
                    backgroundColor: AppColors.success),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  static const _recentPurchases = [
    {'name': 'Priya S.', 'bundle': '5 Unlocks', 'date': '10 Jan', 'amount': '₹349'},
    {'name': 'Karthick R.', 'bundle': '10 Unlocks', 'date': '09 Jan', 'amount': '₹599'},
    {'name': 'Rajesh K.', 'bundle': '1 Unlock', 'date': '08 Jan', 'amount': '₹99'},
    {'name': 'Meena D.', 'bundle': '5 Unlocks', 'date': '07 Jan', 'amount': '₹349'},
    {'name': 'Arun M.', 'bundle': '10 Unlocks', 'date': '06 Jan', 'amount': '₹599'},
  ];
}
