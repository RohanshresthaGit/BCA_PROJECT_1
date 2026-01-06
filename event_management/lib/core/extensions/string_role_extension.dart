import 'package:event_management/features/auth/models/signup_model.dart';

/// Extension to convert role strings (nullable) into `UserRole` enum.
extension StringRoleExtension on String? {
  UserRole toUserRole() {
    final s = this ?? '';
    try {
      return UserRole.values.firstWhere(
        (e) => e.name.toUpperCase() == s.toUpperCase(),
        orElse: () => UserRole.USER,
      );
    } catch (_) {
      return UserRole.USER;
    }
  }
}
