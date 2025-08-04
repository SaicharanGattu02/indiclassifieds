import 'package:dio/dio.dart';
import 'package:indiclassifieds/model/CategoryModel.dart';
import 'package:indiclassifieds/utils/AppLogger.dart';
import '../model/AdSuccessModel.dart';
import '../model/SelectCityModel.dart';
import '../model/SelectStatesModel.dart';
import '../model/SendOtpModel.dart';
import '../model/SubCategoryModel.dart';
import '../model/VerifyOtpModel.dart';
import '../services/ApiClient.dart';
import '../services/api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<SendOtpModel?> sendMobileOTP(Map<String, dynamic> data);
  Future<VerifyOtpModel?> verifyMobileOTP(Map<String, dynamic> data);
  Future<CategoryModel?> getCategory();
  Future<SubCategoryModel?> getSubCategory(String categoryId);
  Future<SelectStatesModel?> getStates(String search);
  Future<SelectCityModel?> getCity(int state_id, String search);
  Future<AdSuccessModel?> postCommonAd(Map<String, dynamic> data);
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

  @override
  Future<SubCategoryModel?> getSubCategory(String categoryId) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_sub_category}/${categoryId}",
      );
      AppLogger.log('get Sub Category :${response.data}');
      return SubCategoryModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get Sub Category :: $e');
      return null;
    }
  }

  @override
  Future<SelectStatesModel?> getStates(String search) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_states}?search=${search}",
      );
      AppLogger.log('get States :${response.data}');
      return SelectStatesModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get States:: $e');
      return null;
    }
  }

  @override
  Future<SelectCityModel?> getCity(int state_id, String search) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_states}?state_id=${state_id}&search=${search}",
      );
      AppLogger.log('get City :${response.data}');
      return SelectCityModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get City :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postCommonAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_common_ad}",
        data: formData,
      );
      AppLogger.log('get CommonAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get CommonAd :: $e');
      return null;
    }
  }
}
