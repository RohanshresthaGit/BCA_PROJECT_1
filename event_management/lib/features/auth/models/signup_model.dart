class LoginResponseModel {
  final bool success;
  final String message;
  final UserModel user;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user.toJson(),
    };
  }
}

class UserModel {
  final String token;
  final String userId;
  final UserRole role;

  UserModel({
    required this.token,
    required this.userId,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] as String,
      userId: json['userId'] as String,
      role: userRoleFromString(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'role': role.name,
    };
  }
}

enum UserRole { ADMIN, ORGANIZER, USER }

UserRole userRoleFromString(String role) {
  return UserRole.values.firstWhere(
    (e) => e.name == role,
    orElse: () => UserRole.USER,
  );
}

