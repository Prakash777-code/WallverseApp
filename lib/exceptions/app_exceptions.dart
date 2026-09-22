class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class BadRequestException extends AppException {
  BadRequestException(super.message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}

class ServerException extends AppException {
  ServerException(super.message);
}

class SessionExpiredException extends AppException {
  SessionExpiredException(super.message);
}

class ConflictException extends AppException {
  ConflictException(super.message);
}

class ThrottleException extends AppException {
  ThrottleException(super.message);
}
