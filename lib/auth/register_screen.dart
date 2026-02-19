import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';

/// Registration screen — mock form
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'Male';
  String _lookingFor = 'Bride';

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
            Text(l10n.createAccount),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.joinAppMatrimony,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.createProfileFindMatch,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // Looking for
                  Text(l10n.lookingFor,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Bride', 'Groom'].map((opt) {
                      final selected = _lookingFor == opt;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _lookingFor = opt;
                            _gender = opt == 'Bride' ? 'Male' : 'Female';
                          }),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  opt == 'Bride'
                                      ? Icons.female
                                      : Icons.male,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  opt == 'Bride' ? l10n.bride : l10n.groom,
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: l10n.fullName,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (v) => v?.isEmpty == true ? l10n.required : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: l10n.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v?.isEmpty == true ? l10n.required : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: l10n.mobileNumber,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      prefixText: l10n.phonePlus91,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v?.isEmpty == true ? l10n.required : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: l10n.dateOfBirth,
                      prefixIcon: const Icon(Icons.cake_outlined),
                      hintText: l10n.datePlaceholder,
                    ),
                    validator: (v) => v?.isEmpty == true ? l10n.required : null,
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: InputDecoration(
                      labelText: l10n.gender,
                      prefixIcon: const Icon(Icons.wc),
                    ),
                    items: [
                      DropdownMenuItem(value: 'Male', child: Text(l10n.male)),
                      DropdownMenuItem(value: 'Female', child: Text(l10n.female)),
                    ],
                    onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validator: (v) => v?.isEmpty == true ? l10n.required : null,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  l10n.registrationSuccess),
                              backgroundColor: AppColors.success,
                            ),
                          );
                          Navigator.of(context).pushNamed('/otp');
                        }
                      },
                      child: Text(l10n.register,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.alreadyHaveAccount,
                          style: const TextStyle(color: AppColors.textSecondary)),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.login),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
