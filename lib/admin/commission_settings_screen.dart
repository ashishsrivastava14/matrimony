import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';

class CommissionSettingsScreen extends StatefulWidget {
  const CommissionSettingsScreen({super.key});

  @override
  State<CommissionSettingsScreen> createState() =>
      _CommissionSettingsScreenState();
}

class _CommissionSettingsScreenState extends State<CommissionSettingsScreen> {
  double _defaultRate = 10;
  double _premiumRate = 15;
  double _minPayout = 500;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.commissionSettings,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.defaultCommissionRate,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(l10n.appliedToAllMediators,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _defaultRate,
                            min: 0,
                            max: 30,
                            divisions: 30,
                            label: '${_defaultRate.toInt()}%',
                            onChanged: (v) =>
                                setState(() => _defaultRate = v),
                          ),
                        ),
                        Text('${_defaultRate.toInt()}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.premiumMediatorRate,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(l10n.higherRateForTopMediators,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _premiumRate,
                            min: 0,
                            max: 30,
                            divisions: 30,
                            label: '${_premiumRate.toInt()}%',
                            onChanged: (v) =>
                                setState(() => _premiumRate = v),
                          ),
                        ),
                        Text('${_premiumRate.toInt()}%',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.minimumPayoutAmount,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _minPayout,
                            min: 100,
                            max: 5000,
                            divisions: 49,
                            label: '₹${_minPayout.toInt()}',
                            onChanged: (v) =>
                                setState(() => _minPayout = v),
                          ),
                        ),
                        Text('₹${_minPayout.toInt()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.commissionStructure,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _structureRow(l10n.perSuccessfulMatch, '₹2,000'),
                    _structureRow(l10n.perProfileRegistration, '₹200'),
                    _structureRow(l10n.subscriptionReferral, '10%'),
                    _structureRow(l10n.bonusMatchesPerMonth, '₹5,000'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsSaved),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: Text(l10n.saveSettings),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _structureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
