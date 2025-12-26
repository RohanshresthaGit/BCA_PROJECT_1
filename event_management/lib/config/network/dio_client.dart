import 'package:dio/dio.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import '../env.dart';
import 'exceptions.dart';

/// Simple Dio client singleton with request and response interceptors.
///
/// - Adds `Authorization: Bearer <token>` if a token provider is supplied.
/// - Uses `ChuckerDioInterceptor` for inspection.
/// - Converts 401 -> `UnauthenticatedException`, 404 -> `NotFoundException`.
class DioClient {
  DioClient._internal();
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  Dio? _dio;

  /// Provide a token getter which returns the current auth token (or null).
  /// Example: () async => await SecureStorage.read('access_token')
  void init({
    String? baseUrl,
    Future<String?> Function()? tokenGetter,
    bool enableChucker = true,
  }) {
    final resolvedBase = baseUrl ?? Env.apiBaseUrl;
    final options = BaseOptions(
      baseUrl: resolvedBase,
      connectTimeout: const Duration(seconds: 15),
    );

    _dio = Dio(options);

    // Request interceptor to add auth header
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            if (tokenGetter != null) {
              final token = await tokenGetter();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
          } catch (_) {}
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final status = response.statusCode ?? 0;
          if (status == 401) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: UnauthenticatedException(),
              ),
            );
          }
          if (status == 404) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: NotFoundException(),
              ),
            );
          }
          return handler.next(response);
        },
        onError: (err, handler) {
          // If the server responded with a status, map 401/404 as well
          final status = err.response?.statusCode;
          if (status == 401) {
            return handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: UnauthenticatedException(),
              ),
            );
          }
          if (status == 404) {
            return handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: NotFoundException(),
              ),
            );
          }
          return handler.next(err);
        },
      ),
    );

    if (enableChucker) {
      _dio!.interceptors.add(ChuckerDioInterceptor());
    }
  }

  Dio get dio {
    if (_dio == null) {
      throw StateError('DioClient not initialized. Call init(...) first.');
    }
    return _dio!;
  }

  // HTTP helper methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Never _handleDioException(DioException e) {
    final serverError = e.error;
    if (serverError is UnauthenticatedException) throw serverError;
    if (serverError is NotFoundException) throw serverError;
    if (e.response?.statusCode == 401) throw UnauthenticatedException();
    if (e.response?.statusCode == 404) throw NotFoundException();
    throw e;
  }
}

// Usage example (call during app init):
//
// final client = DioClient();
// client.init(
//   baseUrl: 'https://api.example.com',
//   tokenGetter: () async => await YourSecureStorage.getToken(),
// );
//
// Then in code: await DioClient().dio.get('/events');
