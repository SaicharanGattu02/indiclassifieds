class ChatMessagesModel {
  bool? success;
  List<Messages>? messages;

  ChatMessagesModel({this.success, this.messages});

  ChatMessagesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? id;
  int? senderId;
  int? receiverId;
  String? type;
  String? message;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  Messages(
      {this.id,
        this.senderId,
        this.receiverId,
        this.type,
        this.message,
        this.imageUrl,
        this.createdAt,
        this.updatedAt});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    type = json['type'];
    message = json['message'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['type'] = this.type;
    data['message'] = this.message;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
