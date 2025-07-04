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
    ),
  );

  static const List<String> _unauthenticatedEndpoints = [];

  static void setupInterceptors() {
    try {
      _dio.interceptors.clear();
      _dio.interceptors.add(
        LogInterceptor(
          request: kDebugMode,
          requestHeader: kDebugMode,
          requestBody: kDebugMode,
          responseHeader: kDebugMode,
          responseBody: kDebugMode,
          error: true,
        ),
      );
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final isUnauthenticated = _unauthenticatedEndpoints.any(
              (endpoint) => options.uri.path.startsWith(endpoint),
            );

            if (isUnauthenticated) {
              return handler.next(options);
            }
            // Check token expiration
            final isExpired = await AuthService.isTokenExpired();
            if (isExpired) {
              await AuthService.logout();
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Token expired, please log in again',
                  type: DioExceptionType.cancel,
                ),
              );
            }
            // Get access token from storage
            final accessToken = await AuthService.getAccessToken();
            if (accessToken == null || accessToken.isEmpty) {
              await AuthService.logout();
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'No access token, please log in again',
                  type: DioExceptionType.cancel,
                ),
              );
            } else {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }

            return handler.next(options);
          },

          onResponse: (response, handler) async {
            // Check if response data signals token expired
            if (response.data is Map<String, dynamic>) {
              final data = response.data as Map<String, dynamic>;
              if (data['status'] == false &&
                  data['message'] == 'Token is expired') {
                await AuthService.logout();
                return handler.reject(
                  DioException(
                    requestOptions: response.requestOptions,
                    error: 'Token expired',
                    response: response,
                    type: DioExceptionType.badResponse,
                  ),
                );
              }
            }

            _handleNavigation(response.statusCode, navigatorKey);
            return handler.next(response);
          },

          onError: (DioException e, handler) async {
            final isUnauthenticated = _unauthenticatedEndpoints.any(
              (endpoint) => e.requestOptions.uri.path.endsWith(endpoint),
            );

            if (isUnauthenticated) {
              return handler.next(e);
            }

            if (e.response?.statusCode == 401) {
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
    } catch (e, stackTrace) {}
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
