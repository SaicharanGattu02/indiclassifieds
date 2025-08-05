class PackagesModel {
  bool? success;
  String? message;
  List<Plans>? plans;
  List<Packages>? packages;

  PackagesModel({this.success, this.message, this.plans, this.packages});

  PackagesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
    if (json['data'] != null) {
      packages = <Packages>[];
      json['data'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    if (this.packages != null) {
      data['data'] = this.packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plans {
  String? name;
  int? durationDays;

  Plans({this.name, this.durationDays});

  Plans.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    durationDays = json['duration_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['duration_days'] = this.durationDays;
    return data;
  }
}

class Packages {
  int? id;
  int? planId;
  String? name;
  int? listingsCount;
  int? adsCount;
  int? pinnedCount;
  int? spotlightCount;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;

  Packages({
    this.id,
    this.planId,
    this.name,
    this.listingsCount,
    this.adsCount,
    this.pinnedCount,
    this.spotlightCount,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planId = json['plan_id'];
    name = json['name'];
    listingsCount = json['listings_count'];
    adsCount = json['ads_count'];
    pinnedCount = json['pinned_count'];
    spotlightCount = json['spotlight_count'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan_id'] = this.planId;
    data['name'] = this.name;
    data['listings_count'] = this.listingsCount;
    data['ads_count'] = this.adsCount;
    data['pinned_count'] = this.pinnedCount;
    data['spotlight_count'] = this.spotlightCount;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
