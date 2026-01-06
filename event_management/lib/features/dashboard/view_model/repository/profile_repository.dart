import 'package:dio/dio.dart';
import 'package:event_management/config/network/dio_client.dart';
import 'package:fpdart/fpdart.dart';

import '../../model/user_profile_model.dart';

class ProfileRepository {
  static Future<Either<String, UserProfileModel>> fetchProfile(
    int userId,
  ) async {
    try {
      final res = await DioClient().dio.get('/api/profile/$userId');
      if (res.statusCode == 200) {
        final profile = UserProfileModel.fromJson(res.data);
        return right(profile);
      }
      return Left(res.data['message'] ?? 'Failed to fetch profile');
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Server error');
    } catch (e) {
      return Left('Unexpected error occurred $e');
    }
  }
}
