import 'dart:io';

class CreateEventRequest {
  final String eventName;
  final String? description;
  final String organizerId;
  final String dateFrom;
  final String dateTo;
  final String timeFrom;
  final String timeTo;
  final String? address;
  final double? latitude;
  final double? longitude;
  final File? eventPhotoPath; // Local file path

  CreateEventRequest({
    required this.eventName,
    this.description,
    required this.organizerId,
    required this.dateFrom,
    required this.dateTo,
    required this.timeFrom,
    required this.timeTo,
    this.address,
    this.latitude,
    this.longitude,
    this.eventPhotoPath,
  });

  Map<String, dynamic> toJson() => {
        "eventName": eventName,
        "description": description,
        "organizer_id": organizerId,
        "dateFrom": dateFrom,
        "dateTo": dateTo,
        "timeFrom": timeFrom,
        "timeTo": timeTo,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "eventPhotoPath": eventPhotoPath,
      };
}
