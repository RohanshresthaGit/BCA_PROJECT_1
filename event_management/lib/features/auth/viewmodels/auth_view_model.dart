import 'package:flutter_riverpod/legacy.dart';
import '../models/auth_state.dart';
import '../validators/auth_validator.dart';

/// Auth View Model for handling login and signup logic
class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel() : super(const AuthInitial());

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    state = const AuthLoading();

    try {
      // Validate using validator class
      final emailError = AuthValidator.validateEmail(email);
      if (emailError != null) {
        state = AuthError(emailError);
        return;
      }

      final passwordError = AuthValidator.validatePassword(password);
      if (passwordError != null) {
        state = AuthError(passwordError);
        return;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock success response
      state = AuthSuccess(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
      );
    } catch (e) {
      state = AuthError('An error occurred: ${e.toString()}');
    }
  }

  /// Sign up with full details
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AuthLoading();

    try {
      // Validate using validator class
      final nameError = AuthValidator.validateFullName(fullName);
      if (nameError != null) {
        state = AuthError(nameError);
        return;
      }

      final emailError = AuthValidator.validateEmail(email);
      if (emailError != null) {
        state = AuthError(emailError);
        return;
      }

      final passwordError = AuthValidator.validatePassword(password);
      if (passwordError != null) {
        state = AuthError(passwordError);
        return;
      }

      final confirmError = AuthValidator.validateConfirmPassword(
        confirmPassword,
        password,
      );
      if (confirmError != null) {
        state = AuthError(confirmError);
        return;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock success response
      state = AuthSuccess(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        fullName: fullName,
      );
    } catch (e) {
      state = AuthError('An error occurred: ${e.toString()}');
    }
  }

  /// Reset auth state to initial
  void reset() {
    state = const AuthInitial();
  }
}

/// Riverpod provider for auth view model
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel();
});

/// Riverpod provider for login form state
final loginFormProvider = StateProvider<LoginState>((ref) {
  return const LoginState();
});

/// Riverpod provider for signup form state
final signupFormProvider = StateProvider<SignupState>((ref) {
  return const SignupState();
});
