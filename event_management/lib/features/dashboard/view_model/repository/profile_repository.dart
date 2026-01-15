import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_management/config/network/dio_client.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../config/storage/shared_prefs_service.dart';
import '../../../../core/constants/shared_constants.dart';
import '../../model/user_profile_model.dart';

class ProfileRepository {
  static Future<Either<String, String>> deleteProfile(int userId) async {
    try {
      final res = await DioClient().dio.delete('/api/profile/$userId');
      if (res.statusCode == 200) {
        await SharedPrefsService.instance.clearAll();
        return Right(res.data['message'] ?? 'Profile deleted successfully');
      }
      return Left(res.data['message'] ?? 'Failed to delete profile');
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Server error');
    } catch (e) {
      return Left('Unexpected error occurred $e');
    }
  }
  static Future<Either<String, UserProfileModel>> fetchProfile(
    int userId,
  ) async {
    try {
      final res = await DioClient().dio.get('/api/profile/$userId');
      if (res.statusCode == 200) {
        final profile = UserProfileModel.fromJson(res.data);
        SharedPrefsService.instance.saveString(
          SharedConstants.userDetails,
          jsonEncode(profile.toJson()),
        );
        return right(profile);
      }
      return Left(res.data['message'] ?? 'Failed to fetch profile');
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Server error');
    } catch (e) {
      return Left('Unexpected error occurred $e');
    }
  }

  static Future<Either<String, String>> updateProfile(
    int userId,
    Map<String, dynamic> updatedData,
    File? image,
  ) async {
    try {
      FormData formData = FormData.fromMap(updatedData);
      if (image != null) {
        String fileName = image.path.split('/').last;
        formData.files.add(
          MapEntry(
            'profilePhoto',
            await MultipartFile.fromFile(image.path, filename: fileName),
          ),
        );
      }
      final res = await DioClient().dio.patch(
        '/api/profile/$userId',
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        data: formData,
      );
      if (res.statusCode == 200) {
        return Right(res.data['message'] ?? 'Profile updated successfully');
      }
      return Left(res.data['message'] ?? 'Failed to update profile');
    } on DioException catch (e) {
      log(e.toString());
      return Left(e.response?.data['message'] ?? 'Server error');
    } catch (e) {
      return Left('Unexpected error occurred $e');
    }
  }
}
