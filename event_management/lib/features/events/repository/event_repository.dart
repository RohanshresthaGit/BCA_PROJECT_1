import 'package:dio/dio.dart';
import 'package:event_management/config/network/dio_client.dart';
import 'package:event_management/features/events/models/update_event_model.dart';
import 'package:fpdart/fpdart.dart';

import '../models/create_event_model.dart';
import '../models/event_model.dart';

class EventRepository {
  static Future<Either<String, List<EventModel>>> getAllEvents() async {
    try {
      final res = await DioClient().get('/api/events');
      if (res.statusCode == 200) {
        List<dynamic> data = res.data;
        List<EventModel> events = data
            .map((e) => EventModel.fromJson(e))
            .toList();
        return Right(events);
      } else {
        return Left('Failed to load events');
      }
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Server error');
    } catch (e) {
      return Left('Unexpected error occurred $e');
    }
  }

  static Future<Either<String, EventModel>> createEvent(
    CreateEventRequest request,
  ) async {
    try {
      final formData = FormData.fromMap({
        "eventName": request.eventName,
        "description": request.description ?? "",
        "organizer_id": request.organizerId,
        "dateFrom": request.dateFrom,
        "dateTo": request.dateTo,
        "timeFrom": request.timeFrom,
        "timeTo": request.timeTo,
        "address": request.address ?? "",
        "latitude": request.latitude?.toString() ?? "",
        "longitude": request.longitude?.toString() ?? "",
      });
      if (request.eventPhotoPath != null) {
        String fileName = request.eventPhotoPath!.path.split('/').last;
        formData.files.add(
          MapEntry(
            'profilePhoto',
            await MultipartFile.fromFile(
              request.eventPhotoPath!.path,
              filename: fileName,
            ),
          ),
        );
      }

      final response = await DioClient().post(
        "/api/events",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );
      if (response.statusCode == 201) {
        return Right(EventModel.fromJson(response.data['data']));
      }
      return Left("Failed to Create Event");
    } on DioException catch (e) {
      return Left("Failed to Create Event");
    } catch (e) {
      return Left("Failed to Create Event");
    }
  }

  /// Update event
  static Future<Either<String, String>> updateEvent(
    UpdateEventModel event,
  ) async {
    try {
      final formData = FormData.fromMap({
        "eventName": event.eventName,
        "description": event.description,
        "dateFrom": event.dateFrom,
        "dateTo": event.dateTo,
        "timeFrom": event.timeFrom,
        "timeTo": event.timeTo,
        "address": event.address,
        "eventPhotoPath": event.eventPhotoPath,
        "latitude": event.latitude,
        "longitude": event.longitude,
      });

      if (event.eventPhotoFile != null) {
        final fileName = event.eventPhotoFile!.path.split('/').last;
        formData.files.add(
          MapEntry(
            'eventPhoto',
            await MultipartFile.fromFile(
              event.eventPhotoFile!.path,
              filename: fileName,
            ),
          ),
        );
      }

      final response = await DioClient().put(
        '/api/events/${event.id}',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.data['success'] == true) {
        return Right(response.data['data']);
      } else {
        return Left('Failed to update event');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, String>> deleteEvent(int eventId) async {
    try {
      final res = await DioClient().delete('/api/events/$eventId');
      if (res.statusCode == 200) {
        return Right("Event Deleted Succesfully.");
      }
      return Left(res.data['message'] ?? "Failed to Delete Event.");
    } on DioException catch (e) {
      return Left(e.toString() ?? "Failed to Delete Event.");
    } catch (e) {
      return Left(e.toString() ?? "Something went wrong");
    }
  }
}
