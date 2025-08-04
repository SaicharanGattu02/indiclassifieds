class SubCategoryModel {
  bool? success;
  List<Data>? data;
  String? message;

  SubCategoryModel({this.success, this.data, this.message});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
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
  int? subCategoryId;
  String? name;
  String? image;
  int? noOfCounts;

  Data({this.subCategoryId, this.name, this.image, this.noOfCounts});

  Data.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['sub_category_id'];
    name = json['name'];
    image = json['image'];
    noOfCounts = json['no_of_counts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_category_id'] = this.subCategoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['no_of_counts'] = this.noOfCounts;
    return data;
  }
}
