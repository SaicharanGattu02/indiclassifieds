class CategoryModel {
  bool? success;
  List<Data>? data;
  String? message;

  CategoryModel({this.success, this.data, this.message});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? categoryId;
  String? name;
  String? image;
  String? noOfCounts;

  Data({this.categoryId, this.name, this.image, this.noOfCounts});

  Data.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    image = json['image'];
    noOfCounts = json['no_of_counts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['no_of_counts'] = this.noOfCounts;
    return data;
  }
}
