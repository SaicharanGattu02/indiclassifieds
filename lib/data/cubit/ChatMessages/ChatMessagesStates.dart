import 'package:equatable/equatable.dart';
import '../../../model/ChatMessagesModel.dart';

abstract class ChatMessagesStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatMessagesInitial extends ChatMessagesStates {}

class ChatMessagesLoading extends ChatMessagesStates {}

class ChatMessagesLoaded extends ChatMessagesStates {
  final ChatMessagesModel chatMessages;

  ChatMessagesLoaded(this.chatMessages);

  @override
  List<Object?> get props => [chatMessages];
}

class ChatMessagesFailure extends ChatMessagesStates {
  final String error;

  ChatMessagesFailure(this.error);

  @override
  List<Object?> get props => [error];
}
