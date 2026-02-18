import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/mock_data.dart';

class SubscriptionManagementScreen extends StatelessWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = MockDataService.getMockPlans();
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Subscription Management',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Revenue summary
            LayoutBuilder(builder: (context, constraints) {
              final cols = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.0,
                children: [
                  _metricCard('Active Subscribers', '2,345', AppColors.primary),
                  _metricCard('Monthly Revenue', '₹3.2L', AppColors.success),
                  _metricCard('Total Revenue', '₹28L', AppColors.accent),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Plans table
            const Text('Active Plans',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...plans.map((plan) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(plan.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  if (plan.isPopular) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: const Text('Popular',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10)),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${plan.price.toStringAsFixed(0)} · ${plan.durationMonths} months · ${plan.contactViews} contacts',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${245 + plans.indexOf(plan) * 120} users',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const Text('Active',
                                style: TextStyle(
                                    color: AppColors.success, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _showEditPlanDialog(context, plan.name),
                          icon: const Icon(Icons.edit, size: 20),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 20),

            // Recent subscriptions
            const Text('Recent Subscriptions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._recentSubs.map((s) => Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(s['name']![0])),
                    title: Text(s['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    subtitle: Text('${s['plan']} · ${s['date']}',
                        style: const TextStyle(fontSize: 12)),
                    trailing: Text(s['amount']!,
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

  Widget _metricCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  void _showEditPlanDialog(BuildContext context, String planName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $planName Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                decoration: const InputDecoration(labelText: 'Price (₹)')),
            const SizedBox(height: 12),
            TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Duration (months)')),
            const SizedBox(height: 12),
            TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Contact Views')),
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
                SnackBar(
                    content: Text('$planName plan updated!'),
                    backgroundColor: AppColors.success),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  static const _recentSubs = [
    {'name': 'Priya S.', 'plan': 'Gold', 'date': '10 Jan 2025', 'amount': '₹3,999'},
    {'name': 'Karthick R.', 'plan': 'Diamond', 'date': '09 Jan 2025', 'amount': '₹6,999'},
    {'name': 'Meena D.', 'plan': 'Silver', 'date': '08 Jan 2025', 'amount': '₹1,499'},
    {'name': 'Rajesh K.', 'plan': 'Gold', 'date': '07 Jan 2025', 'amount': '₹3,999'},
    {'name': 'Anjali P.', 'plan': 'Diamond', 'date': '06 Jan 2025', 'amount': '₹6,999'},
  ];
}
