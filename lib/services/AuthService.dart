import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/utils/AppLogger.dart';
import '../services/api_endpoint_urls.dart';
import '../services/ApiClient.dart';
import '../utils/constants.dart';

class AuthService {
  static const String _accessTokenKey = "access_token";
  static const String _plan_status = "plan_status";
  static const String _refreshTokenKey = "refresh_token";
  static const String _tokenExpiryKey = "token_expiry";
  static const String _userName = "user_name";
  static const String _email = "email";
  static const String _mobile = "mobile";
  static const String _id = "id";

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Check if the user is a guest (no token or empty token)
  static Future<bool> get isGuest async {
    final token = await getAccessToken();
    return token == null || token.isEmpty;
  }

  static Future<String?> getName() async => await _storage.read(key: _userName);
  static Future<String?> getEmail() async => await _storage.read(key: _email);
  static Future<String?> getMobile() async => await _storage.read(key: _mobile);
  static Future<String?> getId() async => await _storage.read(key: _id);

  static Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);

  static Future<void> setPlanStatus(String status) async =>
      await _storage.write(key: _plan_status, value: status);

  static Future<String?> getPlanStatus() async =>
      await _storage.read(key: _plan_status);

  static Future<bool> get isEligibleForAd async {
    final status = await getPlanStatus();
    return status == "false";
  }

  static Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshTokenKey);

  /// Check if token is expired
  static Future<bool> isTokenExpired() async {
    final expiryTimestampStr = await _storage.read(key: _tokenExpiryKey);
    if (expiryTimestampStr == null) {
      debugPrint('No expiry timestamp found, considering token expired');
      return true;
    }

    final expiryTimestamp = int.tryParse(expiryTimestampStr);
    if (expiryTimestamp == null) {
      debugPrint('Invalid expiry timestamp, considering token expired');
      return true;
    }

    final now = DateTime.now().millisecondsSinceEpoch; // ✅ keep in ms
    final isExpired = now >= expiryTimestamp;

    debugPrint(
      'Token expiry check: now=$now, expiry=$expiryTimestamp, isExpired=$isExpired',
    );
    return isExpired;
  }


  /// Save tokens and expiry time (at login)
  static Future<void> saveTokens(
      String accessToken,
      String userName,
      String email,
      String mobile,
      int id,
      String? refreshToken,
      int expiresIn,

      ) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _userName, value: userName);
    await _storage.write(key: _email, value: email);
    await _storage.write(key: _mobile, value: mobile);
    await _storage.write(key: _id, value: id.toString());
    await _storage.write(key: _refreshTokenKey, value: refreshToken ?? "");
    await _storage.write(key: _tokenExpiryKey, value: expiresIn.toString());
    debugPrint('✅ Tokens saved on login::accessToken= $accessToken,refreshToken=$refreshToken,expiryTime=$expiresIn,userId=$id');
  }

  /// Update tokens only (during refresh)
  static Future<void> updateTokens(
      String accessToken,
      String? refreshToken,
      int expiresIn,
      ) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken ?? "");
    await _storage.write(key: _tokenExpiryKey, value: expiresIn.toString());
    debugPrint('🔄 Tokens updated (refresh)');
  }

  /// Refresh token
  static Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      debugPrint('❌ No refresh token available');
      return false;
    }

    try {
      final response = await ApiClient.post(
        APIEndpointUrls.refreshtoken,
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data["accessToken"];
        final newRefreshToken = data["refreshToken"];
        final expiryTime = data["accessTokenExpiry"];

        if (newAccessToken == null || newRefreshToken == null || expiryTime == null) {
          debugPrint("❌ Missing token data in response: $data");
          return false;
        }
        await updateTokens(newAccessToken, newRefreshToken, expiryTime);
        debugPrint("✅ Token refreshed successfully");
        return true;
      } else {
        debugPrint("❌ Refresh token failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception during token refresh: $e");
      return false;
    }
  }

  /// Logout and clear data, then redirect
  static Future<void> logout() async {
    await _storage.deleteAll();
    debugPrint('Tokens cleared, user logged out');

    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/login');
    } else {
      debugPrint('⚠️ Navigator context is null, scheduling navigation...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final postContext = navigatorKey.currentContext;
        if (postContext != null) {
          postContext.go('/login');
        }
      });
    }
  }
}
