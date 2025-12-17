import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en'));

  void changeLanguage(String languageCode) {
    state = Locale(languageCode);
  }
}
