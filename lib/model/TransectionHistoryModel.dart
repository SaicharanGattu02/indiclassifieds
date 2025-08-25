class TransectionHistoryModel {
  bool? success;
  String? message;
  Data? data;
  Settings? settings;

  TransectionHistoryModel(
      {this.success, this.message, this.data, this.settings});

  TransectionHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalPayments;
  int? totalSuccess;
  List<FormattedRows>? formattedRows;

  Data({this.totalPayments, this.totalSuccess, this.formattedRows});

  Data.fromJson(Map<String, dynamic> json) {
    totalPayments = json['total_payments'];
    totalSuccess = json['total_success'];
    if (json['formattedRows'] != null) {
      formattedRows = <FormattedRows>[];
      json['formattedRows'].forEach((v) {
        formattedRows!.add(new FormattedRows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_payments'] = this.totalPayments;
    data['total_success'] = this.totalSuccess;
    if (this.formattedRows != null) {
      data['formattedRows'] =
          this.formattedRows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FormattedRows {
  int? id;
  String? planName;
  Null? packageName;
  String? paymentStatus;
  int? amountPaid;
  String? paidOn;
  String? startDate;
  String? endDate;

  FormattedRows(
      {this.id,
        this.planName,
        this.packageName,
        this.paymentStatus,
        this.amountPaid,
        this.paidOn,
        this.startDate,
        this.endDate});

  FormattedRows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
    packageName = json['package_name'];
    paymentStatus = json['payment_status'];
    amountPaid = json['amount_paid'];
    paidOn = json['paid_on'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan_name'] = this.planName;
    data['package_name'] = this.packageName;
    data['payment_status'] = this.paymentStatus;
    data['amount_paid'] = this.amountPaid;
    data['paid_on'] = this.paidOn;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
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
