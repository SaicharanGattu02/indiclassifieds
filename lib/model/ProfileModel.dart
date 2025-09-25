class ProfileModel {
  bool? success;
  String? message;
  Data? data;

  ProfileModel({this.success, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? image;
  String? city_name;
  String? state_name;
  int? state_id;
  int? city_id;
  int? email_verified;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.image,
    this.city_id,
    this.email_verified,
    this.city_name,
    this.state_id,
    this.state_name,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    city_id = json['city_id'];
    city_name = json['city_name'];
    state_name = json['state_name'];
    state_id = json['state_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    email_verified = json['email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    data['state_id'] = this.state_id;
    data['state_name'] = this.state_name;
    data['city_name'] = this.city_name;
    data['city_id'] = this.city_id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email_verified'] = this.email_verified;
    return data;
  }
}
