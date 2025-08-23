import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/message.dart';
import '../../../services/SocketService.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PrivateChatState {
  final List<Message> messages;
  final bool isPeerTyping;

  const PrivateChatState({this.messages = const [], this.isPeerTyping = false});

  PrivateChatState copyWith({List<Message>? messages, bool? isPeerTyping}) =>
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
    _socket = SocketService.connect("42"); // ✅ single instance
    _room = _getPrivateRoomName(currentUserId, receiverId);
    _init();
  }

  void _init() {
    // Join room (align with your server contract)
    _socket.emit('join_private', {'room': _room});

    // Inbound messages
    _socket.on('receive_private_message', _onReceiveMessage);

    // Peer typing
    _socket.on('peer_typing', _onPeerTyping);

    // Handle reconnection: re-join room and reset typing state
    _socket.on('connect', (_) {
      _socket.emit('join_private', {'room': _room});
      emit(state.copyWith(isPeerTyping: false));
    });
  }

  void _onReceiveMessage(dynamic data) {
    try {
      final message = Message.fromJson(data as Map<String, dynamic>);
      emit(state.copyWith(messages: [...state.messages, message]));
    } catch (e) {
      // Optionally log/ignore malformed payloads
    }
  }

  void _onPeerTyping(dynamic data) {
    // Expect: { room, senderId, isTyping }
    final map = (data is Map)
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};
    final senderId = map['senderId']?.toString();
    final isTyping = map['isTyping'] == true;

    // Only show typing if it's the peer and for THIS room
    final isSameRoom = map['room'] == _room;
    if (isSameRoom && senderId != null && senderId != currentUserId) {
      emit(state.copyWith(isPeerTyping: isTyping));
    }
  }

  String _getPrivateRoomName(String id1, String id2) {
    final ids = [id1, id2]..sort();
    return ids.join('_');
    // Must match server logic
  }

  void sendMessage(String message, {String type = 'text', String? imageUrl}) {
    if (message.isEmpty && imageUrl == null) return;

    final payload = {
      'senderId': currentUserId,
      'receiverId': receiverId,
      'message': message,
      'type': type,
      'image_url': imageUrl,
    };

    _socket.emit('send_private_message', payload);
  }

  /// Call on text change; debounced so we don’t spam the server.
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

    // Optional: notify server we're leaving
    // _socket.emit('leave_private', {'room': _room});

    // Remove listeners we added (prevents duplicate handlers next time)
    _socket.off('receive_private_message', _onReceiveMessage);
    _socket.off('peer_typing', _onPeerTyping);
    _socket.off(
      'connect',
    ); // we didn’t pass a handler ref, so this clears all for 'connect'

    return super.close();
  }
}
