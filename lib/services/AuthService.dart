import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../services/api_endpoint_urls.dart';
import '../services/ApiClient.dart';
import '../utils/constants.dart';

class AuthService {
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _tokenExpiryKey = "token_expiry";

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Check if the user is a guest (no token or empty token)
  static Future<bool> get isGuest async {
    final token = await getAccessToken();
    return token == null || token.isEmpty;
  }

  /// Get stored access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get stored refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Check if token is expired
  static Future<bool> isTokenExpired() async {
    final expiryTimestampStr = await _storage.read(key: _tokenExpiryKey);
    if (expiryTimestampStr == null) {
      debugPrint('No expiry timestamp found, considering token expired');
      return true;
    }

    final expiryTimestamp = int.tryParse(expiryTimestampStr);
    if (expiryTimestamp == null) {
      debugPrint('Invalid expiry timestamp format, considering token expired');
      return true;
    }

    final now =
        DateTime.now().millisecondsSinceEpoch ~/
        1000; // current time in seconds

    final isExpired = now >= expiryTimestamp;

    debugPrint(
      'Token expiry check: now=$now, expiry=$expiryTimestamp, isExpired=$isExpired',
    );
    return isExpired;
  }

  // static Future<bool> isTokenExpired() async {
  //   final expiryTimestamp = await _storage.read(key: _tokenExpiryKey);
  //   if (expiryTimestamp == null) {
  //     debugPrint('No expiry timestamp found, considering token expired');
  //     return true;
  //   }
  //
  //   final now = DateTime.now().millisecondsSinceEpoch ~/ 1000; // ✅ Convert to seconds
  //   final isExpired = now >= expiryTimestamp;
  //
  //   debugPrint('Token expiry check: now=$now, expiry=$expiryTimestamp, isExpired=$isExpired');
  //   return isExpired;
  // }

  /// Save tokens and expiry time
  static Future<void> saveTokens(
    String accessToken,
    String? refreshToken,
    int expiresIn,
  ) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken ?? "");
    await _storage.write(key: _tokenExpiryKey, value: expiresIn.toString());
    debugPrint('Tokens saved: accessToken=$accessToken, expiryTime=$expiresIn');
  }

  /// Refresh token
  // static Future<bool> refreshToken() async {
  //   final refreshToken = await getRefreshToken();
  //   if (refreshToken == null) {
  //     debugPrint('❌ No refresh token available');
  //     return false;
  //   }
  //
  //   try {
  //     final response = await ApiClient.post(
  //       APIEndpointUrls.refreshtoken,
  //       data: {"refresh": refreshToken},
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final tokenData = response.data["data"];
  //       final newAccessToken = tokenData["access"];
  //       final newRefreshToken = tokenData["refresh"];
  //       final expiryTime = tokenData["expiry_time"];
  //
  //       if (newAccessToken == null || newRefreshToken == null || expiryTime == null) {
  //         debugPrint("❌ Missing token data in response: $tokenData");
  //         return false;
  //       }
  //
  //       await saveTokens(newAccessToken, newRefreshToken, expiryTime);
  //       debugPrint("✅ Token refreshed and saved successfully");
  //       return true;
  //     } else {
  //       debugPrint("❌ Refresh token request failed with status: ${response.statusCode}");
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Token refresh failed: $e");
  //     return false;
  //   }
  // }

  /// Logout and clear tokens, redirect to sign-in screen
  // static Future<void> logout() async {
  //   await _storage.deleteAll(); // clear all tokens
  //   debugPrint('Tokens cleared, user logged out');
  //
  //   final context = navigatorKey.currentContext;
  //   if (context != null) {
  //     GoRouter.of(context).go('/onboarding');
  //   } else {
  //     debugPrint('Context is null, scheduling GoRouter navigation after frame');
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       final postFrameContext = navigatorKey.currentContext;
  //       if (postFrameContext != null) {
  //         GoRouter.of(postFrameContext).go('/onboarding');
  //       } else {
  //         debugPrint('Still no context available after frame');
  //         // Optional: consider forcing rebuild or restarting app
  //       }
  //     });
  //   }
  // }
  static Future<void> logout() async {
    await _storage.deleteAll(); // clear all tokens
    debugPrint('Tokens cleared, user logged out');

    // Use a post-frame callback with a short delay
    Future.microtask(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(
          const Duration(milliseconds: 100),
        ); // ensures context is ready
        final context = navigatorKey.currentContext;

        if (context != null) {
          debugPrint('Navigating to /onboarding');
          GoRouter.of(context).go('/onboarding');
        } else {
          debugPrint('Navigation context still null after delay');
        }
      });
    });
  }
}
