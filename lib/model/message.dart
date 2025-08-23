// lib/models/message.dart
import 'package:intl/intl.dart';

class Message {
  /// Use String for id to handle both numeric and uuid-like ids safely.
  final String id;
  final String senderId;
  final String receiverId;

  /// 'text' | 'image' | others your backend may support
  final String type;

  /// For non-text types (e.g., 'image'), this can be empty.
  final String message;

  /// Normalized from either 'image_url' or 'imageUrl'
  final String? imageUrl;

  /// Normalized from 'created_at' | 'createdAt' | 'timestamp' (secs/ms) | Date string
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.message = '',
    this.imageUrl,
    required this.createdAt,
  });

  /// Robust JSON factory:
  /// - Accepts id as int/string and normalizes to String
  /// - Accepts created_at / createdAt / timestamp (seconds or ms) or ISO string
  /// - Accepts image_url / imageUrl
  factory Message.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? '').toString();

    // Resolve sender/receiver to strings
    final senderId = (json['senderId'] ?? json['sender_id'] ?? '').toString();
    final receiverId = (json['receiverId'] ?? json['receiver_id'] ?? '').toString();

    // Type/message
    final type = (json['type'] ?? '').toString();
    final message = (json['message'] ?? '').toString();

    // Image URL (support both keys)
    final imageUrl = (json['image_url'] ?? json['imageUrl'])?.toString();

    // CreatedAt: support multiple shapes
    final createdAt = _parseCreatedAt(json);

    return Message(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      type: type,
      message: message,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'type': type,
    'message': message,
    'image_url': imageUrl,
    'created_at': createdAt.toIso8601String(),
  };

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? type,
    String? message,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get formattedTime => DateFormat('HH:mm').format(createdAt);

  /// ---- Helpers ----
  static DateTime _parseCreatedAt(Map<String, dynamic> json) {
    final dynamic raw =
        json['created_at'] ?? json['createdAt'] ?? json['timestamp'];

    if (raw == null) return DateTime.now();

    // Numeric timestamp: seconds or milliseconds
    if (raw is num) {
      final intVal = raw.toInt();
      // Heuristic: > 10^12 → ms; else seconds
      if (intVal > 1000000000000) {
        return DateTime.fromMillisecondsSinceEpoch(intVal, isUtc: false);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(intVal * 1000, isUtc: false);
      }
    }

    // String: try ISO 8601 parse
    if (raw is String) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) return parsed;
    }

    return DateTime.now();
  }
}
