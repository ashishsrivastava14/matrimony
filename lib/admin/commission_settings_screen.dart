import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';

class CommissionSettingsScreen extends StatefulWidget {
  const CommissionSettingsScreen({super.key});

  @override
  State<CommissionSettingsScreen> createState() =>
      _CommissionSettingsScreenState();
}

class _CommissionSettingsScreenState
    extends State<CommissionSettingsScreen> {
  bool _initialized = false;

  // Slider values
  double _defaultRate = 10;
  double _premiumRate = 15;
  double _minPayout = 500;

  // Structure controllers
  late final TextEditingController _matchCtrl;
  late final TextEditingController _profileCtrl;
  late final TextEditingController _referralCtrl;
  late final TextEditingController _bonusCtrl;

  @override
  void initState() {
    super.initState();
    _matchCtrl = TextEditingController();
    _profileCtrl = TextEditingController();
    _referralCtrl = TextEditingController();
    _bonusCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final appState = context.read<AppState>();
      _defaultRate = appState.commissionDefaultRate;
      _premiumRate = appState.commissionPremiumRate;
      _minPayout = appState.commissionMinPayout;
      _matchCtrl.text =
          appState.commissionPerMatch.toStringAsFixed(0);
      _profileCtrl.text =
          appState.commissionPerProfile.toStringAsFixed(0);
      _referralCtrl.text =
          appState.commissionSubscriptionReferral.toStringAsFixed(1);
      _bonusCtrl.text =
          appState.commissionBonusPerMonth.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _matchCtrl.dispose();
    _profileCtrl.dispose();
    _referralCtrl.dispose();
    _bonusCtrl.dispose();
    super.dispose();
  }

  void _save(BuildContext context, AppLocalizations l10n) {
    final perMatch = double.tryParse(_matchCtrl.text) ?? 0;
    final perProfile = double.tryParse(_profileCtrl.text) ?? 0;
    final referral = double.tryParse(_referralCtrl.text) ?? 0;
    final bonus = double.tryParse(_bonusCtrl.text) ?? 0;

    context.read<AppState>().saveCommissionSettings(
          defaultRate: _defaultRate,
          premiumRate: _premiumRate,
          minPayout: _minPayout,
          perMatch: perMatch,
          perProfile: perProfile,
          subscriptionReferral: referral,
          bonusPerMonth: bonus,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.settingsSaved),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // ── Default commission rate ─────────────────────────
            _sliderCard(
              title: l10n.defaultCommissionRate,
              subtitle: l10n.appliedToAllMediators,
              value: _defaultRate,
              min: 0,
              max: 30,
              suffix: '%',
              onChanged: (v) => setState(() => _defaultRate = v),
            ),
            const SizedBox(height: 12),

            // ── Premium mediator rate ───────────────────────────
            _sliderCard(
              title: l10n.premiumMediatorRate,
              subtitle: l10n.higherRateForTopMediators,
              value: _premiumRate,
              min: 0,
              max: 30,
              suffix: '%',
              onChanged: (v) => setState(() => _premiumRate = v),
            ),
            const SizedBox(height: 12),

            // ── Minimum payout ──────────────────────────────────
            _sliderCard(
              title: l10n.minimumPayoutAmount,
              subtitle: null,
              value: _minPayout,
              min: 100,
              max: 5000,
              prefix: '₹',
              suffix: '',
              onChanged: (v) => setState(() => _minPayout = v),
            ),
            const SizedBox(height: 12),

            // ── Commission structure ────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(l10n.commissionStructure,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                        'Edit individual payout amounts for each action.',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    _editableStructureRow(
                        label: l10n.perSuccessfulMatch,
                        controller: _matchCtrl,
                        prefixSymbol: '₹',
                        isPercent: false),
                    const SizedBox(height: 12),
                    _editableStructureRow(
                        label: l10n.perProfileRegistration,
                        controller: _profileCtrl,
                        prefixSymbol: '₹',
                        isPercent: false),
                    const SizedBox(height: 12),
                    _editableStructureRow(
                        label: l10n.subscriptionReferral,
                        controller: _referralCtrl,
                        prefixSymbol: '',
                        suffixSymbol: '%',
                        isPercent: true),
                    const SizedBox(height: 12),
                    _editableStructureRow(
                        label: l10n.bonusMatchesPerMonth,
                        controller: _bonusCtrl,
                        prefixSymbol: '₹',
                        isPercent: false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _save(context, l10n),
                icon: const Icon(Icons.save, size: 18),
                label: Text(l10n.saveSettings),
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Slider card ─────────────────────────────────────────────────
  Widget _sliderCard({
    required String title,
    required String? subtitle,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    String prefix = '',
    String suffix = '%',
  }) {
    final displayValue = suffix == '%'
        ? '${prefix}${value.toInt()}${suffix}'
        : '${prefix}${value.toInt()}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 13)),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: ((max - min)).toInt(),
                    label: displayValue,
                    onChanged: onChanged,
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Text(displayValue,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Editable structure row ──────────────────────────────────────
  Widget _editableStructureRow({
    required String label,
    required TextEditingController controller,
    String prefixSymbol = '',
    String suffixSymbol = '',
    bool isPercent = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d*'))
            ],
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              prefixText: prefixSymbol.isNotEmpty ? prefixSymbol : null,
              suffixText: suffixSymbol.isNotEmpty ? suffixSymbol : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
