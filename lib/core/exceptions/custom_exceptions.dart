/// Custom exceptions for the application
/// 
/// This file contains all the custom exceptions used in the application
/// to handle specific error cases in a more granular way.
library;

/// Base class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AppException(this.message, [this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message';
}

/// Exception for network related errors
class NetworkException extends AppException {
  const NetworkException(super.message, [super.stackTrace]);
}

/// Exception for server errors (5xx)
class ServerException extends AppException {
  final int statusCode;

  const ServerException(
    String message,
    this.statusCode, [
    StackTrace? stackTrace,
  ]) : super(message, stackTrace);
}

/// Exception for unauthorized access (401)
class UnauthorizedException extends AppException {
  const UnauthorizedException([String? message, StackTrace? stackTrace])
      : super(message ?? 'Unauthorized access', stackTrace);
}

/// Exception for forbidden access (403)
class ForbiddenException extends AppException {
  const ForbiddenException([String? message, StackTrace? stackTrace])
      : super(message ?? 'Forbidden access', stackTrace);
}

/// Exception for not found errors (404)
class NotFoundException extends AppException {
  const NotFoundException([String? message, StackTrace? stackTrace])
      : super(message ?? 'Resource not found', stackTrace);
}

/// Exception for bad requests (400)
class BadRequestException extends AppException {
  final Map<String, dynamic>? errors;

  const BadRequestException([String? message, this.errors, StackTrace? stackTrace])
      : super(message ?? 'Bad request', stackTrace);
}

/// Exception for validation errors (422)
class ValidationException extends AppException {
  final Map<String, dynamic> errors;

  const ValidationException(this.errors, [StackTrace? stackTrace])
      : super('Validation failed', stackTrace);
}

/// Exception for timeout errors
class TimeoutException extends AppException {
  const TimeoutException([String? message, StackTrace? stackTrace])
      : super(message ?? 'Request timed out', stackTrace);
}

/// Exception for cache related errors
class CacheException extends AppException {
  const CacheException(super.message, [super.stackTrace]);
}

/// Exception for when a feature is not implemented
class NotImplementedException extends AppException {
  const NotImplementedException([String? message, StackTrace? stackTrace])
      : super(message ?? 'Feature not implemented', stackTrace);
}

/// Exception for when a user is not authenticated
class UnauthenticatedException extends AppException {
  const UnauthenticatedException([String? message, StackTrace? stackTrace])
      : super(message ?? 'User is not authenticated', stackTrace);
}

/// Exception for when a feature is not available
class FeatureNotAvailableException extends AppException {
  const FeatureNotAvailableException([String? message, StackTrace? stackTrace])
      : super(message ?? 'Feature not available', stackTrace);
}

/// Exception for when there's no internet connection
class NoInternetException extends AppException {
  const NoInternetException([String? message, StackTrace? stackTrace])
      : super(message ?? 'No internet connection', stackTrace);
}