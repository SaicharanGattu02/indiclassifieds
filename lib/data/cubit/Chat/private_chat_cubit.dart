import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/utils/AppLogger.dart';
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
    _socket = SocketService.connect(currentUserId); // shared instance
    _room = _getPrivateRoomName(currentUserId, receiverId);
    _init();
  }

  void _init() {
    // Remove any previous handlers (important with a shared socket)
    _socket.off('receive_private_message', _onReceiveMessage);
    _socket.off('typing', _onPeerTyping);
    _socket.off('peer_typing', _onPeerTyping);
    _socket.off('connect');

    // Add listeners
    _socket.on('receive_private_message', _onReceiveMessage);
    // Some servers emit 'typing', others 'peer_typing' — listen to both
    _socket.on('typing', _onPeerTyping);

    _socket.on('connect', (_) {
      AppLogger.info('[socket] connected: ${_socket.id}');
      _joinRoom();
    });

    // 🔑 If already connected, join immediately (otherwise connect won’t fire now)
    if (_socket.connected) {
      _joinRoom();
    } else {
      AppLogger.info('[socket] not connected yet; will join on connect');
    }
  }

  void _joinRoom() {
    // Send whatever your server expects. Common patterns:
    // 1) join with a room name
    _socket.emit('join_private', {
      'room': _room,
      'userId1': currentUserId,
      'userId2': receiverId,
    });
    AppLogger.info('[socket] join_private -> room: $_room '
        '(u1=$currentUserId, u2=$receiverId)');
  }

  // Map a generic socket map to your Messages model
  Messages _mapSocketToMessages(Map<String, dynamic> map) {
    return Messages(
      id: _safeInt(map['id']),
      senderId: _safeInt(map['senderId'] ?? map['sender_id']),
      receiverId: _safeInt(map['receiverId'] ?? map['receiver_id']),
      type: map['type']?.toString(),
      message: map['message']?.toString(),
      imageUrl: (map['image_url'] ?? map['imageUrl'])?.toString(),
      createdAt: (map['createdAt'] ?? map['created_at'])?.toString() ??
          DateTime.now().toIso8601String(),
      updatedAt: (map['updatedAt'] ?? map['updated_at'])?.toString(),
    );
  }

  int? _safeInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  Map<String, dynamic> _toStringKeyMap(dynamic data) {
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    return <String, dynamic>{};
  }

  // ---- Listeners ----
  void _onReceiveMessage(dynamic data) {
    try {
      AppLogger.info('[socket] receive_private_message payload: $data');

      final map = _toStringKeyMap(data);
      final msg = _mapSocketToMessages(map);

      final exists = state.messages.any((m) {
        final mid = m.id;
        final msgid = msg.id;
        if (mid != null && msgid != null) return mid == msgid;
        final s1 = m.senderId?.toString() ?? '';
        final s2 = msg.senderId?.toString() ?? '';
        final mm1 = m.message ?? '';
        final mm2 = msg.message ?? '';
        final c1 = m.createdAt ?? '';
        final c2 = msg.createdAt ?? '';
        return s1 == s2 && mm1 == mm2 && c1 == c2;
      });

      if (!exists) {
        emit(state.copyWith(messages: [...state.messages, msg]));
      }
    } catch (e, st) {
      AppLogger.info('[socket] malformed receive_private_message: $e\n$st');
    }
  }

  void _onPeerTyping(dynamic data) {
    try {
      final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
      final senderId = map['senderId']?.toString();
      final isTyping = map['isTyping'] == true;
      final sameRoom = (map['room']?.toString() ?? '') == _room;

      if (sameRoom && senderId != null && senderId != currentUserId) {
        emit(state.copyWith(isPeerTyping: isTyping));
      }
    } catch (e) {
      // ignore
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
    final tempId = -DateTime.now().microsecondsSinceEpoch;

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
      'room': _room, // helps servers route without recomputing
      'senderId': currentUserId,
      'receiverId': receiverId,
      'message': message,
      'type': type,
      'image_url': imageUrl,
      'createdAt': nowIso,
    };

    AppLogger.info('[socket] send_private_message -> $payload');
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
    _socket.off('typing', _onPeerTyping);
    _socket.off('peer_typing', _onPeerTyping);
    _socket.off('connect');
    return super.close();
  }
}

