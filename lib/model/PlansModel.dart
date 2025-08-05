class PlansModel {
  bool? success;
  List<Plans>? plans;

  PlansModel({this.success, this.plans});

  PlansModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      plans = <Plans>[];
      json['data'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.plans != null) {
      data['data'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plans {
  int? id;
  String? name;
  int? durationDays;
  String? image;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? status;
  Features? features;
  int? startingPriceFrom;

  Plans(
      {this.id,
        this.name,
        this.durationDays,
        this.image,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.features,
        this.startingPriceFrom});

  Plans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    durationDays = json['duration_days'];
    image = json['image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    features = json['features'] != null
        ? new Features.fromJson(json['features'])
        : null;
    startingPriceFrom = json['starting_price_from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration_days'] = this.durationDays;
    data['image'] = this.image;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    if (this.features != null) {
      data['features'] = this.features!.toJson();
    }
    data['starting_price_from'] = this.startingPriceFrom;
    return data;
  }
}

class Features {
  String? type;

  Features({this.type});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    return data;
  }
}
