import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'AuthService.dart';
import 'api_endpoint_urls.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "${APIEndpointUrls.baseUrl}",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {"Content-Type": "application/json"},
      validateStatus: (status) {
        return true;
      },
    ),
  );

  static const List<String> _unauthenticatedEndpoints = [
    '/api/app/send-otp',
    '/api/app/verify-otp',
    '/api/app/refresh-token-for-user',
  ];

  static void setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('Interceptor triggered for: ${options.uri}');

        // Check if the request is for an unauthenticated endpoint
        final isUnauthenticated = _unauthenticatedEndpoints.any(
              (endpoint) => options.uri.path.startsWith(endpoint), // Use startsWith instead of endsWith
        );

        if (isUnauthenticated) {
          debugPrint('Unauthenticated endpoint, skipping token check: ${options.uri}');
          return handler.next(options); // Skip token check and proceed
        }

        final isExpired = await AuthService.isTokenExpired();
        if (isExpired) {
          debugPrint('Token is expired, attempting to refresh...');
          final refreshed = await _refreshToken();
          if (!refreshed) {
            debugPrint('❌ Token refresh failed, redirecting to login...');
            await AuthService.logout();
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Token refresh failed, please log in again',
                type: DioExceptionType.cancel,
              ),
            );
          }
        }



        final accessToken = await AuthService.getAccessToken();
        debugPrint('Token retrieved for request: $accessToken');
        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
        } else {
          debugPrint('❌ No access token available, redirecting to login...');
          await AuthService.logout();
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'No access token available, please log in again',
              type: DioExceptionType.cancel,
            ),
          );
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        final isUnauthenticated = _unauthenticatedEndpoints.any(
              (endpoint) => e.requestOptions.uri.path.endsWith(endpoint),
        );

        if (isUnauthenticated) {
          debugPrint('Unauthenticated endpoint error, skipping logout: ${e.requestOptions.uri}');
          return handler.next(e); // Skip logout for unauthenticated endpoints
        }

        if (e.response?.statusCode == 401) {
          debugPrint('❌ Unauthorized: Token invalid or user not found, redirecting to login...');
          await AuthService.logout();
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: 'Unauthorized, please log in again',
              type: DioExceptionType.badResponse,
              response: e.response,
            ),
          );
        }
        return handler.next(e); // Pass other errors to the next interceptor
      },
    ));
  }

  static Future<bool> _refreshToken() async {
    try {
      final newToken = await AuthService.refreshToken();
      if (newToken) {
        debugPrint("✅ Token refreshed successfully");
        return true;
      }
      debugPrint("❌ Token refresh returned false");
    } catch (e) {
      debugPrint("❌ Token refresh failed: $e");
    }
    return false;
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Response _handleError(dynamic error) {
    if (error is DioException) {
      throw error;
    } else {
      throw Exception("Unexpected error occurred");
    }
  }

  // Placeholder for _handleNavigation (implement as needed)
  static void _handleNavigation(
    int? statusCode,
    GlobalKey<NavigatorState> navigatorKey,
  ) {}
}
