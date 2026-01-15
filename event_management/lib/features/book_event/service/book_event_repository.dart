import 'package:dio/dio.dart';
import 'package:event_management/config/network/dio_client.dart';
import 'package:fpdart/fpdart.dart';

class BookEventRepository {
  static Future<bool> isEventBooked(int eventId, int userId) async {
    try {
      final res = await DioClient().get(
        '/api/event/checkIsBooked/$eventId',
        queryParameters: {'userId': userId},
      );
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Either<String, String>> bookEvent(
    int eventId,
    int userId,
  ) async {
    try {
      final res = await DioClient().post(
        '/api/events/book/$eventId',
        data: {'userId': userId},
      );
      if (res.statusCode == 200) {
        return Right('Event booked successfully');
      } else {
        return Left('Failed to book event');
      }
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Server error');
    } catch (e) {
      return Left('Unexpected error occurred $e');
    }
  }
}
