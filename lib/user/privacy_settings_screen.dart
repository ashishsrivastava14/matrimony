import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _showToAll = true;
  bool _photosPremiumOnly = false;
  bool _showHoroscope = true;
  bool _allowMessages = true;
  bool _hidePhone = true;

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
        title: Text(l10n.stepPrivacySettings),
        leading: BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile visibility section
          const _SectionHeader(title: 'Profile Visibility'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    l10n.showProfileToAll,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    l10n.profileVisibleToAll,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  value: _showToAll,
                  onChanged: (v) => setState(() => _showToAll = v),
                  activeThumbColor: AppColors.primary,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: Text(
                    l10n.showPhotosToPremiumOnly,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    l10n.paidMembersCanSeePhotos,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  value: _photosPremiumOnly,
                  onChanged: (v) => setState(() => _photosPremiumOnly = v),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Profile details section
          const _SectionHeader(title: 'Profile Details'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    l10n.showHoroscopeDetails,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    l10n.displayHoroscopeOnProfile,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  value: _showHoroscope,
                  onChanged: (v) => setState(() => _showHoroscope = v),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Contact section
          const _SectionHeader(title: 'Contact Privacy'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    l10n.allowContactMessages,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    l10n.receiveMessagesFromInterested,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  value: _allowMessages,
                  onChanged: (v) => setState(() => _allowMessages = v),
                  activeThumbColor: AppColors.primary,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: Text(
                    l10n.hidePhoneNumber,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    l10n.phoneNumberHiddenDefault,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  value: _hidePhone,
                  onChanged: (v) => setState(() => _hidePhone = v),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.settingsSaved)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                l10n.saveSettings,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
