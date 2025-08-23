import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:indiclassifieds/presentation/views/ChatScreen.dart';
import '../../../model/ChatMessagesModel.dart';
import 'ChatMessagesRepository.dart';
import 'ChatMessagesStates.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesStates> {
  final ChatMessagesRepository chatMessagesRepository;

  ChatMessagesCubit(this.chatMessagesRepository) : super(ChatMessagesInitial());

  ChatMessagesModel chatMessagesModel = ChatMessagesModel();
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  // Fetch initial chat messages
  Future<void> fetchMessages(String userId) async {
    emit(ChatMessagesLoading());
    _currentPage = 1;
    try {
      final response = await chatMessagesRepository.getChatMessages(userId, _currentPage);
      if (response != null && response.success == true) {
        chatMessagesModel = response;
        _hasNextPage = response.settings?.nextPage ?? false;
        debugPrint('fetchMessages: Page $_currentPage, hasNextPage=$_hasNextPage, messages=${response.data?.messages?.length}');
        emit(ChatMessagesLoaded(chatMessagesModel, _hasNextPage));
      } else {
        emit(ChatMessagesFailure(response?.message ?? "Failed to load chat messages"));
      }
    } catch (e) {
      debugPrint('fetchMessages error: $e');
      emit(ChatMessagesFailure(e.toString()));
    }
  }

  // Fetch more chat messages (pagination)
  Future<void> getMoreMessages(String userId) async {
    if (_isLoadingMore || !_hasNextPage) {
      debugPrint('getMoreMessages skipped: _isLoadingMore=$_isLoadingMore, _hasNextPage=$_hasNextPage');
      return;
    }

    _isLoadingMore = true;
    _currentPage++;
    debugPrint('getMoreMessages: Fetching page $_currentPage');
    emit(ChatMessagesLoadingMore(chatMessagesModel, _hasNextPage));

    try {
      final newData = await chatMessagesRepository.getChatMessages(userId, _currentPage);
      if (newData != null && newData.data?.messages?.isNotEmpty == true) {
        final existingMessages = chatMessagesModel.data?.messages ?? [];
        final newMessages = newData.data!.messages!;
        // Prepend new messages (older messages) to the start of the list
        final combinedData = [...newMessages, ...existingMessages]
          ..sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

        chatMessagesModel = ChatMessagesModel(
          success: newData.success,
          message: newData.message,
          data: Data(
            friend: newData.data?.friend,
            messages: combinedData,
          ),
          settings: newData.settings,
        );

        _hasNextPage = newData.settings?.nextPage ?? false;
        debugPrint('getMoreMessages: Page $_currentPage loaded, hasNextPage=$_hasNextPage, new messages=${newMessages.length}');
        emit(ChatMessagesLoaded(chatMessagesModel, _hasNextPage));
      } else {
        _hasNextPage = false;
        debugPrint('getMoreMessages: No more messages, hasNextPage=$_hasNextPage');
        emit(ChatMessagesLoaded(chatMessagesModel, _hasNextPage));
      }
    } catch (e) {
      debugPrint('getMoreMessages error: $e');
      emit(ChatMessagesFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}
