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
  static const String post_mobile_ad = '${apiUrl}add-mobile-to-listings';
  static const String post_property_ad = '${apiUrl}add-property-to-listings';
  static const String post_cars_ad = '${apiUrl}add-car-to-listings';
  static const String post_bikes_ad = '${apiUrl}add-bike-to-listings';
  static const String post_commercial_vehicle_ad = '${apiUrl}add-commercial-vehicle-to-listings';
  static const String post_pets_ad = '${apiUrl}add-pets-to-listings';
  static const String post_jobs_ad = '${apiUrl}add-jobs-to-listings';
  static const String post_education_ad = '${apiUrl}add-education-to-listings';
  static const String post_astrology_ad = '${apiUrl}add-astrology-to-listings';
  static const String post_community_ad = '${apiUrl}add-community-to-listings';
  static const String post_city_rentals_ad = '${apiUrl}add-city-rentals-to-listings';
  static const String post_co_working_ad = '${apiUrl}add-co-working-to-listings';



}
