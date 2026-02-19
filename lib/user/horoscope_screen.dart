import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/user_bottom_navigation.dart';
import '../l10n/app_localizations.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  bool _showResult = false;
  final _formKey = GlobalKey<FormState>();

  // My detail controllers
  late final TextEditingController _myName;
  late final TextEditingController _myDob;
  late final TextEditingController _myTob;
  late final TextEditingController _myPob;
  late final TextEditingController _myStar;
  late final TextEditingController _myRasi;
  late final TextEditingController _myDosham;

  // Partner detail controllers
  late final TextEditingController _pName;
  late final TextEditingController _pDob;
  late final TextEditingController _pTob;
  late final TextEditingController _pPob;
  late final TextEditingController _pStar;
  late final TextEditingController _pRasi;
  late final TextEditingController _pDosham;

  @override
  void initState() {
    super.initState();
    _myName   = TextEditingController(text: 'Karthick');
    _myDob    = TextEditingController(text: '12/06/1991');
    _myTob    = TextEditingController(text: '06:10 AM');
    _myPob    = TextEditingController(text: 'Chennai');
    _myStar   = TextEditingController(text: 'Rohini');
    _myRasi   = TextEditingController(text: 'Taurus');
    _myDosham = TextEditingController(text: 'No');

    _pName   = TextEditingController(text: '');
    _pDob    = TextEditingController(text: '');
    _pTob    = TextEditingController(text: '');
    _pPob    = TextEditingController(text: '');
    _pStar   = TextEditingController(text: '');
    _pRasi   = TextEditingController(text: '');
    _pDosham = TextEditingController(text: 'No');
  }

  @override
  void dispose() {
    for (final c in [
      _myName, _myDob, _myTob, _myPob, _myStar, _myRasi, _myDosham,
      _pName, _pDob, _pTob, _pPob, _pStar, _pRasi, _pDosham,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            Text(l10n.horoscopeMatching),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _showResult ? _buildResult(AppLocalizations.of(context)!) : _buildForm(AppLocalizations.of(context)!),
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.auto_awesome, color: AppColors.accent, size: 48),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.checkHoroscopeCompatibility,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              l10n.enterProfileDetailsHint,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),

          // My details
          _buildSectionHeader(l10n.yourDetails, Icons.person),
          const SizedBox(height: 12),
          _buildEditableCard([
            _fieldRow(l10n.name,           _myName,   required: true),
            _fieldRow(l10n.dateOfBirth,    _myDob,    hint: 'DD/MM/YYYY', required: true),
            _fieldRow(l10n.timeOfBirth,    _myTob,    hint: 'HH:MM AM/PM'),
            _fieldRow(l10n.placeOfBirth,   _myPob),
            _fieldRow(l10n.starNakshatram, _myStar,   required: true),
            _fieldRow(l10n.rasi,           _myRasi,   required: true),
            _fieldRow(l10n.dosham,         _myDosham),
          ]),
          const SizedBox(height: 20),

          // Partner details
          _buildSectionHeader(l10n.partnersDetails, Icons.person_outline),
          const SizedBox(height: 12),
          _buildEditableCard([
            _fieldRow(l10n.name,           _pName,   required: true),
            _fieldRow(l10n.dateOfBirth,    _pDob,    hint: 'DD/MM/YYYY', required: true),
            _fieldRow(l10n.timeOfBirth,    _pTob,    hint: 'HH:MM AM/PM'),
            _fieldRow(l10n.placeOfBirth,   _pPob),
            _fieldRow(l10n.starNakshatram, _pStar,   required: true),
            _fieldRow(l10n.rasi,           _pRasi,   required: true),
            _fieldRow(l10n.dosham,         _pDosham),
          ]),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() => _showResult = true);
                }
              },
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.checkCompatibility),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEditableCard(List<Widget> rows) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: rows),
      ),
    );
  }

  Widget _fieldRow(
    String label,
    TextEditingController controller, {
    String? hint,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
            : null,
      ),
    );
  }

  Widget _buildResult(AppLocalizations l10n) {
    const score = 7.5;
    const maxScore = 10;
    const percentage = score / maxScore;

    return Column(
      children: [
        // Score circle
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  l10n.compatibilityScore,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: percentage,
                          strokeWidth: 12,
                          backgroundColor: AppColors.divider,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.success),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$score/$maxScore',
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              l10n.excellentMatch,
                              style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_myName.text,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.favorite,
                          color: AppColors.primary, size: 20),
                    ),
                    Text(_pName.text,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Porutham breakdown
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tenPoruthamDetails,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._buildPoruthamItems(l10n),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Summary
        Card(
          color: AppColors.success.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.summary,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.horoscopeSummaryText,
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _showResult = false),
                child: Text(l10n.checkAnother),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.reportDownloaded)),
                  );
                },
                icon: const Icon(Icons.download, size: 18),
                label: Text(l10n.download),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildPoruthamItems(AppLocalizations l10n) {
    final poruthams = [
      (l10n.poruthamDina,          true,  l10n.poruthamDinaDesc),
      (l10n.poruthamGana,          true,  l10n.poruthamGanaDesc),
      (l10n.poruthamMahendra,      true,  l10n.poruthamMahendraDesc),
      (l10n.poruthamStreeDeergha,  true,  l10n.poruthamStreeDeerghaDesc),
      (l10n.poruthamYoni,          false, l10n.poruthamYoniDesc),
      (l10n.poruthamRasi,          true,  l10n.poruthamRasiDesc),
      (l10n.poruthamRasiyathipathi, true, l10n.poruthamRasiyathipathiDesc),
      (l10n.poruthamVasya,         false, l10n.poruthamVasyaDesc),
      (l10n.poruthamRajju,         true,  l10n.poruthamRajjuDesc),
      (l10n.poruthamVedha,         false, l10n.poruthamVedhaDesc),
    ];

    return poruthams.map((p) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              p.$2 ? Icons.check_circle : Icons.cancel,
              color: p.$2 ? AppColors.success : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.$1,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text(p.$3,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: (p.$2 ? AppColors.success : Colors.red)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                p.$2 ? 'Match' : 'No Match',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: p.$2 ? AppColors.success : Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
