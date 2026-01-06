import 'package:dio/dio.dart';
import 'package:event_management/config/network/dio_client.dart';
import 'package:event_management/core/constants/end_points.dart';
import 'package:fpdart/fpdart.dart';

import '../models/signup_model.dart';

class AuthRepository {
  static Future<Either<String, UserModel>> register(
    String userName,
    String password,
    String email,
    String role,
  ) async {
    try {
      final res = await DioClient().dio.post(
        EndPoints.signUp,
        data: {
          "username": userName,
          "password": password,
          "email": email,
          "role": role.toUpperCase(),
        },
      );
      if (res.statusCode == 201) {
        return Right(UserModel.fromJson(res.data['user']));
      } else {
        return Left(res.data['message']);
      }
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Server error');
    } catch (e) {
      return Left('Unexpected error occurred $e');
    }
  }

  static Future<Either<String, UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      final res = await DioClient().dio.post(
        EndPoints.logIn,
        data: {
          "email": email,
          "password": password,
        },
      );
      if (res.statusCode == 200) {
        return Right(UserModel.fromJson(res.data['user']));
      } else {
        return Left(res.data['message']);
      }
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Server error');
    } catch (e) {
      return Left('Unexpected error occurred $e');
    }
  }
}
