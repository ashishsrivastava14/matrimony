import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/powered_by_footer.dart';

class HoroscopeSettingsScreen extends StatefulWidget {
  const HoroscopeSettingsScreen({super.key});

  @override
  State<HoroscopeSettingsScreen> createState() =>
      _HoroscopeSettingsScreenState();
}

class _HoroscopeSettingsScreenState extends State<HoroscopeSettingsScreen> {
  bool _enableHoroscope = true;
  bool _autoMatch = true;
  bool _showDosham = true;
  int _minPorutham = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const PoweredByFooter(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Horoscope Settings',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Feature toggles
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Feature Configuration',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Enable Horoscope Matching'),
                      subtitle: const Text(
                          'Allow users to check horoscope compatibility'),
                      value: _enableHoroscope,
                      onChanged: (v) =>
                          setState(() => _enableHoroscope = v),
                      activeThumbColor: AppColors.primary,
                    ),
                    SwitchListTile(
                      title: const Text('Auto Horoscope Matching'),
                      subtitle: const Text(
                          'Automatically show compatibility on profile view'),
                      value: _autoMatch,
                      onChanged: (v) =>
                          setState(() => _autoMatch = v),
                      activeThumbColor: AppColors.primary,
                    ),
                    SwitchListTile(
                      title: const Text('Show Dosham Warning'),
                      subtitle:
                          const Text('Display dosham status on profiles'),
                      value: _showDosham,
                      onChanged: (v) =>
                          setState(() => _showDosham = v),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Min porutham
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Minimum Porutham Score',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text(
                      'Minimum poruthams needed for "Good Match" label',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _minPorutham.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: '$_minPorutham / 10',
                            onChanged: (v) =>
                                setState(() => _minPorutham = v.toInt()),
                          ),
                        ),
                        Text('$_minPorutham / 10',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Category labels
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Compatibility Labels',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _labelRow('Excellent', '8-10 Porutham', AppColors.success),
                    _labelRow('Good', '6-7 Porutham', AppColors.primary),
                    _labelRow('Average', '4-5 Porutham', AppColors.accent),
                    _labelRow('Poor', '1-3 Porutham', Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 10 Porutham list
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('10 Porutham Configuration',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._poruthams.map((p) => _poruthamRow(p)),
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
                    const SnackBar(
                      content: Text('Horoscope settings saved!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelRow(String label, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration:
                BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(desc,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _poruthamRow(Map<String, dynamic> p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(p['desc'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: p['enabled'] as bool,
            onChanged: (_) {},
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  static final _poruthams = [
    {'name': 'Dina Porutham', 'desc': 'Star compatibility', 'enabled': true},
    {'name': 'Gana Porutham', 'desc': 'Temperament type', 'enabled': true},
    {'name': 'Mahendra Porutham', 'desc': 'Prosperity', 'enabled': true},
    {'name': 'Stree Deergha', 'desc': 'Long married life', 'enabled': true},
    {'name': 'Yoni Porutham', 'desc': 'Physical compatibility', 'enabled': true},
    {'name': 'Rasi Porutham', 'desc': 'Emotional bond', 'enabled': true},
    {'name': 'Rasiyathipathi', 'desc': 'Planet harmony', 'enabled': true},
    {'name': 'Vasya Porutham', 'desc': 'Mutual attraction', 'enabled': true},
    {'name': 'Rajju Porutham', 'desc': 'Spouse longevity', 'enabled': true},
    {'name': 'Vedha Porutham', 'desc': 'Obstacle analysis', 'enabled': false},
  ];
}
