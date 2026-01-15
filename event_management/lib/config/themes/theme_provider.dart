import 'package:event_management/config/storage/shared_prefs_service.dart';
import 'package:event_management/core/constants/shared_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
//   return ThemeNotifier();
// });

// import '../storage/theme_storage.dart';

final themeProvider = AsyncNotifierProvider<ThemeNotifier, bool>(
  ThemeNotifier.new,
);

class ThemeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return ThemeStorage.loadTheme();
  }

  Future<void> toggleTheme() async {
    final newTheme = !(state.value ?? false);
    state = AsyncData(newTheme);
    await ThemeStorage.saveTheme(newTheme);
  }
}

class ThemeStorage {
  static bool loadTheme() {
    return SharedPrefsService.instance.getBool(SharedConstants.theme) ?? true;
  }

  static Future<void> saveTheme(bool isDark) async {
    await SharedPrefsService.instance.saveBool(SharedConstants.theme, isDark);
  }
}
