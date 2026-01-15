import 'dart:io';

class UpdateProfileRequest {
  final int userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final int? eventsAttended;
  final File? profilePhoto;

  const UpdateProfileRequest({
    required this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.eventsAttended,
    this.profilePhoto,
  });

  /// Converts ONLY non-null fields to map
  Map<String, dynamic> toFormFields() {
    final Map<String, dynamic> data = {};

    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (gender != null) data['gender'] = gender;
    if (eventsAttended != null) {
      data['eventsAttended'] = eventsAttended.toString();
    }

    return data;
  }
}
