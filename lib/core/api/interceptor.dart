import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../exceptions/custom_exceptions.dart';
import '../keys/shared_prefs_keys.dart';

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();
      
      // Add auth token if available
      final authToken = prefs.getString(SharedPrefsKeys.authToken);
      if (authToken != null && authToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $authToken';
      }

      // Continue with the request
      handler.next(options);
    } catch (e) {
      // Throw custom exception for cache failures
      handler.reject(
        DioException(
          requestOptions: options,
          error: CacheException('Failed to access local storage'),
        ),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle successful responses
    if (response.statusCode == 200 || response.statusCode == 201) {
      // You can save new tokens if they come in responses
      if (response.data != null && response.data['token'] != null) {
        _saveToken(response.data['token']);
      }
      return handler.next(response);
    }

    // Handle different status codes with custom exceptions
    final exception = _handleStatusCode(response);
    handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: exception,
      ),
    );
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle Dio errors and convert to custom exceptions
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      err = err.copyWith(
        error: TimeoutException('Request timed out', err.stackTrace),
      );
    } else if (err.type == DioExceptionType.connectionError) {
      err = err.copyWith(
        error: NoInternetException('No internet connection', err.stackTrace),
      );
    } else if (err.response != null) {
      // Handle HTTP error status codes
      err = err.copyWith(
        error: _handleStatusCode(err.response!),
      );
    }

    // Special handling for 401 unauthorized
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPrefsKeys.authToken);
      // You might want to add navigation to login screen here
    }

    handler.next(err);
  }

  AppException _handleStatusCode(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;
    final stackTrace = StackTrace.current;

    switch (statusCode) {
      case 400:
        return BadRequestException(
          'Invalid request', data['errors'], stackTrace);
      case 401:
        return UnauthorizedException(data['message'] ?? 'Unauthorized', stackTrace);
      case 403:
        return ForbiddenException(data['message'] ?? 'Forbidden', stackTrace);
      case 404:
        return NotFoundException(data['message'] ?? 'Resource not found', stackTrace);
      case 422:
        return ValidationException(data['errors'] ?? {}, stackTrace);
      case 500:
      case 502:
      case 503:
        return ServerException(
          data['message'] ?? 'Server error', statusCode!, stackTrace);
      default:
        return NetworkException(
          data['message'] ?? 'Network error occurred', stackTrace);
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefsKeys.authToken, token);
    } catch (e) {
      throw CacheException('Failed to save token');
    }
  }
}