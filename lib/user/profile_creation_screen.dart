import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/user_bottom_navigation.dart';

/// Multi-step profile creation form
class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form values
  String _maritalStatus = 'Never Married';
  String _religion = 'Hindu';
  String _diet = 'Vegetarian';
  String _smoking = 'No';
  String _drinking = 'No';
  String _familyType = 'Nuclear';
  String _familyStatus = 'Middle Class';

  final List<String> _stepTitles = [
    'Basic Info',
    'Religion / Caste',
    'Education / Occupation',
    'Family Details',
    'Horoscope Details',
    'Lifestyle',
    'Partner Preferences',
    'Photo Upload',
    'Privacy Settings',
  ];

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
            Text('Step ${_currentStep + 1}: ${_stepTitles[_currentStep]}'),
          ],
        ),
      ),
      bottomNavigationBar: const UserBottomNavigation(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: (_currentStep + 1) / _stepTitles.length,
              backgroundColor: AppColors.divider,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),

            // Step dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: List.generate(_stepTitles.length, (i) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: i <= _currentStep
                            ? AppColors.primary
                            : AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStep(),
              ),
            ),

            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _currentStep--),
                        child: const Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep < _stepTitles.length - 1) {
                          setState(() => _currentStep++);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile saved successfully!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        _currentStep < _stepTitles.length - 1
                            ? 'Next'
                            : 'Save Profile',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _basicInfoStep();
      case 1:
        return _religionCasteStep();
      case 2:
        return _educationStep();
      case 3:
        return _familyStep();
      case 4:
        return _horoscopeStep();
      case 5:
        return _lifestyleStep();
      case 6:
        return _partnerPrefStep();
      case 7:
        return _photoUploadStep();
      case 8:
        return _privacyStep();
      default:
        return const SizedBox();
    }
  }

  Widget _basicInfoStep() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Full Name'),
          initialValue: 'Karthick',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Date of Birth'),
          initialValue: '12/06/1991',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Age'),
          initialValue: '27',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Height'),
          initialValue: "5'9\"",
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _maritalStatus,
          decoration: const InputDecoration(labelText: 'Marital Status'),
          items: ['Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _maritalStatus = v!),
        ),
      ],
    );
  }

  Widget _religionCasteStep() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _religion,
          decoration: const InputDecoration(labelText: 'Religion'),
          items: ['Hindu', 'Muslim', 'Christian', 'Jain', 'Sikh']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _religion = v!),
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Caste'),
          initialValue: 'Vanniyar',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Sub Caste'),
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Mother Tongue'),
          initialValue: 'Tamil',
        ),
      ],
    );
  }

  Widget _educationStep() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Highest Education'),
          initialValue: 'B.E.',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Occupation'),
          initialValue: 'Cloud Architect Engineer',
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: 'Private Sector',
          decoration: const InputDecoration(labelText: 'Employed In'),
          items: ['Private Sector', 'Government', 'Business', 'Not Working']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (_) {},
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Annual Income'),
          initialValue: '10-15 Lakhs',
        ),
      ],
    );
  }

  Widget _familyStep() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Father's Name"),
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: "Father's Occupation"),
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: "Mother's Name"),
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: "Mother's Occupation"),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Brothers'),
                initialValue: '1',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Sisters'),
                initialValue: '0',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _familyType,
          decoration: const InputDecoration(labelText: 'Family Type'),
          items: ['Nuclear', 'Joint']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _familyType = v!),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _familyStatus,
          decoration: const InputDecoration(labelText: 'Family Status'),
          items: ['Middle Class', 'Upper Middle Class', 'Rich', 'Affluent']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _familyStatus = v!),
        ),
      ],
    );
  }

  Widget _horoscopeStep() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
              labelText: 'Date of Birth', hintText: 'DD/MM/YYYY'),
          initialValue: '12/06/1991',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(
              labelText: 'Time of Birth', hintText: 'HH:MM AM/PM'),
          initialValue: '06:10:00 AM',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Place of Birth'),
          initialValue: 'Chennai',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Star (Nakshatram)'),
          initialValue: 'Rohini',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Rasi'),
          initialValue: 'Taurus',
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: 'No',
          decoration: const InputDecoration(labelText: 'Dosham'),
          items: ['No', 'Yes', "Don't Know"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _lifestyleStep() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: _diet,
          decoration: const InputDecoration(labelText: 'Diet'),
          items: ['Vegetarian', 'Non-Vegetarian', 'Eggetarian', 'Vegan']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _diet = v!),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _smoking,
          decoration: const InputDecoration(labelText: 'Smoking'),
          items: ['No', 'Yes', 'Occasionally']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _smoking = v!),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _drinking,
          decoration: const InputDecoration(labelText: 'Drinking'),
          items: ['No', 'Yes', 'Occasionally']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _drinking = v!),
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'About Me'),
          maxLines: 4,
          initialValue:
              'I am a passionate software engineer who loves exploring new technologies.',
        ),
      ],
    );
  }

  Widget _partnerPrefStep() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Age Range'),
          initialValue: '25-30',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Height Range'),
          initialValue: "5'4\" - 5'8\"",
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Preferred Education'),
          initialValue: 'Any Graduate',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Preferred Occupation'),
          initialValue: 'Any',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Preferred Location'),
          initialValue: 'Tamil Nadu',
        ),
        const SizedBox(height: 14),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Preferred Religion'),
          initialValue: 'Hindu',
        ),
      ],
    );
  }

  Widget _photoUploadStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Photos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add up to 10 photos to your profile. Clear, recent photos get more responses.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            // Existing mock photos
            ...List.generate(3, (i) {
              final imageIds = [68, 11, 12];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/profiles/profile_${imageIds[i]}.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              );
            }),
            // Add more button
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photo picker (mock)')),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primary, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: AppColors.primary),
                    SizedBox(height: 4),
                    Text('Add Photo',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _privacyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _PrivacyToggle(
          title: 'Show profile to all members',
          subtitle: 'Your profile will be visible to everyone',
          value: true,
        ),
        _PrivacyToggle(
          title: 'Show photos to premium members only',
          subtitle: 'Only paid members can see your photos',
          value: false,
        ),
        _PrivacyToggle(
          title: 'Show horoscope details',
          subtitle: 'Display horoscope information on profile',
          value: true,
        ),
        _PrivacyToggle(
          title: 'Allow contact messages',
          subtitle: 'Receive messages from interested profiles',
          value: true,
        ),
        _PrivacyToggle(
          title: 'Hide phone number',
          subtitle: 'Phone number will not be shown by default',
          value: true,
        ),
      ],
    );
  }
}

class _PrivacyToggle extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool value;

  const _PrivacyToggle({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  State<_PrivacyToggle> createState() => _PrivacyToggleState();
}

class _PrivacyToggleState extends State<_PrivacyToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.title,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(widget.subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      value: _value,
      onChanged: (v) => setState(() => _value = v),
      activeThumbColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
