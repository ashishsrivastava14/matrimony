import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Mediator: Create a profile on behalf of a client
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  int _currentStep = 0;
  String _gender = 'Male';
  String _maritalStatus = 'Never Married';
  String _religion = 'Hindu';
  String _familyType = 'Nuclear';
  String _diet = 'Vegetarian';

  final _steps = [
    'Basic Info',
    'Religion & Caste',
    'Education & Career',
    'Family',
    'Horoscope',
    'Photo & Contact',
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
            const Text('Create Client Profile'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Draft saved'),
                    backgroundColor: AppColors.primary),
              );
            },
            child: const Text('Save Draft'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step indicators
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Current step banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Step ${_currentStep + 1} / ${_steps.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _steps[_currentStep],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white70, size: 14),
                    ],
                  ),
                ),
                // Step circles row
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
                  child: Row(
                    children: List.generate(_steps.length, (i) {
                      final isActive = i == _currentStep;
                      final isDone = i < _currentStep;
                      // Shortened label: first word only
                      final words = _steps[i].split(' ');
                      final label = words.first;
                      return Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                if (i > 0)
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: isDone
                                            ? const LinearGradient(
                                                colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                                              )
                                            : null,
                                        color: isDone ? null : AppColors.divider,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  curve: Curves.easeOut,
                                  width: isActive ? 36 : 28,
                                  height: isActive ? 36 : 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isActive
                                        ? const LinearGradient(
                                            colors: [Color(0xFFFF8F00), Color(0xFFFFB74D)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : isDone
                                            ? const LinearGradient(
                                                colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                            : null,
                                    color: isDone || isActive ? null : AppColors.divider,
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFFFF6F00).withValues(alpha: 0.40),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            )
                                          ]
                                        : isDone
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary.withValues(alpha: 0.22),
                                                  blurRadius: 5,
                                                )
                                              ]
                                            : null,
                                  ),
                                  child: Center(
                                    child: isDone
                                        ? const Icon(Icons.check_rounded,
                                            size: 15, color: Colors.white)
                                        : Text(
                                            '${i + 1}',
                                            style: TextStyle(
                                              fontSize: isActive ? 13 : 11,
                                              fontWeight: FontWeight.bold,
                                              color: isActive || isDone
                                                  ? Colors.white
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                  ),
                                ),
                                if (i < _steps.length - 1)
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: isDone
                                            ? const LinearGradient(
                                                colors: [Color(0xFF26A69A), Color(0xFF00897B)],
                                              )
                                            : null,
                                        color: isDone ? null : AppColors.divider,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight:
                                    isActive ? FontWeight.bold : FontWeight.normal,
                                color: isActive
                                    ? AppColors.accent
                                    : isDone
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStep(),
            ),
          ),

          // Nav buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -1)),
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
                      if (_currentStep < _steps.length - 1) {
                        setState(() => _currentStep++);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Client profile created successfully!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        setState(() => _currentStep = 0);
                      }
                    },
                    child: Text(
                      _currentStep < _steps.length - 1
                          ? 'Next'
                          : 'Submit Profile',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _basicInfo();
      case 1:
        return _religionCaste();
      case 2:
        return _educationCareer();
      case 3:
        return _family();
      case 4:
        return _horoscope();
      case 5:
        return _photoContact();
      default:
        return const SizedBox();
    }
  }

  Widget _basicInfo() {
    return Column(
      children: [
        RadioGroup<String>(
          groupValue: _gender,
          onChanged: (v) => setState(() => _gender = v ?? _gender),
          child: Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Male'),
                  value: 'Male',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Female'),
                  value: 'Female',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Full Name')),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Date of Birth')),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Height')),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _maritalStatus,
          decoration: const InputDecoration(labelText: 'Marital Status'),
          items: ['Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _maritalStatus = v!),
        ),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Mother Tongue'),
            initialValue: 'Tamil'),
      ],
    );
  }

  Widget _religionCaste() {
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
            decoration: const InputDecoration(labelText: 'Caste')),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Sub Caste')),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Gotram')),
      ],
    );
  }

  Widget _educationCareer() {
    return Column(
      children: [
        TextFormField(
            decoration:
                const InputDecoration(labelText: 'Highest Education')),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Occupation')),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: 'Private Sector',
          decoration: const InputDecoration(labelText: 'Employed In'),
          items: [
            'Private Sector',
            'Government',
            'Business',
            'Self Employed',
            'Not Working'
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (_) {},
        ),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Annual Income')),
        const SizedBox(height: 14),
        TextFormField(
            decoration:
                const InputDecoration(labelText: 'Company / Organization')),
      ],
    );
  }

  Widget _family() {
    return Column(
      children: [
        TextFormField(
            decoration: const InputDecoration(labelText: "Father's Name")),
        const SizedBox(height: 14),
        TextFormField(
            decoration:
                const InputDecoration(labelText: "Father's Occupation")),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: "Mother's Name")),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Brothers'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Sisters'),
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
      ],
    );
  }

  Widget _horoscope() {
    return Column(
      children: [
        TextFormField(
            decoration: const InputDecoration(labelText: 'Time of Birth')),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Place of Birth')),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Star (Nakshatram)')),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Rasi')),
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

  Widget _photoContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Client Photos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                height: 100,
                margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Icon(Icons.add_a_photo,
                    color: AppColors.textSecondary),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        const Text('Contact Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'WhatsApp Number'),
            keyboardType: TextInputType.phone),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 14),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Address'),
            maxLines: 3),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _diet,
          decoration: const InputDecoration(labelText: 'Diet Preference'),
          items: ['Vegetarian', 'Non-Vegetarian', 'Eggetarian']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _diet = v!),
        ),
      ],
    );
  }
}
