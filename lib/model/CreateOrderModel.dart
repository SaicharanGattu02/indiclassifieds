class CreateOrderModel {
  bool? success;
  String? message;
  String? orderId;
  int? amount;
  String? currency;

  CreateOrderModel({
    this.success,
    this.message,
    this.orderId,
    this.amount,
    this.currency,
  });

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    orderId = json['orderId'];
    amount = json['amount'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    return data;
  }
}
