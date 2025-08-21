class MyAdsModel {
  bool? success;
  String? message;
  List<Data>? data;
  Settings? settings;

  MyAdsModel({this.success, this.message, this.data, this.settings});

  MyAdsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? description;
  String? price;
  String? location;
  int? categoryId;
  int? subCategoryId;
  bool? featuredStatus;
  String? status;
  bool? sold;
  String? createdAt;
  State? state;
  State? city;
  Category? category;
  State? subCategory;
  String? postedAt;
  int? totalLikes;
  String? image;

  Data(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.location,
        this.categoryId,
        this.subCategoryId,
        this.featuredStatus,
        this.status,
        this.sold,
        this.createdAt,
        this.state,
        this.city,
        this.category,
        this.subCategory,
        this.postedAt,
        this.totalLikes,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    location = json['location'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    featuredStatus = json['featured_status'];
    status = json['status'];
    sold = json['sold'];
    createdAt = json['created_at'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    city = json['city'] != null ? new State.fromJson(json['city']) : null;
    category = json['Category'] != null
        ? new Category.fromJson(json['Category'])
        : null;
    subCategory = json['SubCategory'] != null
        ? new State.fromJson(json['SubCategory'])
        : null;
    postedAt = json['posted_at'];
    totalLikes = json['total_likes'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['location'] = this.location;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['featured_status'] = this.featuredStatus;
    data['status'] = this.status;
    data['sold'] = this.sold;
    data['created_at'] = this.createdAt;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.category != null) {
      data['Category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['SubCategory'] = this.subCategory!.toJson();
    }
    data['posted_at'] = this.postedAt;
    data['total_likes'] = this.totalLikes;
    data['image'] = this.image;
    return data;
  }
}

class State {
  int? id;
  String? name;

  State({this.id, this.name});

  State.fromJson(Map<String, dynamic> json) {
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
