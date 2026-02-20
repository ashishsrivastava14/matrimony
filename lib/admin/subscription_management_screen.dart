import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/subscription_plan.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final plans = appState.plans;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(l10n.subscriptionManagement,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () => _showPlanDialog(context, appState),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Plan'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Metric cards
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

            // Plans list
            Text(l10n.activePlans,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (plans.isEmpty)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No plans yet. Add one to get started.'),
              ))
            else
              ...plans.map((plan) => _PlanCard(
                    plan: plan,
                    userCount: 245 + plans.indexOf(plan) * 120,
                    onEdit: () =>
                        _showPlanDialog(context, appState, plan: plan),
                    onDelete: () =>
                        _confirmDelete(context, appState, plan),
                    onToggleEnabled: () =>
                        appState.togglePlanEnabled(plan.id),
                  )),

            const SizedBox(height: 20),

            // Recent subscriptions
            const Text('Recent Subscriptions',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._recentSubs.map((s) => Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(s['name']![0])),
                    title: Text(s['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    subtitle: Text('${s['plan']}  ${s['date']}',
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

  //  Add / Edit dialog 
  void _showPlanDialog(BuildContext context, AppState appState,
      {SubscriptionPlan? plan}) {
    final isEdit = plan != null;
    final nameCtrl =
        TextEditingController(text: plan?.name ?? '');
    final priceCtrl = TextEditingController(
        text: plan != null ? plan.price.toStringAsFixed(0) : '');
    final origPriceCtrl = TextEditingController(
        text: plan != null ? plan.originalPrice.toStringAsFixed(0) : '');
    final durationMonthsCtrl = TextEditingController(
        text: plan != null ? plan.durationMonths.toString() : '');
    final contactViewsCtrl = TextEditingController(
        text: plan != null ? plan.contactViews.toString() : '');
    // Features stored as newline-separated text
    final featuresCtrl = TextEditingController(
        text: plan != null ? plan.features.join('\n') : '');
    String duration = plan?.duration ?? 'Monthly';
    bool isPopular = plan?.isPopular ?? false;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setLocal) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Plan' : 'Add New Plan'),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Plan Name',
                          prefixIcon: Icon(Icons.card_membership)),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: duration,
                      decoration: const InputDecoration(
                          labelText: 'Duration Type',
                          prefixIcon: Icon(Icons.date_range)),
                      items: ['Monthly', 'Quarterly', 'Yearly']
                          .map((d) =>
                              DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) => setLocal(() => duration = v!),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: durationMonthsCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Months',
                                prefixIcon: Icon(Icons.calendar_today)),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: contactViewsCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Contact Views',
                                prefixIcon: Icon(Icons.visibility)),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: priceCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Price (₹)',
                                prefixIcon: Icon(Icons.currency_rupee)),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: origPriceCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Original Price (₹)',
                                prefixIcon: Icon(Icons.currency_rupee)),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: featuresCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Features (one per line)',
                        prefixIcon: Icon(Icons.list),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Add at least one feature'
                          : null,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mark as Popular'),
                      value: isPopular,
                      onChanged: (v) => setLocal(() => isPopular = v),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final features = featuresCtrl.text
                    .split('\n')
                    .map((l) => l.trim())
                    .where((l) => l.isNotEmpty)
                    .toList();
                if (isEdit) {
                  appState.updatePlan(plan.copyWith(
                    name: nameCtrl.text.trim(),
                    duration: duration,
                    price: double.parse(priceCtrl.text),
                    originalPrice: double.parse(origPriceCtrl.text),
                    durationMonths: int.parse(durationMonthsCtrl.text),
                    contactViews: int.parse(contactViewsCtrl.text),
                    features: features,
                    isPopular: isPopular,
                  ));
                } else {
                  final newId =
                      'PLAN_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
                  appState.addPlan(SubscriptionPlan(
                    id: newId,
                    name: nameCtrl.text.trim(),
                    duration: duration,
                    price: double.parse(priceCtrl.text),
                    originalPrice: double.parse(origPriceCtrl.text),
                    durationMonths: int.parse(durationMonthsCtrl.text),
                    contactViews: int.parse(contactViewsCtrl.text),
                    features: features,
                    isPopular: isPopular,
                  ));
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(isEdit
                      ? 'Plan updated successfully'
                      : 'Plan added successfully'),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ));
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      }),
    );
  }

  void _confirmDelete(
      BuildContext context, AppState appState, SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Plan'),
        content: Text(
            'Are you sure you want to delete the "${plan.name}" plan? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              appState.deletePlan(plan.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('"${plan.name}" plan deleted'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static const _recentSubs = [
    {
      'name': 'Priya S.',
      'plan': 'Gold',
      'date': '10 Jan 2025',
      'amount': '₹3,999'
    },
    {
      'name': 'Karthick R.',
      'plan': 'Diamond',
      'date': '09 Jan 2025',
      'amount': '₹6,999'
    },
    {
      'name': 'Meena D.',
      'plan': 'Silver',
      'date': '08 Jan 2025',
      'amount': '₹1,499'
    },
    {
      'name': 'Rajesh K.',
      'plan': 'Gold',
      'date': '07 Jan 2025',
      'amount': '₹3,999'
    },
    {
      'name': 'Anjali P.',
      'plan': 'Diamond',
      'date': '06 Jan 2025',
      'amount': '₹6,999'
    },
  ];
}

//  Plan card 
class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final int userCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleEnabled;

  const _PlanCard({
    required this.plan,
    required this.userCount,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
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
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      if (plan.isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('POPULAR',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 9)),
                        ),
                      ],
                      if (!plan.isEnabled) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('DISABLED',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 9)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${plan.price.toStringAsFixed(0)}  ${plan.durationMonths} months  ${plan.contactViews} contacts',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plan.features.take(2).join('  '),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$userCount users',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(plan.isEnabled ? 'Active' : 'Disabled',
                    style: TextStyle(
                        color: plan.isEnabled
                            ? AppColors.success
                            : Colors.grey,
                        fontSize: 12)),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (action) {
                switch (action) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'toggle':
                    onToggleEnabled();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'toggle',
                  child: Row(children: [
                    Icon(
                        plan.isEnabled
                            ? Icons.toggle_off
                            : Icons.toggle_on,
                        size: 18),
                    const SizedBox(width: 8),
                    Text(plan.isEnabled ? 'Disable' : 'Enable'),
                  ]),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_forever, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
