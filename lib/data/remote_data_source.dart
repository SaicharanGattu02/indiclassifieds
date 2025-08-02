import 'package:dio/dio.dart';
import 'package:indiclassifieds/model/CategoryModel.dart';
import 'package:indiclassifieds/utils/AppLogger.dart';
import '../model/SendOtpModel.dart';
import '../model/VerifyOtpModel.dart';
import '../services/ApiClient.dart';
import '../services/api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<SendOtpModel?> sendMobileOTP(Map<String, dynamic> data);
  Future<VerifyOtpModel?> verifyMobileOTP(Map<String, dynamic> data);
  Future<CategoryModel?> getCategory();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;
      final isFile =
          value is String &&
          value.contains('/') &&
          (key.contains('image') ||
              key.contains('aadhar_card_front') ||
              key.contains('aadhar_card_back') ||
              key.contains('pan_card_front') ||
              key.contains('pan_card_back') ||
              key.contains('driving_license_front') ||
              key.contains('driving_license_back') ||
              key.contains('signature'));
      if (isFile) {
        formMap[key] = await MultipartFile.fromFile(
          value,
          filename: value.split('/').last,
        );
      } else {
        formMap[key] = value;
      }
    }

    return FormData.fromMap(formMap);
  }

  @override
  Future<SendOtpModel?> sendMobileOTP(Map<String, dynamic> data) async {
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.send_login_otp}",
        data: data,
      );
      AppLogger.log('Send Mobile OTP :${response.data}');
      return SendOtpModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('Send Mobile OTP :: $e');
      return null;
    }
  }

  @override
  Future<VerifyOtpModel?> verifyMobileOTP(Map<String, dynamic> data) async {
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.verify_login_otp}",
        data: data,
      );
      AppLogger.log('verify Mobile OTP :${response.data}');
      return VerifyOtpModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('verify Mobile OTP :: $e');
      return null;
    }
  }

  @override
  Future<CategoryModel?> getCategory() async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_category}",
      );
      AppLogger.log('get Category :${response.data}');
      return CategoryModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get Category :: $e');
      return null;
    }
  }
}
