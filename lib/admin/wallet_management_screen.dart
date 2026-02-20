import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/wallet_transaction.dart';
import '../providers/app_state.dart';

class WalletManagementScreen extends StatefulWidget {
  const WalletManagementScreen({super.key});

  @override
  State<WalletManagementScreen> createState() =>
      _WalletManagementScreenState();
}

class _WalletManagementScreenState
    extends State<WalletManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();

    final pending = appState.pendingWithdrawals;
    final approved = appState.approvedTransactions;
    final rejected = appState.rejectedTransactions;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Flexible(
                  child: Text(l10n.walletManagement,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () =>
                      _showAddTransactionDialog(context, appState),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Summary cards
            Row(
              children: [
                _summaryCard(l10n.totalPlatformRevenue,
                    '₹${_fmt(appState.totalPlatformRevenue)}',
                    AppColors.primary),
                const SizedBox(width: 8),
                _summaryCard(l10n.pendingPayouts,
                    '₹${_fmt(appState.totalPendingPayouts)}',
                    AppColors.accent),
                const SizedBox(width: 8),
                _summaryCard(l10n.completedPayouts,
                    '₹${_fmt(appState.totalCompletedPayouts)}',
                    AppColors.success),
              ],
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search by description or user ID',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
            const SizedBox(height: 12),

            // Tabs
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                    text:
                        '${l10n.pendingWithdrawalRequests.split(' ').first} (${pending.length})'),
                Tab(text: '${l10n.approved} (${approved.length})'),
                Tab(text: '${l10n.rejected} (${rejected.length})'),
              ],
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _transactionList(
                      context: context,
                      appState: appState,
                      transactions: _filter(pending),
                      showActions: true),
                  _transactionList(
                      context: context,
                      appState: appState,
                      transactions: _filter(approved),
                      showActions: false),
                  _transactionList(
                      context: context,
                      appState: appState,
                      transactions: _filter(rejected),
                      showActions: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<WalletTransaction> _filter(List<WalletTransaction> list) {
    if (_search.trim().isEmpty) return list;
    final q = _search.toLowerCase();
    return list
        .where((t) =>
            t.description.toLowerCase().contains(q) ||
            t.userId.toLowerCase().contains(q))
        .toList();
  }

  Widget _transactionList({
    required BuildContext context,
    required AppState appState,
    required List<WalletTransaction> transactions,
    required bool showActions,
  }) {
    final l10n = AppLocalizations.of(context)!;
    if (transactions.isEmpty) {
      return const Center(
          child: Text('No transactions.',
              style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (_, i) {
        final t = transactions[i];
        return _TransactionCard(
          transaction: t,
          showActions: showActions,
          onApprove: () {
            appState.approveTransaction(t.id);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.requestApproved(t.userId)),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ));
          },
          onReject: () =>
              _showRejectDialog(context, appState, t),
          onDelete: () =>
              _confirmDelete(context, appState, t),
          onView: () => _showDetail(context, t),
        );
      },
    );
  }

  //  Reject with reason dialog 
  void _showRejectDialog(
      BuildContext context, AppState appState, WalletTransaction t) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Withdrawal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reject withdrawal of ₹${_fmt(t.amount)} for ${t.userId}?',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            const Text('This action cannot be undone.',
                style: TextStyle(
                    color: Colors.red, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              appState.rejectTransaction(t.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.requestRejected),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ));
            },
            child: Text(l10n.reject),
          ),
        ],
      ),
    );
  }

  //  Delete confirm 
  void _confirmDelete(
      BuildContext context, AppState appState, WalletTransaction t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content:
            Text('Delete transaction ${t.id} permanently?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              appState.deleteTransaction(t.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Transaction deleted'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2)),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  //  Add transaction dialog 
  void _showAddTransactionDialog(
      BuildContext context, AppState appState) {
    final formKey = GlobalKey<FormState>();
    final userCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String type = 'credit';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setLocal) {
        return AlertDialog(
          title: const Text('Add Transaction'),
          content: SizedBox(
            width: 380,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: userCtrl,
                    decoration: const InputDecoration(
                        labelText: 'User / Mediator ID',
                        prefixIcon: Icon(Icons.person)),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description)),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: amountCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Amount (₹)',
                        prefixIcon:
                            Icon(Icons.currency_rupee)),
                    keyboardType:
                        TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (v) =>
                        (v == null || v.isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: type,
                    decoration: const InputDecoration(
                        labelText: 'Type',
                        prefixIcon: Icon(Icons.swap_horiz)),
                    items: const [
                      DropdownMenuItem(
                          value: 'credit',
                          child: Text('Credit')),
                      DropdownMenuItem(
                          value: 'debit',
                          child: Text('Debit')),
                      DropdownMenuItem(
                          value: 'withdrawal',
                          child: Text('Withdrawal')),
                    ],
                    onChanged: (v) =>
                        setLocal(() => type = v ?? 'credit'),
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
                final newId =
                    'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
                appState.addTransaction(WalletTransaction(
                  id: newId,
                  userId: userCtrl.text.trim(),
                  type: type,
                  amount:
                      double.tryParse(amountCtrl.text) ?? 0,
                  description: descCtrl.text.trim(),
                  status: type == 'withdrawal'
                      ? 'pending'
                      : 'approved',
                  date: DateTime.now(),
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Transaction added successfully'),
                      backgroundColor: AppColors.success,
                      duration: Duration(seconds: 2)),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      }),
    );
  }

  //  Transaction detail bottom sheet 
  void _showDetail(BuildContext context, WalletTransaction t) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text('Transaction Detail',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _detailRow('ID', t.id),
            _detailRow('User / Mediator', t.userId),
            _detailRow('Type', t.type.toUpperCase()),
            _detailRow('Amount', '₹${_fmt(t.amount)}'),
            _detailRow('Description', t.description),
            _detailRow('Status', t.status.toUpperCase()),
            _detailRow(
                'Date',
                '${t.date.day}/${t.date.month}/${t.date.year}'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
              width: 130,
              child: Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13))),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 100000) {
      return '${(v / 100000).toStringAsFixed(1)}L';
    } else if (v >= 1000) {
      return '${(v / 1000).toStringAsFixed(1)}K';
    }
    return v.toStringAsFixed(0);
  }
}

