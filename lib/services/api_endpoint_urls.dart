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

  /// get Apis
  static const String get_category = '${apiUrl}get-all-categories';
  static const String get_sub_category = '${apiUrl}get-all-sub-categories';
  static const String get_states = '${apiUrl}get-all-states';
  static const String get_city = '${apiUrl}get-all-cities';

  /// post apis
  static const String post_common_ad = '${apiUrl}add-common-list-to-listings';



}
