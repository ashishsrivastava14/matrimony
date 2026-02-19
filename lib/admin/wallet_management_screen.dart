import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';

class WalletManagementScreen extends StatelessWidget {
  const WalletManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.walletManagement,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Summary
            Row(
              children: [
                _card(l10n.totalPlatformRevenue, '₹28,00,000', AppColors.primary),
                const SizedBox(width: 12),
                _card(l10n.pendingPayouts, '₹45,000', AppColors.accent),
                const SizedBox(width: 12),
                _card(l10n.completedPayouts, '₹1,85,000', AppColors.success),
              ],
            ),
            const SizedBox(height: 24),

            // Pending withdrawals
            Text(l10n.pendingWithdrawalRequests,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._pendingWithdrawals.map((w) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Text(w['name']![0]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(w['name']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              Text(
                                '${w['type']} · ${w['date']}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text(w['amount']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      l10n.approveWithdrawal(w['name']!)),
                                  backgroundColor: AppColors.success),
                            );
                          },
                          icon: const Icon(Icons.check_circle,
                              color: AppColors.success),
                          tooltip: l10n.approve,
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      l10n.rejectWithdrawal(w['name']!)),
                                  backgroundColor: Colors.red),
                            );
                          },
                          icon:
                              const Icon(Icons.cancel, color: Colors.red),
                          tooltip: l10n.reject,
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 24),

            // Recent payouts
            Text(l10n.recentPayouts,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._recentPayouts.map((p) => Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.success,
                      child:
                          Icon(Icons.check, color: Colors.white, size: 18),
                    ),
                    title: Text(p['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    subtitle: Text('${p['method']} · ${p['date']}',
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

  Widget _card(String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  static const _pendingWithdrawals = [
    {'name': 'Mediator Ravi', 'amount': '₹5,000', 'type': 'Bank Transfer', 'date': '10 Jan'},
    {'name': 'Mediator Kumar', 'amount': '₹3,000', 'type': 'UPI', 'date': '09 Jan'},
    {'name': 'Mediator Lakshmi', 'amount': '₹7,500', 'type': 'Bank Transfer', 'date': '08 Jan'},
  ];

  static const _recentPayouts = [
    {'name': 'Mediator Ravi', 'amount': '₹8,000', 'method': 'Bank', 'date': '05 Jan'},
    {'name': 'Mediator Kumar', 'amount': '₹4,500', 'method': 'UPI', 'date': '03 Jan'},
    {'name': 'Mediator Lakshmi', 'amount': '₹6,000', 'method': 'Bank', 'date': '01 Jan'},
    {'name': 'Mediator Selvi', 'amount': '₹3,200', 'method': 'UPI', 'date': '28 Dec'},
  ];
}
