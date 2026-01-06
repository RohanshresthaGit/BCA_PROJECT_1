import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/shared_constants.dart';

/// Simple SharedPreferences wrapper service.
///
/// Usage:
/// await SharedPrefsService.instance.init();
/// await SharedPrefsService.instance.saveToken('...');
class SharedPrefsService {
  SharedPrefsService._internal();

  static final SharedPrefsService instance = SharedPrefsService._internal();

  SharedPreferences? _prefs;

  /// Initialize the underlying SharedPreferences instance.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  bool get isInitialized => _prefs != null;

  Future<bool> saveString(String key, String value) async {
    await init();
    return _prefs!.setString(key, value);
  }

  String? getString(String key) {
    if (!isInitialized) return null;
    return _prefs!.getString(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    await init();
    return _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    if (!isInitialized) return null;
    return _prefs!.getBool(key);
  }

  Future<bool> remove(String key) async {
    await init();
    return _prefs!.remove(key);
  }

  Future<bool> clearAll() async {
    await init();
    return _prefs!.clear();
  }

  Future<bool> saveToken(String token) async =>
      saveString(SharedConstants.accessToken, token);
  String? getToken() => getString(SharedConstants.accessToken);

  Future<bool> saveRole(String role) async =>
      saveString(SharedConstants.userRole, role);
  String? getRole() => getString(SharedConstants.userRole);
  static const _kSavedEmail = 'saved_email';
  static const _kSavedPassword = 'saved_password';
  // Optional saved credentials (use with caution)
  Future<bool> saveEmail(String email) async => saveString(_kSavedEmail, email);
  String? getEmail() => getString(_kSavedEmail);

  Future<bool> savePassword(String password) async =>
      saveString(_kSavedPassword, password);
  String? getPassword() => getString(_kSavedPassword);
  Future<bool> saveUserId(int id) async =>
      saveString(SharedConstants.userId, id.toString());
  int? getUserId() {
    final id = getString(SharedConstants.userId);
    return id != null ? int.tryParse(id) : null;
  }
}
