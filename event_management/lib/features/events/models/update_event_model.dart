import 'dart:io';

class UpdateEventModel {
  int id; // required for update
  String eventName;
  String? description;
  String dateFrom;
  String dateTo;
  String timeFrom;
  String timeTo;
  String? address;
  double? latitude;
  double? longitude;
  String? eventPhotoPath; // existing URL
  File? eventPhotoFile; // new image to upload

  UpdateEventModel({
    required this.id,
    required this.eventName,
    this.description,
    required this.dateFrom,
    required this.dateTo,
    required this.timeFrom,
    required this.timeTo,
    this.address,
    this.latitude,
    this.longitude,
    this.eventPhotoPath,
    this.eventPhotoFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'description': description,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
      'address': address,
      'latitude': latitude?.toString(),
      'longitude': longitude?.toString(),
      'eventPhotoPath': eventPhotoPath,
    };
  }
}
