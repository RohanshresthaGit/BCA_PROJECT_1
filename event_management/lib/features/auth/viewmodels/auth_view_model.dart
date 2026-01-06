import 'package:event_management/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../config/storage/shared_prefs_service.dart';
import '../../../core/constants/shared_constants.dart';
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

      final res = await AuthRepository.login(email, password);
      res.match((error) => state = AuthError(error), (success) {
        state = AuthSuccess(
          userId: success.userId,
          email: email,
          token: success.token,
          role: success.role.name,
        );
        // persist token and role
        if (success.token.isNotEmpty) {
          SharedPrefsService.instance.saveToken(success.token);
        }
        SharedPrefsService.instance.saveRole(success.role.name);
        SharedPrefsService.instance.saveString(
          SharedConstants.userId,
          success.userId,
        );
        SharedPrefsService.instance.savePassword(password);
        SharedPrefsService.instance.saveEmail(email);
      });
    } catch (e) {
      state = AuthError('An error occurred: ${e.toString()}');
    }
  }

  /// Sign up with full details
  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
  }) async {
    state = const AuthLoading();

    try {
      // Validate using validator class
      final nameError = AuthValidator.validateFullName(userName);
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
      final res = await AuthRepository.register(
        userName,
        password,
        email,
        role,
      );

      res.match((error) => state = AuthError(error), (success) {
        state = AuthSuccess(
          userId: success.userId,
          email: email,
          fullName: userName,
          token: success.token,
          role: success.role.name,
        );
        if (success.token.isNotEmpty) {
          SharedPrefsService.instance.saveToken(success.token);
        }
        SharedPrefsService.instance.saveRole(success.role.name);
      });
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
