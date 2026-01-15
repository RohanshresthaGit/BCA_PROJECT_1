class BookEventParams {
  final int eventId;
  final int userId;

  BookEventParams({required this.eventId, required this.userId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookEventParams &&
          eventId == other.eventId &&
          userId == other.userId;

  @override
  int get hashCode => Object.hash(eventId, userId);
}
