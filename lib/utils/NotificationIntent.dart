// notification_intent.dart
class NotificationIntent {
  static String? _pendingReceiverId;

  /// Save the chat target until UI is ready (e.g., Dashboard shown).
  static void setPendingChat(String receiverId) {
    _pendingReceiverId = receiverId;
  }

  /// Read it once and clear it.
  static String? consumePendingChat() {
    final v = _pendingReceiverId;
    _pendingReceiverId = null;
    return v;
  }

  /// Optional helper
  static bool get hasPending => _pendingReceiverId != null && _pendingReceiverId!.isNotEmpty;
}
