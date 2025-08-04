class SelectCityModel {
  bool? success;
  List<Data>? data;

  SelectCityModel({this.success, this.data});

  SelectCityModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? cityId;
  String? name;

  Data({this.cityId, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['name'] = this.name;
    return data;
  }
}
