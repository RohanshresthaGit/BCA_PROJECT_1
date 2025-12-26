class UnauthenticatedException implements Exception {
  final String message;
  UnauthenticatedException([this.message = 'Unauthenticated (401)']);
  @override
  String toString() => 'UnauthenticatedException: $message';
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Resource not found (404)']);
  @override
  String toString() => 'NotFoundException: $message';
}
