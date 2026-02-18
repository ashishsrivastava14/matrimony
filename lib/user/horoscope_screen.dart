import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/user_bottom_navigation.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  bool _showResult = false;

  final _myDetails = {
    'name': 'Karthick',
    'dob': '12/06/1991',
    'tob': '06:10:00 AM',
    'pob': 'Chennai',
    'star': 'Rohini',
    'rasi': 'Taurus',
    'dosham': 'No',
  };

  final _partnerDetails = {
    'name': 'Priya Sharma',
    'dob': '05/03/1995',
    'tob': '10:30:00 AM',
    'pob': 'Coimbatore',
    'star': 'Uttara Phalguni',
    'rasi': 'Virgo',
    'dosham': 'No',
  };

  @override
  Widget build(BuildContext context) {
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
            const Text('Horoscope Matching'),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _showResult ? _buildResult() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
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
        const Center(
          child: Text(
            'Check Horoscope Compatibility',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            'Enter both profiles\' details to get matching score',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
        const SizedBox(height: 24),

        // My details
        _buildSectionHeader('Your Details', Icons.person),
        const SizedBox(height: 12),
        _buildDetailCard(_myDetails),
        const SizedBox(height: 20),

        // Partner details
        _buildSectionHeader("Partner's Details", Icons.person_outline),
        const SizedBox(height: 12),
        _buildDetailCard(_partnerDetails),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _showResult = true),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Check Compatibility'),
          ),
        ),
      ],
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

  Widget _buildDetailCard(Map<String, String> details) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _detailRow('Name', details['name']!),
            _detailRow('Date of Birth', details['dob']!),
            _detailRow('Time of Birth', details['tob']!),
            _detailRow('Place of Birth', details['pob']!),
            _detailRow('Star (Nakshatram)', details['star']!),
            _detailRow('Rasi', details['rasi']!),
            _detailRow('Dosham', details['dosham']!),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    const score = 7.5;
    const maxScore = 10.0;
    const percentage = score / maxScore;

    return Column(
      children: [
        // Score circle
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Compatibility Score',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            '${score.toInt()}/$maxScore',
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
                            child: const Text(
                              'Excellent',
                              style: TextStyle(
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
                    Text(_myDetails['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.favorite,
                          color: AppColors.primary, size: 20),
                    ),
                    Text(_partnerDetails['name']!,
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
                const Text(
                  '10 Porutham Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._buildPoruthamItems(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Summary
        Card(
          color: AppColors.success.withValues(alpha: 0.05),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: AppColors.success, size: 20),
                    SizedBox(width: 8),
                    Text('Summary',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'This is an excellent match with 7.5 out of 10 poruthams matching. '
                  'The couple is highly compatible for marriage based on horoscope analysis. '
                  'Both nakshatras complement each other well.',
                  style: TextStyle(fontSize: 13, height: 1.5),
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
                child: const Text('Check Another'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report downloaded (mock)')),
                  );
                },
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildPoruthamItems() {
    final poruthams = [
      ('Dina Porutham', true, 'Star compatibility'),
      ('Gana Porutham', true, 'Temperament matching'),
      ('Mahendra Porutham', true, 'Prosperity & well-being'),
      ('Stree Deergha', true, 'Long married life'),
      ('Yoni Porutham', false, 'Physical compatibility'),
      ('Rasi Porutham', true, 'Emotional compatibility'),
      ('Rasiyathipathi', true, 'Ruling planet harmony'),
      ('Vasya Porutham', false, 'Mutual attraction'),
      ('Rajju Porutham', true, 'Longevity of spouse'),
      ('Vedha Porutham', false, 'Obstacle analysis'),
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