//  Transaction card widget 
class _TransactionCard extends StatelessWidget {
  final WalletTransaction transaction;
  final bool showActions;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const _TransactionCard({
    required this.transaction,
    required this.showActions,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isWithdrawal = t.type == 'withdrawal';
    final Color typeColor = t.type == 'credit'
        ? AppColors.success
        : t.type == 'withdrawal'
            ? AppColors.accent
            : Colors.red;
    final IconData typeIcon = t.type == 'credit'
        ? Icons.arrow_downward
        : t.type == 'withdrawal'
            ? Icons.account_balance
            : Icons.arrow_upward;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: typeColor.withValues(alpha: 0.15),
                child: Icon(typeIcon, color: typeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(t.description,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 6),
                        _StatusBadge(t.status),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                        '${t.userId}  ${t.type.toUpperCase()}  ${t.date.day}/${t.date.month}/${t.date.year}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('₹${_fmtAmount(t.amount)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: typeColor)),
              const SizedBox(width: 4),
              PopupMenuButton<String>(
                onSelected: (v) {
                  switch (v) {
                    case 'view':
                      onView();
                      break;
                    case 'approve':
                      onApprove();
                      break;
                    case 'reject':
                      onReject();
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
                        Icon(Icons.info_outline, size: 18),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ])),
                  if (showActions) ...[
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                        value: 'approve',
                        child: Row(children: [
                          Icon(Icons.check_circle,
                              size: 18,
                              color: AppColors.success),
                          SizedBox(width: 8),
                          Text('Approve',
                              style: TextStyle(
                                  color: AppColors.success)),
                        ])),
                    const PopupMenuItem(
                        value: 'reject',
                        child: Row(children: [
                          Icon(Icons.cancel,
                              size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Reject',
                              style:
                                  TextStyle(color: Colors.red)),
                        ])),
                  ],
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete_forever,
                            size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete',
                            style:
                                TextStyle(color: Colors.red)),
                      ])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtAmount(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final color = status == 'approved'
        ? AppColors.success
        : status == 'rejected'
            ? Colors.red
            : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.4))),
      child: Text(status.toUpperCase(),
          style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold)),
    );
  }
}
