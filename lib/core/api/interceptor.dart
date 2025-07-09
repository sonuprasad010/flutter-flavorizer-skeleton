import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../exceptions/custom_exceptions.dart';
import '../keys/shared_prefs_keys.dart';

class AppInterceptor extends Interceptor {
  /// Use this dio only for refersh token
  final Dio _refreshDio = Dio();

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
  // | -------------------------------------------
  // | Properly handle success message according  |
  // | to specifice need. For most cases, it      |
  // | does not need to be changed.               |
  // --------------------------------------------
  //
  //
  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   // Handle successful responses
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return handler.next(response);
  //   }

  //   // Handle different status codes with custom exceptions
  //   final exception = _handleStatusCode(response);
  //   handler.reject(
  //     DioException(
  //       requestOptions: response.requestOptions,
  //       response: response,
  //       error: exception,
  //     ),
  //   );
  // }

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
      err = err.copyWith(error: _handleStatusCode(err.response!));
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
          'Invalid request',
          data['errors'],
          stackTrace,
        );
      case 401:
        return UnauthorizedException(
          data['message'] ?? 'Unauthorized',
          stackTrace,
        );
      case 403:
        return ForbiddenException(data['message'] ?? 'Forbidden', stackTrace);
      case 404:
        return NotFoundException(
          data['message'] ?? 'Resource not found',
          stackTrace,
        );
      case 422:
        return ValidationException(data['errors'] ?? {}, stackTrace);
      case 500:
      case 502:
      case 503:
        return ServerException(
          data['message'] ?? 'Server error',
          statusCode!,
          stackTrace,
        );
      default:
        return NetworkException(
          data['message'] ?? 'Network error occurred',
          stackTrace,
        );
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


  /// This is for implement refresh token
  /// If your api does not support refresh token
  /// you can remove this method
  Future<String?> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(SharedPrefsKeys.refreshToken);

      if (refreshToken == null || refreshToken.isEmpty) {
        throw UnauthenticatedException('No refresh token available');
      }

      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        /** 
         *  __________________________________________________
         *  | Change the keys based on you api response      |
         *  | For this, I am assuming token and refreshToken |
         *  | Both are keys available in the response        |
         *  |________________________________________________|
         */
        final newToken = response.data['token'] as String;
        final newRefreshToken = response.data['refreshToken'] as String?;

        await prefs.setString(SharedPrefsKeys.authToken, newToken);
        if (newRefreshToken != null) {
          await prefs.setString(SharedPrefsKeys.refreshToken, newRefreshToken);
        }

        return newToken;
      }
      return null;
    } catch (e) {
      throw UnauthenticatedException('Failed to refresh token');
    }
  }
}
