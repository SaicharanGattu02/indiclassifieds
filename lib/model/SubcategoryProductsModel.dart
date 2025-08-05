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

  SubcategoryProductsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      products = <Products>[];
      json['data'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.products != null) {
      data['data'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
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
  Null? fullName;
  String? mobileNumber;
  String? status;
  bool? sold;
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
    this.mobileNumber,
    this.status,
    this.sold,
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

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    location = json['location'];
    fullName = json['full_name'];
    mobileNumber = json['mobile_number'];
    status = json['status'];
    sold = json['sold'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    createdAt = json['created_at'];
    category = json['Category'] != null
        ? new Category.fromJson(json['Category'])
        : null;
    subCategory = json['SubCategory'] != null
        ? new SubCategory.fromJson(json['SubCategory'])
        : null;
    user = json['User'] != null ? new SubCategory.fromJson(json['User']) : null;
    state = json['state'] != null
        ? new SubCategory.fromJson(json['state'])
        : null;
    city = json['city'] != null ? new SubCategory.fromJson(json['city']) : null;
    postedAt = json['posted_at'];
    isFavorited = json['is_favorited'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['location'] = this.location;
    data['full_name'] = this.fullName;
    data['mobile_number'] = this.mobileNumber;
    data['status'] = this.status;
    data['sold'] = this.sold;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['created_at'] = this.createdAt;
    if (this.category != null) {
      data['Category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['SubCategory'] = this.subCategory!.toJson();
    }
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    data['posted_at'] = this.postedAt;
    data['is_favorited'] = this.isFavorited;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  Null? path;

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
