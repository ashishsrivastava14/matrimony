import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage language preferences
class LanguagePreferences {
  static const String _languageKey = 'selected_language';
  
  /// Save selected language code
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
  
  /// Get saved language code, defaults to 'en' (English)
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }
  
  /// Remove saved language preference
  static Future<void> clearLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
  }
}
