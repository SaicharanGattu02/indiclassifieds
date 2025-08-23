import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../model/ChatMessagesModel.dart';
import '../../../services/SocketService.dart';

class PrivateChatState {
  final List<Messages> messages;
  final bool isPeerTyping;

  const PrivateChatState({this.messages = const [], this.isPeerTyping = false});

  PrivateChatState copyWith({List<Messages>? messages, bool? isPeerTyping}) =>
      PrivateChatState(
        messages: messages ?? this.messages,
        isPeerTyping: isPeerTyping ?? this.isPeerTyping,
      );
}

class PrivateChatCubit extends Cubit<PrivateChatState> {
  final String currentUserId;
  final String receiverId;

  late final IO.Socket _socket;
  late final String _room;
  Timer? _typingDebounce;

  PrivateChatCubit(this.currentUserId, this.receiverId)
    : super(const PrivateChatState()) {
    _socket = SocketService.connect(currentUserId); // your single instance
    _room = _getPrivateRoomName(currentUserId, receiverId);
    _init();
  }

  void _init() {
    // ✅ JOIN using ids (server expects { userId1, userId2 })
    // _socket.emit('join_private', {
    //   'userId1': currentUserId,
    //   'userId2': receiverId,
    // });

    _socket.on('receive_private_message', _onReceiveMessage);

    _socket.on('connect', (_) {
      // Re-join on reconnect
      _socket.emit('join_private', {
        'userId1': currentUserId,
        'userId2': receiverId,
      });
      // emit(state.copyWith(isPeerTyping: false));
    });
  }

  // Map a generic socket map to your Messages model
  Messages _mapSocketToMessages(Map<String, dynamic> map) {
    return Messages(
      id: _safeInt(map['id']), // might be null on some servers
      senderId: _safeInt(map['senderId'] ?? map['sender_id']),
      receiverId: _safeInt(map['receiverId'] ?? map['receiver_id']),
      type: map['type']?.toString(),
      message: map['message']?.toString(),
      imageUrl: (map['image_url'] ?? map['imageUrl'])?.toString(),
      createdAt:
          (map['createdAt'] ?? map['created_at'])?.toString() ??
          DateTime.now().toIso8601String(),
      updatedAt: (map['updatedAt'] ?? map['updated_at'])?.toString(),
    );
  }

  int? _safeInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    final s = v.toString();
    return int.tryParse(s);
  }

  void _onReceiveMessage(dynamic data) {
    try {
      final map = (data is Map)
          ? Map<String, dynamic>.from(data)
          : <String, dynamic>{};
      final msg = _mapSocketToMessages(map);

      // de-dup by id if present; if not, fallback to timestamp+sender+text
      final exists = state.messages.any((m) {
        if (m.id != null && msg.id != null) return m.id == msg.id;
        return m.senderId == msg.senderId &&
            m.message == msg.message &&
            m.createdAt == msg.createdAt;
      });

      if (!exists) {
        emit(state.copyWith(messages: [...state.messages, msg]));
      }
    } catch (_) {
      // ignore malformed socket payloads
    }
  }

  void _onPeerTyping(dynamic data) {
    final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
    final senderId = map['senderId']?.toString();
    final isTyping = map['isTyping'] == true;
    final isSameRoom = map['room'] == _room;
    if (isSameRoom && senderId != null && senderId != currentUserId) {
      emit(state.copyWith(isPeerTyping: isTyping));
    }
  }

  String _getPrivateRoomName(String id1, String id2) {
    final ids = [id1, id2]..sort();
    return ids.join('_'); // must match server
  }

  /// Optimistic send (text or image)
  void sendMessage(String message, {String type = 'text', String? imageUrl}) {
    if (message.isEmpty && imageUrl == null) return;

    final nowIso = DateTime.now().toIso8601String();
    final tempId = -DateTime.now().microsecondsSinceEpoch; // negative temp id

    final local = Messages(
      id: tempId,
      senderId: int.tryParse(currentUserId),
      receiverId: int.tryParse(receiverId),
      type: type,
      message: message,
      imageUrl: imageUrl,
      createdAt: nowIso,
      updatedAt: nowIso,
    );

    emit(state.copyWith(messages: [...state.messages, local]));

    final payload = {
      'senderId': currentUserId,
      'receiverId': receiverId,
      'message': message,
      'type': type,
      'image_url': imageUrl,
      'createdAt': nowIso,
    };

    _socket.emit('send_private_message', payload);
  }

  void startTyping() {
    _sendTyping(true);
    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(seconds: 2), () {
      _sendTyping(false);
    });
  }

  void stopTyping() {
    _typingDebounce?.cancel();
    _sendTyping(false);
  }

  void _sendTyping(bool isTyping) {
    _socket.emit('typing', {
      'room': _room,
      'senderId': currentUserId,
      'isTyping': isTyping,
    });
  }

  @override
  Future<void> close() {
    _typingDebounce?.cancel();
    _socket.off('receive_private_message', _onReceiveMessage);
    _socket.off('peer_typing', _onPeerTyping);
    _socket.off('connect');
    return super.close();
  }
}
