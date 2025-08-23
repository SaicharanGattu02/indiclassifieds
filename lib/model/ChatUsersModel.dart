class ChatUsersModel {
  bool? success;
  List<Chats>? chats;

  ChatUsersModel({this.success, this.chats});

  ChatUsersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(new Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.chats != null) {
      data['chats'] = this.chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  int? userId;
  String? name;
  String? email;
  String? profileImage;
  String? lastMessageTime;

  Chats(
      {this.userId,
        this.name,
        this.email,
        this.profileImage,
        this.lastMessageTime});

  Chats.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
    lastMessageTime = json['last_message_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['last_message_time'] = this.lastMessageTime;
    return data;
  }
}
