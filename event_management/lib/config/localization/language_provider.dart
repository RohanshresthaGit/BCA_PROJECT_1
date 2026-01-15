import 'package:event_management/config/storage/shared_prefs_service.dart';
import 'package:event_management/core/constants/shared_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageProvider = AsyncNotifierProvider<LanguageNotifier, Locale>(
  LanguageNotifier.new,
);

class LanguageNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    // Default value immediately
    final defaultLocale = const Locale('en');

    // Load saved language in background
    final savedCode = LanguageStorage.loadLanguage();
    if (savedCode != defaultLocale.languageCode) {
      // Update state silently
      state = AsyncData(Locale(savedCode));
    }

    return defaultLocale;
  }

  Future<void> changeLanguage(String languageCode) async {
    state = AsyncData(Locale(languageCode));
    await LanguageStorage.saveLanguage(languageCode);
  }
}

class LanguageStorage {
  static String loadLanguage() {
    return SharedPrefsService.instance.getString(SharedConstants.locale) ??
        'en';
  }

  static Future<void> saveLanguage(String code) async {
    SharedPrefsService.instance.saveString(SharedConstants.locale, code);
  }
}
