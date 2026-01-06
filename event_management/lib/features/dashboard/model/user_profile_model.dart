class UserProfileModel {
  final String? fullName;
  final String? email;
  final String? role;
  final String? phone;
  final String? gender;
  final String? profilePicture;
  final int? eventsAttended;

  const UserProfileModel({
    this.fullName,
    this.email,
    this.role,
    this.phone,
    this.gender,
    this.profilePicture,
    this.eventsAttended,
  });

  /// JSON → Model
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      profilePicture: json['profilePicture'] as String?,
      eventsAttended: json['eventsAttended'] as int?,
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'role': role,
      'phone': phone,
      'gender': gender,
      'profilePicture': profilePicture,
      'eventsAttended': eventsAttended,
    };
  }

  /// Copy helper (very useful for state management)
  UserProfileModel copyWith({
    String? fullName,
    String? email,
    String? role,
    String? phone,
    String? gender,
    String? profilePicture,
    int? eventsAttended,
  }) {
    return UserProfileModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
      eventsAttended: eventsAttended ?? this.eventsAttended,
    );
  }
}
