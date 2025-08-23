import 'package:bloc/bloc.dart';

import 'ChatMessagesRepository.dart';
import 'ChatMessagesStates.dart';


class ChatMessagesCubit extends Cubit<ChatMessagesStates> {
  final ChatMessagesRepository chatMessagesRepository;

  ChatMessagesCubit(this.chatMessagesRepository) : super(ChatMessagesInitial());

  /// Fetch messages for a chat
  Future<void> fetchMessages(String user_id) async {
    emit(ChatMessagesLoading());
    try {
      final messages = await chatMessagesRepository.getChatMessages(user_id);
      if(messages!=null && messages.success==true){
        emit(ChatMessagesLoaded(messages));
      }else{
        emit(ChatMessagesFailure("Chat messages Loading Failed !"));
      }
    } catch (e) {
      emit(ChatMessagesFailure(e.toString()));
    }
  }

}
