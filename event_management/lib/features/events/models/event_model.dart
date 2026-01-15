class EventModel {
  final int id;
  final String eventName;
  final String? description;
  final String organizerId; // changed from String to int
  final String dateFrom;
  final String dateTo;
  final String timeFrom;
  final String timeTo;
  final String? eventPhotoPath;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String createdAt;
  final String? updatedAt;

  EventModel({
    required this.id,
    required this.eventName,
    this.description,
    required this.organizerId,
    required this.dateFrom,
    required this.dateTo,
    required this.timeFrom,
    required this.timeTo,
    this.eventPhotoPath,
    this.address,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      eventName: json['eventName'],
      description: json['description'],
      organizerId: json['organizer_id'], // make sure API returns int
      dateFrom: json['dateFrom'],
      dateTo: json['dateTo'],
      timeFrom: json['timeFrom'],
      timeTo: json['timeTo'],
      eventPhotoPath: json['eventPhotoPath'],
      address: json['address'],
      latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : null,
      longitude: (json['longitude'] != null) ? json['longitude'].toDouble() : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'description': description,
      'organizer_id': organizerId,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
      'eventPhotoPath': eventPhotoPath,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
