import 'package:flutter/foundation.dart';

abstract class AuthState {
  const AuthState();
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during sign in/up
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Success state after sign in/up
class AuthSuccess extends AuthState {
  final String userId;
  final String email;
  final String? fullName;

  const AuthSuccess({required this.userId, required this.email, this.fullName});
}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  String toString() => 'AuthError: $message';
}

/// Login state class
@immutable
class LoginState {
  final String email;
  final String password;
  final bool showPassword;

  const LoginState({
    this.email = '',
    this.password = '',
    this.showPassword = false,
  });

  LoginState copyWith({String? email, String? password, bool? showPassword}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}

/// Signup state class
@immutable
class SignupState {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool showPassword;
  final bool showConfirmPassword;

  const SignupState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.showPassword = false,
    this.showConfirmPassword = false,
  });

  SignupState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    bool? showPassword,
    bool? showConfirmPassword,
  }) {
    return SignupState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    );
  }
}
