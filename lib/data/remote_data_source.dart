import 'package:dio/dio.dart';
import 'package:indiclassifieds/model/AddToWishlistModel.dart';
import 'package:indiclassifieds/model/CategoryModel.dart';
import 'package:indiclassifieds/utils/AppLogger.dart';
import '../model/AdSuccessModel.dart';
import '../model/PackagesModel.dart';
import '../model/PlansModel.dart';
import '../model/ProductDetailsModel.dart';
import '../model/SelectCityModel.dart';
import '../model/SelectStatesModel.dart';
import '../model/SendOtpModel.dart';
import '../model/SubCategoryModel.dart';
import '../model/SubcategoryProductsModel.dart';
import '../model/VerifyOtpModel.dart';
import '../model/WishlistModel.dart';
import '../services/ApiClient.dart';
import '../services/api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<SendOtpModel?> sendMobileOTP(Map<String, dynamic> data);
  Future<VerifyOtpModel?> verifyMobileOTP(Map<String, dynamic> data);
  Future<CategoryModel?> getCategory();
  Future<SubCategoryModel?> getSubCategory(String categoryId);
  Future<SubcategoryProductsModel?> getProducts(
    String sub_category_id,
    int page,
  );
  Future<ProductDetailsModel?> getProductDetails(int id);
  Future<WishlistModel?> getWishlistProducts(int page);
  Future<AddToWishlistModel?> addToWishlist(int product_id);
  Future<SelectStatesModel?> getStates(String search);
  Future<SelectCityModel?> getCity(int state_id, String search, int page);
  Future<PlansModel?> getPlans();
  Future<PackagesModel?> getPackages(int id);
  Future<AdSuccessModel?> postCommonAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postCoWorkingAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postCityRentalsAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postCommunityAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postAstrologyAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postEducationAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postJobsAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postPetsAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postCommercialVehicleAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postBikeAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postCarsAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postPropertyAd(Map<String, dynamic> data);
  Future<AdSuccessModel?> postMobileAd(Map<String, dynamic> data);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;
      if (value is List) {
        formMap[key] = [
          for (final v in value)
            if (v is String && v.contains('/'))
              await MultipartFile.fromFile(v, filename: v.split('/').last)
            else
              v,
        ];
      } else if (value is String &&
          value.contains('/') &&
          (key.contains('images') ||
              key.contains('aadhar_card_front') ||
              key.contains('aadhar_card_back') ||
              key.contains('pan_card_front') ||
              key.contains('pan_card_back') ||
              key.contains('driving_license_front') ||
              key.contains('driving_license_back') ||
              key.contains('signature'))) {
        formMap[key] = await MultipartFile.fromFile(
          value,
          filename: value.split('/').last,
        );
      }
      // Normal fields
      else {
        formMap[key] = value;
      }
    }
    return FormData.fromMap(formMap);
  }

  @override
  Future<ProductDetailsModel?> getProductDetails(int id) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_single_listing_details}/${id}",
      );
      AppLogger.log('getProductDetails:${response.data}');
      return ProductDetailsModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getProductDetails :: $e');
      return null;
    }
  }

  @override
  Future<PackagesModel?> getPackages(int id) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_all_packages_by_plan}/${id}",
      );
      AppLogger.log('getPackages:${response.data}');
      return PackagesModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getPackages :: $e');
      return null;
    }
  }

  @override
  Future<PlansModel?> getPlans() async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_all_active_plans}",
      );
      AppLogger.log('getPlans:${response.data}');
      return PlansModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getPlans :: $e');
      return null;
    }
  }

  @override
  Future<AddToWishlistModel?> addToWishlist(int product_id) async {
    try {
      Map<String, dynamic> data = {"listingId": product_id};
      Response response = await ApiClient.post(
        "${APIEndpointUrls.like_toggle_to_product}",
        data: data,
      );
      AppLogger.log('addToWishlist:${response.data}');
      return AddToWishlistModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('addToWishlist :: $e');
      return null;
    }
  }

  @override
  Future<WishlistModel?> getWishlistProducts(int page) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_all_liked_listings}?page=${page}",
      );
      AppLogger.log('getWishlistProducts:${response.data}');
      return WishlistModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getWishlistProducts:: $e');
      return null;
    }
  }

  @override
  Future<SubcategoryProductsModel?> getProducts(
    String sub_category_id,
    int page,
  ) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_all_listings_with_pagination}?page=${page}&sub_category_id=${sub_category_id}",
      );
      AppLogger.log('getProducts:${response.data}');
      return SubcategoryProductsModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('getProducts:: $e');
      return null;
    }
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
  Future<SelectCityModel?> getCity(
    int state_id,
    String search,
    int page,
  ) async {
    try {
      Response response = await ApiClient.get(
        "${APIEndpointUrls.get_city}?state_id=${state_id}&search=${search}&page=${page}",
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

  @override
  Future<AdSuccessModel?> postMobileAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_mobile_ad}",
        data: formData,
      );
      AppLogger.log('get MobileAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get MobileAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postPropertyAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_property_ad}",
        data: formData,
      );
      AppLogger.log('get PropertyAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get PropertyAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postCarsAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_cars_ad}",
        data: formData,
      );
      AppLogger.log('get CarsAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get CarsAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postBikeAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_bikes_ad}",
        data: formData,
      );
      AppLogger.log('get BikesAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get BikesAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postCommercialVehicleAd(
    Map<String, dynamic> data,
  ) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_commercial_vehicle_ad}",
        data: formData,
      );
      AppLogger.log('get CommercialVehicleAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get CommercialVehicleAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postPetsAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_pets_ad}",
        data: formData,
      );
      AppLogger.log('get PetsAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get PetsAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postJobsAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    AppLogger.log('JobsAd :${data}');
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_jobs_ad}",
        data: formData,
      );
      AppLogger.log('get JobsAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get JobsAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postEducationAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_education_ad}",
        data: formData,
      );
      AppLogger.log('get EducationAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get EducationAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postAstrologyAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_astrology_ad}",
        data: formData,
      );
      AppLogger.log('get AstrologyAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get AstrologyAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postCommunityAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_community_ad}",
        data: formData,
      );
      AppLogger.log('get CommunityAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get CommunityAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postCityRentalsAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_city_rentals_ad}",
        data: formData,
      );
      AppLogger.log('get CityRentalsAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get CityRentalsAd :: $e');
      return null;
    }
  }

  @override
  Future<AdSuccessModel?> postCoWorkingAd(Map<String, dynamic> data) async {
    final formData = await buildFormData(data);
    try {
      Response response = await ApiClient.post(
        "${APIEndpointUrls.post_co_working_ad}",
        data: formData,
      );
      AppLogger.log('get CoWorkingAd :${response.data}');
      return AdSuccessModel.fromJson(response.data);
    } catch (e) {
      AppLogger.error('get CoWorkingAd :: $e');
      return null;
    }
  }
}
