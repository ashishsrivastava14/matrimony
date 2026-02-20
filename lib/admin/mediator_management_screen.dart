import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/mediator_model.dart';
import '../providers/app_state.dart';
import '../l10n/app_localizations.dart';

class MediatorManagementScreen extends StatefulWidget {
  const MediatorManagementScreen({super.key});

  @override
  State<MediatorManagementScreen> createState() =>
      _MediatorManagementScreenState();
}

class _MediatorManagementScreenState
    extends State<MediatorManagementScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final filtered = appState.mediators.where((m) {
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        return m.name.toLowerCase().contains(q) ||
            m.phone.toLowerCase().contains(q) ||
            m.email.toLowerCase().contains(q) ||
            m.district.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row – Flexible text prevents overflow
            Row(
              children: [
                Flexible(
                  child: Text(l10n.mediatorManagement,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () =>
                      _showMediatorDialog(context, appState),
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
                _summaryCard(l10n.totalLabel,
                    '${appState.mediators.length}', AppColors.primary),
                const SizedBox(width: 12),
                _summaryCard(
                    l10n.active,
                    '${appState.mediators.where((m) => m.isActive).length}',
                    AppColors.success),
                const SizedBox(width: 12),
                _summaryCard(l10n.avgCommission, '₹12,000',
                    AppColors.accent),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('No mediators found.',
                          style: TextStyle(
                              color: AppColors.textSecondary)))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final m = filtered[index];
                        return _MediatorCard(
                          mediator: m,
                          onEdit: () => _showMediatorDialog(
                              context, appState,
                              mediator: m),
                          onDelete: () =>
                              _confirmDelete(context, appState, m),
                          onToggle: () =>
                              appState.toggleMediatorActive(m.id),
                          onView: () =>
                              _showMediatorDetail(context, m),
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
                      fontSize: 11,
                      color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  //  Add / Edit dialog 
  void _showMediatorDialog(BuildContext context, AppState appState,
      {MediatorModel? mediator}) {
    final isEdit = mediator != null;
    final nameCtrl =
        TextEditingController(text: mediator?.name ?? '');
    final phoneCtrl =
        TextEditingController(text: mediator?.phone ?? '');
    final emailCtrl =
        TextEditingController(text: mediator?.email ?? '');
    final districtCtrl =
        TextEditingController(text: mediator?.district ?? '');
    final stateCtrl =
        TextEditingController(text: mediator?.state ?? 'Tamil Nadu');
    final commissionCtrl = TextEditingController(
        text: mediator != null
            ? mediator.commissionEarned.toStringAsFixed(0)
            : '');
    bool isActive = mediator?.isActive ?? true;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setLocal) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Mediator' : 'Add New Mediator'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person)),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || !v.contains('@'))
                              ? 'Enter valid email'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: districtCtrl,
                            decoration: const InputDecoration(
                                labelText: 'District',
                                prefixIcon:
                                    Icon(Icons.location_city)),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: stateCtrl,
                            decoration: const InputDecoration(
                                labelText: 'State',
                                prefixIcon:
                                    Icon(Icons.map)),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: commissionCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Commission Earned (₹)',
                          prefixIcon:
                              Icon(Icons.currency_rupee)),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (v) =>
                          setLocal(() => isActive = v),
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
                final commission =
                    double.tryParse(commissionCtrl.text) ?? 0;
                if (isEdit) {
                  appState.updateMediator(mediator.copyWith(
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    district: districtCtrl.text.trim(),
                    state: stateCtrl.text.trim(),
                    commissionEarned: commission,
                    isActive: isActive,
                  ));
                } else {
                  final newId =
                      'MED${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
                  appState.addMediator(MediatorModel(
                    id: newId,
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    district: districtCtrl.text.trim(),
                    state: stateCtrl.text.trim(),
                    commissionEarned: commission,
                    isActive: isActive,
                  ));
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(isEdit
                      ? 'Mediator updated successfully'
                      : 'Mediator added successfully'),
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
      BuildContext context, AppState appState, MediatorModel m) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Mediator'),
        content: Text(
            'Are you sure you want to delete "${m.name}"? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              appState.deleteMediator(m.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${m.name} deleted'),
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

  void _showMediatorDetail(BuildContext context, MediatorModel m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        builder: (_, ctrl) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: ctrl,
            children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2))),
              ),
              Center(
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: Text(m.name[0].toUpperCase(),
                      style: const TextStyle(
                          fontSize: 28, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                  child: Text(m.name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
              const SizedBox(height: 4),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                      color: m.isActive
                          ? AppColors.success.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: m.isActive
                              ? AppColors.success.withValues(alpha: 0.4)
                              : Colors.red.withValues(alpha: 0.4))),
                  child: Text(m.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                          fontSize: 11,
                          color: m.isActive
                              ? AppColors.success
                              : Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              _DetailRow(Icons.phone, 'Phone', m.phone),
              _DetailRow(Icons.email, 'Email', m.email),
              _DetailRow(Icons.location_city, 'Location',
                  '${m.district}, ${m.state}'),
              _DetailRow(Icons.fingerprint, 'ID', m.id),
              _DetailRow(
                  Icons.calendar_today,
                  'Joined',
                  '${m.joinedAt.day}/${m.joinedAt.month}/${m.joinedAt.year}'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem('Profiles', '${m.totalProfiles}'),
                  _statItem('Matches', '${m.activeMatches}'),
                  _statItem('Commission',
                      '₹${m.commissionEarned.toStringAsFixed(0)}'),
                  _statItem('Wallet',
                      '₹${m.walletBalance.toStringAsFixed(0)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  Mediator card 
class _MediatorCard extends StatelessWidget {
  final MediatorModel mediator;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onView;

  const _MediatorCard({
    required this.mediator,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final m = mediator;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onView,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(m.name[0],
                        style:
                            const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onView,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(m.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
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
                                m.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: m.isActive
                                        ? AppColors.success
                                        : Colors.red),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${m.phone}  ${m.district}, ${m.state}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    switch (v) {
                      case 'view':
                        onView();
                        break;
                      case 'edit':
                        onEdit();
                        break;
                      case 'toggle':
                        onToggle();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(children: [
                        Icon(Icons.person, size: 18),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ]),
                    ),
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
                            m.isActive
                                ? Icons.toggle_off
                                : Icons.toggle_on,
                            size: 18,
                            color: m.isActive
                                ? Colors.orange
                                : AppColors.success),
                        const SizedBox(width: 8),
                        Text(m.isActive ? 'Deactivate' : 'Activate',
                            style: TextStyle(
                                color: m.isActive
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('Profiles', '${m.totalProfiles}'),
                _statItem('Matches', '${m.activeMatches}'),
                _statItem('Commission',
                    '₹${m.commissionEarned.toStringAsFixed(0)}'),
                _statItem(
                    'Wallet', '₹${m.walletBalance.toStringAsFixed(0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//  Helpers 
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
                Text(value,
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
