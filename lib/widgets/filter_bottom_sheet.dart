import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Filter bottom sheet with search filters
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  static Future<Map<String, dynamic>?> show(BuildContext context) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _ageRange = const RangeValues(21, 35);
  String _religion = 'Any';
  String _caste = 'Any';
  String _education = 'Any';
  String _location = 'Any';
  String _income = 'Any';
  String _maritalStatus = 'Any';

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          controller: controller,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    _ageRange = const RangeValues(21, 35);
                    _religion = 'Any';
                    _caste = 'Any';
                    _education = 'Any';
                    _location = 'Any';
                    _income = 'Any';
                    _maritalStatus = 'Any';
                  }),
                  child: const Text('Reset'),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Age range
            const Text('Age Range',
                style: TextStyle(fontWeight: FontWeight.w600)),
            RangeSlider(
              values: _ageRange,
              min: 18,
              max: 60,
              divisions: 42,
              labels: RangeLabels(
                '${_ageRange.start.round()}',
                '${_ageRange.end.round()}',
              ),
              onChanged: (v) => setState(() => _ageRange = v),
            ),
            Text(
              '${_ageRange.start.round()} - ${_ageRange.end.round()} years',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            _buildDropdown('Religion', _religion, [
              'Any', 'Hindu', 'Muslim', 'Christian', 'Jain', 'Sikh'
            ], (v) => setState(() => _religion = v!)),

            _buildDropdown('Caste', _caste, [
              'Any', 'Vanniyar', 'Nadar', 'Gounder', 'Mudaliar', 'Pillai',
              'Chettiar', 'Brahmin', 'Thevar'
            ], (v) => setState(() => _caste = v!)),

            _buildDropdown('Education', _education, [
              'Any', 'B.E./B.Tech', 'M.E./M.Tech', 'MBA', 'B.Sc./M.Sc.',
              'MBBS/MD', 'CA', 'Ph.D'
            ], (v) => setState(() => _education = v!)),

            _buildDropdown('Location', _location, [
              'Any', 'Chennai', 'Coimbatore', 'Madurai', 'Trichy',
              'Salem', 'Bangalore', 'Mumbai', 'Hyderabad'
            ], (v) => setState(() => _location = v!)),

            _buildDropdown('Annual Income', _income, [
              'Any', 'Up to 3 Lakhs', '3-5 Lakhs', '5-8 Lakhs',
              '8-10 Lakhs', '10-15 Lakhs', '15+ Lakhs'
            ], (v) => setState(() => _income = v!)),

            _buildDropdown('Marital Status', _maritalStatus, [
              'Any', 'Never Married', 'Divorced', 'Widowed'
            ], (v) => setState(() => _maritalStatus = v!)),

            const SizedBox(height: 20),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'ageMin': _ageRange.start.round(),
                    'ageMax': _ageRange.end.round(),
                    'religion': _religion,
                    'caste': _caste,
                    'education': _education,
                    'location': _location,
                    'income': _income,
                    'maritalStatus': _maritalStatus,
                  });
                },
                child: const Text('Apply Filters',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((i) => DropdownMenuItem(value: i, child: Text(i)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
