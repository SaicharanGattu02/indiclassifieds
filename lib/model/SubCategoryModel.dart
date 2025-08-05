class SubCategoryModel {
  bool? success;
  List<SubCategories>? subcategories;
  String? message;

  SubCategoryModel({this.success, this.subcategories, this.message});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      subcategories = <SubCategories>[];
      json['data'].forEach((v) {
        subcategories!.add(new SubCategories.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.subcategories != null) {
      data['data'] = this.subcategories!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class SubCategories {
  int? subCategoryId;
  String? name;
  String? image;
  int? noOfCounts;

  SubCategories({this.subCategoryId, this.name, this.image, this.noOfCounts});

  SubCategories.fromJson(Map<String, dynamic> json) {
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
