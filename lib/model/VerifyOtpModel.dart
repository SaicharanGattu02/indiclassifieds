class VerifyOtpModel {
  bool? success;
  String? message;
  String? token;
  User? user;

  VerifyOtpModel({this.success, this.message, this.token, this.user});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['token'] = token;
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
  String? emailVerifiedAt;
  String? password;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? otp;
  String? otpCreatedAt;
  String? resetToken;
  String? resetTokenCreatedAt;
  String? role;
  String? sellerCompanyName;
  String? country;
  String? state;
  String? city;
  String? address;
  String? image;
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
    this.sellerCompanyName,
    this.country,
    this.state,
    this.city,
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
    sellerCompanyName = json['seller_company_name'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
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
    data['seller_company_name'] = sellerCompanyName;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['address'] = address;
    data['image'] = image;
    data['bio'] = bio;
    data['status'] = status;
    data['is_verified'] = isVerified;
    data['is_free_list_used'] = isFreeListUsed;
    return data;
  }
}
