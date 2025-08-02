class APIEndpointUrls {
  static const String baseUrl = 'http://192.168.80.107:8081/';
  static const String apiUrl = 'api/app/';



  /// Authentiocation Urls
  static const String register = '${apiUrl}Register';
  static const String refreshtoken = '${apiUrl}login';
  static const String send_login_otp = '${apiUrl}send-otp';
  static const String resend_login_otp = '${apiUrl}resend-login-otp';
  static const String verify_login_otp = '${apiUrl}verify-otp';

  /// User Urls

  static const String get_category = '${apiUrl}get-all-categories';



}
