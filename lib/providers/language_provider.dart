import 'package:flutter/material.dart';
import '../services/language_preferences.dart';

/// Provider to manage app language
class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  /// Initialize language from saved preferences
  Future<void> loadSavedLanguage() async {
    final languageCode = await LanguagePreferences.getLanguage();
    _locale = Locale(languageCode);
    notifyListeners();
  }
  
  /// Change app language
  Future<void> changeLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    
    _locale = Locale(languageCode);
    await LanguagePreferences.saveLanguage(languageCode);
    notifyListeners();
  }
  
  /// Get language display name
  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      case 'ta':
        return 'தமிழ்';
      case 'te':
        return 'తెలుగు';
      default:
        return 'English';
    }
  }
  
  /// Get all supported languages
  static List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
      {'code': 'ta', 'name': 'Tamil', 'nativeName': 'தமிழ்'},
      {'code': 'te', 'name': 'Telugu', 'nativeName': 'తెలుగు'},
    ];
  }
}
