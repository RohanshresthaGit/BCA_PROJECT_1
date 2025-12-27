import 'package:flutter/material.dart';
import 'package:event_management/config/localization/l10n/app_localizations.dart';

/// Extension on BuildContext for common UI operations
extension BuildContextExt on BuildContext {
  /// Get localization instance
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if dark mode is enabled
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get app bar theme color
  Color? get appBarColor => Theme.of(this).appBarTheme.backgroundColor;

  /// Show snackbar with message
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.red);
  }

  /// Show warning snackbar
  void showWarningSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.orange);
  }
}

/// Extension on NavigatorState for navigation
extension NavigationExt on NavigatorState {
  /// Navigate to login page
  Future<dynamic> goToLogin() => pushNamed('/login');

  /// Navigate to signup page
  Future<dynamic> goToSignup() => pushNamed('/signup');

  /// Navigate to home page and replace current route
  Future<dynamic> goToHome() => pushReplacementNamed('/');

  /// Pop current route
  void pop<T extends Object?>([T? result]) => Navigator.of(context).pop(result);
}

/// Extension on BuildContext for navigation shortcuts
extension NavigationContextExt on BuildContext {
  /// Navigate to login page
  Future<dynamic> goToLogin() => Navigator.of(this).goToLogin();

  /// Navigate to signup page
  Future<dynamic> goToSignup() => Navigator.of(this).goToSignup();

  /// Navigate to home page and replace current route
  Future<dynamic> goToHome() => Navigator.of(this).goToHome();

  /// Pop current route
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}

/// Extension on String for validation checks
extension StringExt on String {
  /// Check if email is valid
  bool get isValidEmail => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(this);

  /// Check if password is strong (min 6 chars)
  bool get isStrongPassword => length >= 6;

  /// Check if string has minimum length
  bool isMinLength(int minLength) => length >= minLength;
}
