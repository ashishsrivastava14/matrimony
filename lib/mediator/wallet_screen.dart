import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/mock_data.dart';
import '../l10n/app_localizations.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final transactions = MockDataService.getMockTransactions();

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
            Text(l10n.wallet),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.walletBalance,
                      style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text(
                    '₹8,500',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showWithdrawDialog(context),
                          icon: const Icon(Icons.arrow_downward,
                              size: 18),
                          label: Text(l10n.withdraw),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF7B1FA2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.history,
                              size: 18, color: Colors.white),
                          label: Text(l10n.history),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick stats
            Row(
              children: [
                _quickStat(l10n.totalIn, '₹15,000', AppColors.success,
                    Icons.arrow_downward),
                const SizedBox(width: 12),
                _quickStat(l10n.totalOut, '₹6,500', Colors.red,
                    Icons.arrow_upward),
              ],
            ),
            const SizedBox(height: 24),

            // Transactions
            Text(l10n.recentTransactions,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...transactions.map((t) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: t.type == 'credit'
                          ? AppColors.success.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      child: Icon(
                        t.type == 'credit'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: t.type == 'credit'
                            ? AppColors.success
                            : Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(t.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    subtitle: Text(
                      '${t.date.day}/${t.date.month}/${t.date.year} · ${t.status}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    trailing: Text(
                      '${t.type == "credit" ? "+" : "-"}₹${t.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: t.type == 'credit'
                            ? AppColors.success
                            : Colors.red,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _quickStat(
      String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  Text(value,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: color)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Builder(
        builder: (ctx2) {
          final l10n = AppLocalizations.of(ctx2)!;
          return AlertDialog(
            title: Text(l10n.withdrawFunds),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.availableForWithdrawal,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.amount,
                    prefixText: '₹',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: l10n.bankTransfer,
                  decoration:
                      InputDecoration(labelText: l10n.withdrawTo),
                  items: [l10n.bankTransfer, l10n.upi]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.withdrawalSubmittedMsg),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: Text(l10n.withdraw),
              ),
            ],
          );
        },
      ),
    );
  }
}
