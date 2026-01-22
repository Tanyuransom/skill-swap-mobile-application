class AppException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  AppException(this.message, {this.statusCode = 500, this.data});

  @override
  String toString() => message;
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, statusCode: 404);
}

class BadRequestException extends AppException {
  BadRequestException(String message, {dynamic data})
      : super(message, statusCode: 400, data: data);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message, statusCode: 401);
}

class ForbiddenException extends AppException {
  ForbiddenException(String message) : super(message, statusCode: 403);
}

class ConflictException extends AppException {
  ConflictException(String message) : super(message, statusCode: 409);
}

class ValidationException extends AppException {
  ValidationException(String message, {Map<String, dynamic>? errors})
      : super(message, statusCode: 422, data: errors);
}

class DatabaseException extends AppException {
  DatabaseException(String message) : super(message, statusCode: 500);
}
