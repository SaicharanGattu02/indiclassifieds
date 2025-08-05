class WishlistModel {
  bool? success;
  String? message;
  List<ProductsList>? productslist;
  Settings? settings;

  WishlistModel({this.success, this.message, this.productslist, this.settings});

  WishlistModel copyWith({
    bool? success,
    String? message,
    List<ProductsList>? productslist,
    Settings? settings,
  }) {
    return WishlistModel(
      success: success ?? this.success,
      message: message ?? this.message,
      productslist: productslist ?? this.productslist,
      settings: settings ?? this.settings,
    );
  }

  WishlistModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      productslist = <ProductsList>[];
      json['data'].forEach((v) {
        productslist!.add(ProductsList.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (productslist != null) {
      data['data'] = productslist!.map((v) => v.toJson()).toList();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class ProductsList {
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
  String? image;
  String? mobileNumber;
  int? featuredStatus;
  String? status;
  int? sold;
  int? stateId;
  int? cityId;
  String? createdAt;
  String? updatedAt;
  Category? category;
  bool? isFavorited;

  ProductsList({
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
    this.image,
    this.mobileNumber,
    this.featuredStatus,
    this.status,
    this.sold,
    this.stateId,
    this.cityId,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.isFavorited,
  });

  ProductsList copyWith({
    int? id,
    int? userId,
    int? planId,
    int? packageId,
    String? title,
    String? description,
    int? subCategoryId,
    int? categoryId,
    String? price,
    String? location,
    String? fullName,
    String? image,
    String? mobileNumber,
    int? featuredStatus,
    String? status,
    int? sold,
    int? stateId,
    int? cityId,
    String? createdAt,
    String? updatedAt,
    Category? category,
    bool? isFavorited,
  }) {
    return ProductsList(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      packageId: packageId ?? this.packageId,
      title: title ?? this.title,
      description: description ?? this.description,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      location: location ?? this.location,
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      featuredStatus: featuredStatus ?? this.featuredStatus,
      status: status ?? this.status,
      sold: sold ?? this.sold,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  ProductsList.fromJson(Map<String, dynamic> json) {
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
    image = json['image'];
    mobileNumber = json['mobile_number'];
    featuredStatus = json['featured_status'];
    status = json['status'];
    sold = json['sold'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category =
    json['Category'] != null ? Category.fromJson(json['Category']) : null;
    isFavorited = json['is_favorited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    data['plan_id'] = planId;
    data['package_id'] = packageId;
    data['title'] = title;
    data['description'] = description;
    data['sub_category_id'] = subCategoryId;
    data['category_id'] = categoryId;
    data['price'] = price;
    data['location'] = location;
    data['full_name'] = fullName;
    data['image'] = image;
    data['mobile_number'] = mobileNumber;
    data['featured_status'] = featuredStatus;
    data['status'] = status;
    data['sold'] = sold;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (category != null) {
      data['Category'] = category!.toJson();
    }
    data['is_favorited'] = isFavorited;
    return data;
  }
}


class Category {
  int? id;
  String? name;
  String? image;
  String? path;

  Category({this.id, this.name, this.image, this.path});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['path'] = this.path;
    return data;
  }
}

class Settings {
  int? status;
  int? count;
  int? page;
  int? rowsPerPage;
  bool? nextPage;
  bool? prevPage;

  Settings(
      {this.status,
        this.count,
        this.page,
        this.rowsPerPage,
        this.nextPage,
        this.prevPage});

  Settings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    page = json['page'];
    rowsPerPage = json['rows_per_page'];
    nextPage = json['next_page'];
    prevPage = json['prev_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    data['page'] = this.page;
    data['rows_per_page'] = this.rowsPerPage;
    data['next_page'] = this.nextPage;
    data['prev_page'] = this.prevPage;
    return data;
  }
}
