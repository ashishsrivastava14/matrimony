import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
                onPressed: () => _downloadReport(AppLocalizations.of(context)!),
                icon: const Icon(Icons.download, size: 18),
                label: Text(l10n.download),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Generates a horoscope compatibility PDF and opens the native share/save dialog.
  Future<void> _downloadReport(AppLocalizations l10n) async {
    const score = 7.5;
    const maxScore = 10;

    // Porutham data — mirrors _buildPoruthamItems
    final poruthams = [
      (l10n.poruthamDina,           true,  l10n.poruthamDinaDesc),
      (l10n.poruthamGana,           true,  l10n.poruthamGanaDesc),
      (l10n.poruthamMahendra,       true,  l10n.poruthamMahendraDesc),
      (l10n.poruthamStreeDeergha,   true,  l10n.poruthamStreeDeerghaDesc),
      (l10n.poruthamYoni,           false, l10n.poruthamYoniDesc),
      (l10n.poruthamRasi,           true,  l10n.poruthamRasiDesc),
      (l10n.poruthamRasiyathipathi, true,  l10n.poruthamRasiyathipathiDesc),
      (l10n.poruthamVasya,          false, l10n.poruthamVasyaDesc),
      (l10n.poruthamRajju,          true,  l10n.poruthamRajjuDesc),
      (l10n.poruthamVedha,          false, l10n.poruthamVedhaDesc),
    ];

    final matchCount = poruthams.where((p) => p.$2).length;

    const primaryColor   = PdfColor.fromInt(0xFF00897B);
    const successColor   = PdfColor.fromInt(0xFF4CAF50);
    const errorColor     = PdfColor.fromInt(0xFFF44336);
    const bgLight        = PdfColor.fromInt(0xFFF5F5F5);
    const textSecondary  = PdfColor.fromInt(0xFF757575);
    const dividerColor   = PdfColor.fromInt(0xFFE0E0E0);

    final doc = pw.Document(title: '${l10n.horoscopeMatching} – ${_myName.text} & ${_pName.text}');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        header: (_) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 12),
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: primaryColor, width: 2)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                l10n.horoscopeMatching,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              pw.Text(
                'Generated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: const pw.TextStyle(fontSize: 10, color: textSecondary),
              ),
            ],
          ),
        ),
        footer: (ctx) => pw.Container(
          padding: const pw.EdgeInsets.only(top: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: dividerColor)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('AP Matrimony', style: const pw.TextStyle(fontSize: 9, color: textSecondary)),
              pw.Text('Page ${ctx.pageNumber} of ${ctx.pagesCount}',
                  style: const pw.TextStyle(fontSize: 9, color: textSecondary)),
            ],
          ),
        ),
        build: (ctx) => [
          pw.SizedBox(height: 16),

          // ── Couple names ──────────────────────────────────────
          pw.Center(
            child: pw.Text(
              '${_myName.text}  ❤  ${_pName.text}',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              l10n.compatibilityScore,
              style: const pw.TextStyle(fontSize: 12, color: textSecondary),
            ),
          ),
          pw.SizedBox(height: 20),

          // ── Score box ─────────────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: bgLight,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: successColor, width: 1.5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      '$score / $maxScore',
                      style: pw.TextStyle(
                        fontSize: 36,
                        fontWeight: pw.FontWeight.bold,
                        color: successColor,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: pw.BoxDecoration(
                        color: successColor,
                        borderRadius: pw.BorderRadius.circular(12),
                      ),
                      child: pw.Text(
                        l10n.excellentMatch,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '$matchCount out of ${poruthams.length} poruthams matched',
                      style: const pw.TextStyle(fontSize: 11, color: textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // ── Profile details side-by-side ──────────────────────
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: _pdfProfileBox(
                  l10n.yourDetails,
                  primaryColor,
                  [
                    (l10n.name,           _myName.text),
                    (l10n.dateOfBirth,    _myDob.text),
                    (l10n.timeOfBirth,    _myTob.text),
                    (l10n.placeOfBirth,   _myPob.text),
                    (l10n.starNakshatram, _myStar.text),
                    (l10n.rasi,           _myRasi.text),
                    (l10n.dosham,         _myDosham.text),
                  ],
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _pdfProfileBox(
                  l10n.partnersDetails,
                  primaryColor,
                  [
                    (l10n.name,           _pName.text),
                    (l10n.dateOfBirth,    _pDob.text),
                    (l10n.timeOfBirth,    _pTob.text),
                    (l10n.placeOfBirth,   _pPob.text),
                    (l10n.starNakshatram, _pStar.text),
                    (l10n.rasi,           _pRasi.text),
                    (l10n.dosham,         _pDosham.text),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 24),

          // ── Porutham table ─────────────────────────────────────
          pw.Text(
            l10n.tenPoruthamDetails,
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              color: primaryColor,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: dividerColor),
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(3),
              2: pw.FlexColumnWidth(2),
            },
            children: [
              // Header row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: primaryColor),
                children: [
                  _pdfCell('Porutham', isHeader: true),
                  _pdfCell('Description', isHeader: true),
                  _pdfCell('Result', isHeader: true, center: true),
                ],
              ),
              // Data rows
              for (final p in poruthams)
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: p.$2
                        ? const PdfColor.fromInt(0xFFE8F5E9)
                        : const PdfColor.fromInt(0xFFFFEBEE),
                  ),
                  children: [
                    _pdfCell(p.$1),
                    _pdfCell(p.$3, color: textSecondary),
                    _pdfCell(
                      p.$2 ? l10n.matchLabel : l10n.noMatchLabel,
                      center: true,
                      color: p.$2 ? successColor : errorColor,
                      bold: true,
                    ),
                  ],
                ),
            ],
          ),
          pw.SizedBox(height: 24),

          // ── Summary ────────────────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFE8F5E9),
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: successColor),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  l10n.summary,
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                    color: successColor,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  l10n.horoscopeSummaryText,
                  style: const pw.TextStyle(fontSize: 11, lineSpacing: 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => doc.save(),
      name: 'Horoscope_${_myName.text}_${_pName.text}.pdf',
    );
  }

  /// Helper: profile detail box for the PDF.
  pw.Widget _pdfProfileBox(
    String title,
    PdfColor color,
    List<(String, String)> fields,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
          pw.SizedBox(height: 6),
          for (final f in fields)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 80,
                    child: pw.Text(
                      f.$1,
                      style: const pw.TextStyle(
                          fontSize: 9, color: PdfColor.fromInt(0xFF757575)),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      f.$2.isEmpty ? '—' : f.$2,
                      style: pw.TextStyle(
                          fontSize: 9, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Helper: table cell for the PDF.
  pw.Widget _pdfCell(
    String text, {
    bool isHeader = false,
    bool center = false,
    bool bold = false,
    PdfColor color = PdfColors.black,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: (isHeader || bold) ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.white : color,
        ),
      ),
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
