class ProductDetailsModel {
  bool? success;
  Data? data;

  ProductDetailsModel({this.success, this.data});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Listing? listing;
  List<Images>? images;
  Details? details;
  PostedBy? postedBy;

  Data({this.listing, this.images, this.details, this.postedBy});

  Data.fromJson(Map<String, dynamic> json) {
    listing = json['listing'] != null
        ? new Listing.fromJson(json['listing'])
        : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    details = json['details'] != null
        ? new Details.fromJson(json['details'])
        : null;
    postedBy = json['posted_by'] != null
        ? new PostedBy.fromJson(json['posted_by'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listing != null) {
      data['listing'] = this.listing!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    if (this.postedBy != null) {
      data['posted_by'] = this.postedBy!.toJson();
    }
    return data;
  }
}

class Listing {
  int? id;
  int? userId;
  int? planId;
  int? packageId;
  String? title;
  String? description;
  int? subCategoryId;
  int? categoryId;
  String? price;
  String? location;
  String? fullName;
  String? mobileNumber;
  bool? featuredStatus;
  String? status;
  String? city_name;
  String? state_name;
  bool? sold;
  int? stateId;
  int? cityId;
  String? createdAt;
  String? updatedAt;
  Category? category;

  Listing({
    this.id,
    this.userId,
    this.planId,
    this.packageId,
    this.title,
    this.description,
    this.subCategoryId,
    this.categoryId,
    this.price,
    this.location,
    this.fullName,
    this.mobileNumber,
    this.featuredStatus,
    this.status,
    this.sold,
    this.stateId,
    this.cityId,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.city_name,
    this.state_name,
  });

  Listing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    planId = json['plan_id'];
    packageId = json['package_id'];
    title = json['title'];
    description = json['description'];
    subCategoryId = json['sub_category_id'];
    categoryId = json['category_id'];
    price = json['price'];
    location = json['location'];
    fullName = json['full_name'];
    mobileNumber = json['mobile_number'];
    featuredStatus = json['featured_status'];
    status = json['status'];
    sold = json['sold'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    city_name = json['city_name'];
    state_name = json['state_name'];
    category = json['Category'] != null
        ? new Category.fromJson(json['Category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['plan_id'] = this.planId;
    data['package_id'] = this.packageId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['sub_category_id'] = this.subCategoryId;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['location'] = this.location;
    data['full_name'] = this.fullName;
    data['mobile_number'] = this.mobileNumber;
    data['featured_status'] = this.featuredStatus;
    data['status'] = this.status;
    data['sold'] = this.sold;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['city_name'] = this.city_name;
    data['state_name'] = this.state_name;
    if (this.category != null) {
      data['Category'] = this.category!.toJson();
    }
    return data;
  }
}

class Category {
  String? path;

  Category({this.path});

  Category.fromJson(Map<String, dynamic> json) {
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
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

class Details {
  int? id;
  int? listingId;

  // Old fixed fields (keep for mobiles/back-compat)
  String? brand;
  String? ram;
  String? storage;
  String? mobileNumber;

  String? createdAt;

  /// NEW: holds dynamic keys for any category (real estate, vehicles, etc.)
  Map<String, dynamic> extra = {};

  Details({
    this.id,
    this.listingId,
    this.brand,
    this.ram,
    this.storage,
    this.mobileNumber,
    this.createdAt,
    Map<String, dynamic>? extra,
  }) : extra = extra ?? {};

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    listingId = json['listing_id'];

    // known (mobile) fields
    brand = json['brand'];
    ram = json['ram'];
    storage = json['storage'];
    mobileNumber = json['mobile_number'];

    createdAt = json['created_at'];

    // capture everything else
    final skip = {'id', 'listing_id', 'created_at'};
    extra = {};
    json.forEach((k, v) {
      if (!skip.contains(k) &&
          k != 'brand' &&
          k != 'ram' &&
          k != 'storage' &&
          k != 'mobile_number') {
        extra[k] = v;
      }
    });
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'listing_id': listingId,
      'brand': brand,
      'ram': ram,
      'storage': storage,
      'mobile_number': mobileNumber,
      'created_at': createdAt,
      // merge dynamic keys back
      ...extra,
    };
    return data;
  }

  /// Convenience: a single merged map you can render directly
  Map<String, dynamic> merged() => {
    'brand': brand,
    'ram': ram,
    'storage': storage,
    'mobile_number': mobileNumber,
    ...extra,
  }..removeWhere((k, v) => v == null || v.toString().trim().isEmpty);
}

class PostedBy {
  int? id;
  String? name;
  String? email;
  String? image;
  String? postedAt;

  PostedBy({this.id, this.name, this.email, this.image, this.postedAt});

  PostedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    postedAt = json['posted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    data['posted_at'] = this.postedAt;
    return data;
  }
}
