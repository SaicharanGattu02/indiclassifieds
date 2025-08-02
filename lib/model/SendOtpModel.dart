class SendOtpModel {
  bool? success;
  String? message;
  int? otp;

  SendOtpModel({this.success, this.message, this.otp});

  SendOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['otp'] = this.otp;
    return data;
  }
}
