import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  String get currentLanguageCode => _currentLocale.languageCode;

  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isMarathi => _currentLocale.languageCode == 'mr';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('mr'), // Marathi
  ];

  // Language display names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'mr': 'मराठी',
  };

  String get currentLanguageName => languageNames[_currentLocale.languageCode] ?? 'English';

  // Initialize locale from storage
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    _currentLocale = Locale(languageCode);
  }

  // Set locale
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    _currentLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    notifyListeners();
  }

  // Set locale by language code
  Future<void> setLanguageCode(String languageCode) async {
    await setLocale(Locale(languageCode));
  }

  // Toggle between English and Marathi
  Future<void> toggleLanguage() async {
    final newLocale = isEnglish ? const Locale('mr') : const Locale('en');
    await setLocale(newLocale);
  }
}
