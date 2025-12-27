/// Validation class for auth form fields
class AuthValidator {
  /// Validates email field
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  /// Validates full name field
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  /// Validates password field
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates confirm password matches password
  static String? validateConfirmPassword(String? value, String passwordValue) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordValue) {
      return 'Passwords do not match';
    }
    return null;
  }
}
