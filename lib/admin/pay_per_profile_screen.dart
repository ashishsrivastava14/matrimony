import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/subscription_plan.dart';
import '../providers/app_state.dart';

class PayPerProfileScreen extends StatefulWidget {
  const PayPerProfileScreen({super.key});

  @override
  State<PayPerProfileScreen> createState() =>
      _PayPerProfileScreenState();
}

class _PayPerProfileScreenState
    extends State<PayPerProfileScreen> {
  //  Local pricing settings 
  double _basePrice = 149;
  bool _pricingDirty = false;

  //  Recent purchases (local demo data) 
  final List<Map<String, String>> _recentPurchases = [
    {'name': 'Priya S.', 'bundle': '5 Unlocks', 'date': '10 Jan', 'amount': '₹599'},
    {'name': 'Karthick R.', 'bundle': '10 Unlocks', 'date': '09 Jan', 'amount': '₹999'},
    {'name': 'Rajesh K.', 'bundle': '1 Unlock', 'date': '08 Jan', 'amount': '₹149'},
    {'name': 'Meena D.', 'bundle': '5 Unlocks', 'date': '07 Jan', 'amount': '₹599'},
    {'name': 'Arun M.', 'bundle': '10 Unlocks', 'date': '06 Jan', 'amount': '₹999'},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final bundles = appState.bundles;

    final totalUnlocks = bundles.fold(0, (s, b) => s + b.unlockCount);
    final totalRevenue = bundles.fold(0.0, (s, b) => s + b.price);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Flexible(
                  child: Text(l10n.payPerProfileSettings,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () =>
                      _showBundleDialog(context, appState),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.addBundle),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                _statCard(l10n.totalUnlocksSold, '${_recentPurchases.length * 4}+', AppColors.primary),
                const SizedBox(width: 12),
                _statCard('Bundles', '${bundles.length}', AppColors.success),
                const SizedBox(width: 12),
                _statCard(l10n.avgPerUser, '${bundles.isNotEmpty ? (totalUnlocks / bundles.length).toStringAsFixed(1) : "0"}', AppColors.accent),
              ],
            ),
            const SizedBox(height: 24),

            // Base price slider
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        const Text('Base Price Per Profile',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const Spacer(),
                        Text('₹${_basePrice.toInt()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Minimum price per profile unlock.',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                    Slider(
                      value: _basePrice,
                      min: 49,
                      max: 499,
                      divisions: 90,
                      label: '₹${_basePrice.toInt()}',
                      onChanged: (v) =>
                          setState(() { _basePrice = v; _pricingDirty = true; }),
                    ),
                    if (_pricingDirty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          onPressed: () {
                            setState(() => _pricingDirty = false);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Base price saved'),
                              backgroundColor: AppColors.success,
                              duration: Duration(seconds: 2),
                            ));
                          },
                          child: const Text('Save'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bundle list
            Text(l10n.activeBundlesTitle,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (bundles.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No bundles yet. Tap "Add Bundle" to create one.',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              ...bundles.asMap().entries.map((entry) {
                final i = entry.key;
                final b = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        // Count badge
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (b.isEnabled
                                    ? AppColors.primary
                                    : Colors.grey)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${b.unlockCount}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: b.isEnabled
                                  ? AppColors.primary
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${b.unlockCount} Profile Unlock${b.unlockCount > 1 ? "s" : ""}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: (b.isEnabled
                                              ? AppColors.success
                                              : Colors.grey)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      b.isEnabled ? 'Active' : 'Inactive',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: b.isEnabled
                                              ? AppColors.success
                                              : Colors.grey),
                                    ),
                                  ),
                                ],
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
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: b.isEnabled
                                  ? AppColors.accent
                                  : Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        PopupMenuButton<String>(
                          onSelected: (v) {
                            switch (v) {
                              case 'edit':
                                _showBundleDialog(context, appState, bundle: b);
                                break;
                              case 'toggle':
                                appState.toggleBundle(b.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(b.isEnabled
                                        ? 'Bundle disabled'
                                        : 'Bundle enabled'),
                                    backgroundColor: b.isEnabled
                                        ? Colors.orange
                                        : AppColors.success,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                break;
                              case 'delete':
                                _confirmDelete(context, appState, b);
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
                                  b.isEnabled
                                      ? Icons.toggle_off
                                      : Icons.toggle_on,
                                  size: 18,
                                  color: b.isEnabled
                                      ? Colors.orange
                                      : AppColors.success,
                                ),
                                const SizedBox(width: 8),
                                Text(b.isEnabled ? 'Disable' : 'Enable',
                                    style: TextStyle(
                                        color: b.isEnabled
                                            ? Colors.orange
                                            : AppColors.success)),
                              ]),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(children: [
                                Icon(Icons.delete_forever,
                                    size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Recent purchases
            Row(
              children: [
                const Icon(Icons.history,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('Recent Purchases',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ..._recentPurchases.map((p) => Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(p['name']![0],
                            style: const TextStyle(
                                color: Colors.white))),
                    title: Text(p['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                    subtitle: Text(
                        '${p['bundle']}  ${p['date']}',
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

  //  Add / Edit dialog 
  void _showBundleDialog(BuildContext context, AppState appState,
      {ProfileUnlockBundle? bundle}) {
    final isEdit = bundle != null;
    final countCtrl = TextEditingController(
        text: isEdit ? '${bundle.profileCount}' : '');
    final priceCtrl = TextEditingController(
        text: isEdit ? bundle.price.toStringAsFixed(0) : '');
    bool isEnabled = bundle?.isEnabled ?? true;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) =>
          StatefulBuilder(builder: (ctx, setLocal) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Bundle' : 'Add New Bundle'),
          content: SizedBox(
            width: 340,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: countCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Number of Unlocks',
                        prefixIcon: Icon(Icons.lock_open)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (int.tryParse(v) == null || int.parse(v) < 1) return 'Must be  1';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Price (₹)',
                        prefixIcon: Icon(Icons.currency_rupee)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null || double.parse(v) < 1) return 'Must be  1';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Active'),
                    value: isEnabled,
                    onChanged: (v) => setLocal(() => isEnabled = v),
                  ),
                  if (countCtrl.text.isNotEmpty &&
                      priceCtrl.text.isNotEmpty)
                    Text(
                      '₹${(double.tryParse(priceCtrl.text) ?? 0) / (int.tryParse(countCtrl.text) ?? 1)} per profile',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary),
                    ),
                ],
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
                final count = int.parse(countCtrl.text);
                final price = double.parse(priceCtrl.text);
                if (isEdit) {
                  appState.updateBundle(bundle.copyWith(
                    profileCount: count,
                    price: price,
                    isEnabled: isEnabled,
                  ));
                } else {
                  final newId =
                      'BUN_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
                  appState.addBundle(ProfileUnlockBundle(
                    id: newId,
                    profileCount: count,
                    price: price,
                    isEnabled: isEnabled,
                  ));
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text(isEdit ? 'Bundle updated' : 'Bundle added'),
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

  void _confirmDelete(BuildContext context, AppState appState,
      ProfileUnlockBundle b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Bundle'),
        content: Text(
            'Delete "${b.unlockCount} Unlock" bundle? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              appState.deleteBundle(b.id);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                content: Text('Bundle deleted'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ));
            },
            child: const Text('Delete'),
          ),
        ],
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
                      fontSize: 11,
                      color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
