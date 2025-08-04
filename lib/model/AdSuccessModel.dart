class AdSuccessModel {
  bool? success;
  String? message;
  int? listingId;

  AdSuccessModel({this.success, this.message, this.listingId});

  AdSuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    listingId = json['listing_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['listing_id'] = this.listingId;
    return data;
  }
}
