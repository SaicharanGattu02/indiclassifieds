import 'dart:convert';

class VerifyOtpModel {
  bool? success;
  String? message;
  String? accessToken;
  String? refreshToken;
  int? refreshTokenExpiry;
  int? accessTokenExpiry;
  bool? newUser;
  User? user;

  VerifyOtpModel({
    this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.refreshTokenExpiry,
    this.accessTokenExpiry,
    this.newUser,
    this.user,
  });

  /// Factory method to handle both String and Map inputs
  factory VerifyOtpModel.fromResponse(dynamic data) {
    if (data is String) {
      return VerifyOtpModel.fromJson(jsonDecode(data));
    } else if (data is Map<String, dynamic>) {
      return VerifyOtpModel.fromJson(data);
    } else {
      throw Exception("❌ Invalid response type: ${data.runtimeType}");
    }
  }

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    accessTokenExpiry = json['accessTokenExpiry'];
    refreshTokenExpiry = json['refreshTokenExpiry'];
    newUser = json['new_user'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['accessTokenExpiry'] = accessTokenExpiry;
    data['refreshTokenExpiry'] = refreshTokenExpiry;
    data['new_user'] = newUser;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? mobile;
  dynamic emailVerifiedAt;
  dynamic password;
  dynamic rememberToken;
  String? createdAt;
  String? updatedAt;
  dynamic otp;
  dynamic otpCreatedAt;
  dynamic resetToken;
  dynamic resetTokenCreatedAt;
  String? role;
  String? country;
  String? state;
  String? city;
  int? stateId;
  int? cityId;
  dynamic address;
  dynamic image;
  String? bio;
  String? status;
  int? isVerified;
  int? isFreeListUsed;

  User({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.emailVerifiedAt,
    this.password,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.otp,
    this.otpCreatedAt,
    this.resetToken,
    this.resetTokenCreatedAt,
    this.role,
    this.country,
    this.stateId,
    this.state,
    this.city,
    this.cityId,
    this.address,
    this.image,
    this.bio,
    this.status,
    this.isVerified,
    this.isFreeListUsed,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otp = json['otp'];
    otpCreatedAt = json['otp_created_at'];
    resetToken = json['reset_token'];
    resetTokenCreatedAt = json['reset_token_created_at'];
    role = json['role'];
    country = json['country'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    address = json['address'];
    state = json['state_name'];
    city = json['city_name'];
    image = json['image'];
    bio = json['bio'];
    status = json['status'];
    isVerified = json['is_verified'];
    isFreeListUsed = json['is_free_list_used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['email_verified_at'] = emailVerifiedAt;
    data['password'] = password;
    data['remember_token'] = rememberToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['otp'] = otp;
    data['otp_created_at'] = otpCreatedAt;
    data['reset_token'] = resetToken;
    data['reset_token_created_at'] = resetTokenCreatedAt;
    data['role'] = role;
    data['country'] = country;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['state_name'] = state;
    data['city_name'] = city;
    data['address'] = address;
    data['image'] = image;
    data['bio'] = bio;
    data['status'] = status;
    data['is_verified'] = isVerified;
    data['is_free_list_used'] = isFreeListUsed;
    return data;
  }
}
