import 'package:bloc/bloc.dart';
import 'ChatUsersRepo.dart';
import 'ChatUsersStates.dart';

class ChatUsersCubit extends Cubit<ChatUsersStates> {
  final ChatUsersRepo chatUsersRepo;

  ChatUsersCubit(this.chatUsersRepo) : super(ChatUsersInitially());

  Future<void> fetchChatUsers(String query) async {
    try {
      emit(ChatUsersLoading());
      final chatUsers = await chatUsersRepo.getChatUsers(query);
      if (chatUsers != null && chatUsers.success == true) {
        emit(ChatUsersLoaded(chatUsers));
      } else {
        emit(ChatUsersFailure("Chat Users fetching failed"));
      }
    } catch (e) {
      emit(ChatUsersFailure(e.toString()));
    }
  }
}
