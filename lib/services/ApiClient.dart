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
  //
  // static const List<String> _unauthenticatedEndpoints = [
  //   '/api/app/send-otp',
  //   '/api/app/verify-otp',
  //   '/api/app/refresh-token-for-user',
  //   '/api/app/get-all-categories',
  //   '/api/app/get-all-sub-categories',
  //   '/api/app/get-all-listings-with-pagination',
  //   '/api/app/get-all-carousels',
  //   '/api/app/get-all-cities',
  // ];

  // static void setupInterceptors() {
  //   _dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) async {
  //         debugPrint('Interceptor triggered for: ${options.uri}');
  //
  //         // 👉 First check if request path is in unauthenticated list
  //         final isUnauthenticatedEndpoint = _unauthenticatedEndpoints.any(
  //               (endpoint) => options.uri.path.startsWith(endpoint),
  //         );
  //
  //         // 👉 Check guest condition
  //         final isGuestUser = await AuthService.isGuest;
  //
  //         if (isUnauthenticatedEndpoint || isGuestUser) {
  //           debugPrint('Skipping token check for: ${options.uri}');
  //           return handler.next(options); // Don’t attach Authorization
  //         }
  //
  //         // Otherwise: normal flow with token refresh
  //         final isExpired = await AuthService.isTokenExpired();
  //         if (isExpired) {
  //           debugPrint('Token is expired, attempting to refresh...');
  //           final refreshed = await _refreshToken();
  //           if (!refreshed) {
  //             debugPrint('❌ Token refresh failed, redirecting to login...');
  //             await AuthService.logout();
  //             return handler.reject(
  //               DioException(
  //                 requestOptions: options,
  //                 error: 'Token refresh failed, please log in again',
  //                 type: DioExceptionType.cancel,
  //               ),
  //             );
  //           }
  //         }
  //
  //         final accessToken = await AuthService.getAccessToken();
  //         if (accessToken != null) {
  //           options.headers["Authorization"] = "Bearer $accessToken";
  //         }
  //
  //         return handler.next(options);
  //       },
  //       onResponse: (response, handler) {
  //         return handler.next(response);
  //       },
  //       onError: (DioException e, handler) async {
  //         final isUnauthenticated = _unauthenticatedEndpoints.any(
  //           (endpoint) => e.requestOptions.uri.path.endsWith(endpoint),
  //         );
  //
  //         if (isUnauthenticated) {
  //           debugPrint(
  //             'Unauthenticated endpoint error, skipping logout: ${e.requestOptions.uri}',
  //           );
  //           return handler.next(e); // Skip logout for unauthenticated endpoints
  //         }
  //
  //         if (e.response?.statusCode == 401) {
  //           debugPrint(
  //             '❌ Unauthorized: Token invalid or user not found, redirecting to login...',
  //           );
  //           await AuthService.logout();
  //           return handler.reject(
  //             DioException(
  //               requestOptions: e.requestOptions,
  //               error: 'Unauthorized, please log in again',
  //               type: DioExceptionType.badResponse,
  //               response: e.response,
  //             ),
  //           );
  //         }
  //         return handler.next(e); // Pass other errors to the next interceptor
  //       },
  //     ),
  //   );
  // }

  static void setupInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint('Interceptor triggered for: ${options.uri}');
          final isGuestUser = await AuthService.isGuest;
          if (isGuestUser) {
            // 🚫 Guest → no token
            debugPrint('Guest user → skipping token for ${options.uri}');
            options.headers.remove('Authorization');
            return handler.next(options);
          }
          // ✅ Non-guest → token required
          final isExpired = await AuthService.isTokenExpired();
          if (isExpired) {
            debugPrint('Token expired → trying refresh...');
            final refreshed = await _refreshToken();
            if (!refreshed) {
              debugPrint('❌ Token refresh failed, logging out...');
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
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          } else {
            debugPrint('⚠️ Non-guest but no token found');
          }

          return handler.next(options);
        },

        onResponse: (response, handler) => handler.next(response),

        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            debugPrint('❌ 401 Unauthorized, logging out...');
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
          return handler.next(e);
        },
      ),
    );
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
