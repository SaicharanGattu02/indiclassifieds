class ChatUsersModel {
  bool? success;
  List<Data>? data;
  Settings? settings;

  ChatUsersModel({this.success, this.data, this.settings});

  ChatUsersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? name;
  String? email;
  String? profileImage;
  bool? pinned;
  String? lastMessageTime;

  Data({
    this.userId,
    this.name,
    this.email,
    this.profileImage,
    this.pinned,
    this.lastMessageTime,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
    pinned = json['pinned'];
    lastMessageTime = json['last_message_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['pinned'] = this.pinned;
    data['last_message_time'] = this.lastMessageTime;
    return data;
  }
}

class Settings {
  int? count;
  int? page;
  int? rowsPerPage;
  int? totalPages;
  bool? nextPage;
  bool? prevPage;

  Settings({
    this.count,
    this.page,
    this.rowsPerPage,
    this.totalPages,
    this.nextPage,
    this.prevPage,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    page = json['page'];
    rowsPerPage = json['rows_per_page'];
    totalPages = json['total_pages'];
    nextPage = json['next_page'];
    prevPage = json['prev_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['page'] = this.page;
    data['rows_per_page'] = this.rowsPerPage;
    data['total_pages'] = this.totalPages;
    data['next_page'] = this.nextPage;
    data['prev_page'] = this.prevPage;
    return data;
  }
}
