class getListingAdModel {
  bool? success;
  String? message;
  Data? data;


  getListingAdModel({this.success, this.message, this.data});

  getListingAdModel.fromJson(Map<String, dynamic> json) {
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
  Listing? listing;

  Data({this.listing});

  Data.fromJson(Map<String, dynamic> json) {
    listing =
    json['listing'] != null ? new Listing.fromJson(json['listing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listing != null) {
      data['listing'] = this.listing!.toJson();
    }
    return data;
  }
}

class Listing {
  int? id;
  String? title;
  String? description;
  int? categoryId;
  String? price;
  String? location;
  String? fullName;
  String? mobileNumber;
  int? stateId;
  String? stateName;
  String? cityName;
  int? cityId;
  int? yearOfManufacturing;
  int? kmsRun;
  String? ownership;
  String? fuelType;
  String? createdAt;
  List<Images>? images;

  Listing(
      {this.id,
        this.title,
        this.description,
        this.categoryId,
        this.price,
        this.location,
        this.fullName,
        this.mobileNumber,
        this.stateId,
        this.stateName,
        this.cityName,
        this.cityId,
        this.yearOfManufacturing,
        this.kmsRun,
        this.ownership,
        this.fuelType,
        this.createdAt,
        this.images});

  Listing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    categoryId = json['category_id'];
    price = json['price'];
    location = json['location'];
    fullName = json['full_name'];
    mobileNumber = json['mobile_number'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    cityId = json['city_id'];
    yearOfManufacturing = json['year_of_manufacturing'];
    kmsRun = json['kms_run'];
    ownership = json['ownership'];
    fuelType = json['fuel_type'];
    createdAt = json['created_at'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['location'] = this.location;
    data['full_name'] = this.fullName;
    data['mobile_number'] = this.mobileNumber;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['year_of_manufacturing'] = this.yearOfManufacturing;
    data['kms_run'] = this.kmsRun;
    data['ownership'] = this.ownership;
    data['fuel_type'] = this.fuelType;
    data['created_at'] = this.createdAt;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}
