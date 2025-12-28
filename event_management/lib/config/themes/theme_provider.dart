import 'package:flutter_riverpod/legacy.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  void switchMode(bool mode) {
    state = mode;
  }

  bool get getCurrrentTheme => state;
}
