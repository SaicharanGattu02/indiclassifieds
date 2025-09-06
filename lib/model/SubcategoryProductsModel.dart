class SubcategoryProductsModel {
  bool? success;
  String? message;
  List<Products>? products;
  Settings? settings;

  SubcategoryProductsModel({
    this.success,
    this.message,
    this.products,
    this.settings,
  });

  SubcategoryProductsModel copyWith({
    bool? success,
    String? message,
    List<Products>? products,
    Settings? settings,
  }) {
    return SubcategoryProductsModel(
      success: success ?? this.success,
      message: message ?? this.message,
      products: products ?? this.products,
      settings: settings ?? this.settings,
    );
  }

  SubcategoryProductsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      products = <Products>[];
      json['data'].forEach((v) {
        products!.add(Products.fromJson(v));
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
    if (products != null) {
      data['data'] = products!.map((v) => v.toJson()).toList();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class Products {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? price;
  String? location;
  String? fullName;
  String? image;
  String? mobileNumber;
  String? status;
  bool? sold;
  bool? featured_status;
  int? stateId;
  int? cityId;
  String? createdAt;
  Category? category;
  SubCategory? subCategory;
  SubCategory? user;
  SubCategory? state;
  SubCategory? city;
  String? postedAt;
  bool? isFavorited;

  Products({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.price,
    this.location,
    this.fullName,
    this.image,
    this.mobileNumber,
    this.status,
    this.sold,
    this.featured_status,
    this.stateId,
    this.cityId,
    this.createdAt,
    this.category,
    this.subCategory,
    this.user,
    this.state,
    this.city,
    this.postedAt,
    this.isFavorited,
  });

  Products copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? price,
    String? location,
    String? fullName,
    String? image,
    String? mobileNumber,
    String? status,
    bool? sold,
    bool? featured_status,
    int? stateId,
    int? cityId,
    String? createdAt,
    Category? category,
    SubCategory? subCategory,
    SubCategory? user,
    SubCategory? state,
    SubCategory? city,
    String? postedAt,
    bool? isFavorited,
  }) {
    return Products(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      location: location ?? this.location,
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      status: status ?? this.status,
      sold: sold ?? this.sold,
      featured_status: featured_status ?? this.featured_status,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      user: user ?? this.user,
      state: state ?? this.state,
      city: city ?? this.city,
      postedAt: postedAt ?? this.postedAt,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    location = json['location'];
    fullName = json['full_name'];
    image = json['image'];
    mobileNumber = json['mobile_number'];
    status = json['status'];
    sold = json['sold'];
    featured_status = json['featured_status'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    createdAt = json['created_at'];
    category = json['Category'] != null
        ? Category.fromJson(json['Category'])
        : null;
    subCategory = json['SubCategory'] != null
        ? SubCategory.fromJson(json['SubCategory'])
        : null;
    user = json['User'] != null ? SubCategory.fromJson(json['User']) : null;
    state = json['state'] != null ? SubCategory.fromJson(json['state']) : null;
    city = json['city'] != null ? SubCategory.fromJson(json['city']) : null;
    postedAt = json['posted_at'];
    isFavorited = json['is_favorited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['location'] = location;
    data['full_name'] = fullName;
    data['image'] = image;
    data['mobile_number'] = mobileNumber;
    data['status'] = status;
    data['sold'] = sold;
    data['featured_status'] = featured_status;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['created_at'] = createdAt;
    if (category != null) data['Category'] = category!.toJson();
    if (subCategory != null) data['SubCategory'] = subCategory!.toJson();
    if (user != null) data['User'] = user!.toJson();
    if (state != null) data['state'] = state!.toJson();
    if (city != null) data['city'] = city!.toJson();
    data['posted_at'] = postedAt;
    data['is_favorited'] = isFavorited;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? path;

  Category({this.id, this.name, this.path});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['path'] = this.path;
    return data;
  }
}

class SubCategory {
  int? id;
  String? name;

  SubCategory({this.id, this.name});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
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

  Settings({
    this.status,
    this.count,
    this.page,
    this.rowsPerPage,
    this.nextPage,
    this.prevPage,
  });

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
