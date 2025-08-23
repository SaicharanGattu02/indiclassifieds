import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:indiclassifieds/data/cubit/ChatMessages/ChatMessagesCubit.dart';
import 'package:intl/intl.dart';
import '../../data/cubit/Chat/private_chat_cubit.dart';
import '../../data/cubit/ChatMessages/ChatMessagesStates.dart';
import '../../model/ChatMessagesModel.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

extension ChatScreenMessagesX on Messages {
  DateTime get createdAtDate {
    final raw = createdAt?.toString() ?? '';
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  String get formattedTime {
    return DateFormat('hh:mm a').format(createdAtDate);
  }

  bool get isImage => (type ?? '') == 'image';
  bool get isText => (type ?? '') == 'text';
}


class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;

  @override
  void initState() {
    super.initState();
    try {
      context.read<ChatMessagesCubit>().fetchMessages(widget.receiverId);
      debugPrint('ChatMessagesCubit accessed successfully in initState');
    } catch (e) {
      debugPrint('Error accessing ChatMessagesCubit in initState: $e');
    }

    // Detect when the user scrolls near the top to load more messages
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
              _scrollController.position.minScrollExtent + 100 &&
          !_isLoadingMore &&
          _hasMoreMessages) {
        debugPrint('Triggering getMoreMessages');
        setState(() {
          _isLoadingMore = true;
        });
        context.read<ChatMessagesCubit>().getMoreMessages(widget.receiverId);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Color _meBubble(BuildContext context) {
    final dark = ThemeHelper.isDarkMode(context);
    return dark ? const Color(0xFF234476) : Colors.blue[100]!;
  }

  Color _otherBubble(BuildContext context) {
    final dark = ThemeHelper.isDarkMode(context);
    return dark ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
  }

  Color _inputFill(BuildContext context) {
    final dark = ThemeHelper.isDarkMode(context);
    return dark ? const Color(0xFF222222) : Colors.grey[100]!;
  }

  Color _hintColor(BuildContext context) =>
      ThemeHelper.textColor(context).withOpacity(.6);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext newContext) {
        final bg = ThemeHelper.backgroundColor(newContext);
        final textColor = ThemeHelper.textColor(newContext);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.receiverName,
                      style: AppTextStyles.titleLarge(
                        textColor,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                BlocBuilder<PrivateChatCubit, PrivateChatState>(
                  builder: (context, state) {
                    return state.isPeerTyping
                        ? _buildTypingIndicator(context)
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
            iconTheme: IconThemeData(color: textColor),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<PrivateChatCubit, PrivateChatState>(
                        listenWhen: (p, c) =>
                            p.messages.length != c.messages.length ||
                            p.isPeerTyping != c.isPeerTyping,
                        listener: (ctx, state) => _scrollToBottom(),
                      ),
                      BlocListener<ChatMessagesCubit, ChatMessagesStates>(
                        listener: (ctx, state) {
                          if (state is ChatMessagesLoaded) {
                            _hasMoreMessages = state.hasNextPage;
                            setState(() {
                              _isLoadingMore = false;
                            });
                            debugPrint(
                              'ChatMessagesLoaded: hasNextPage=$_hasMoreMessages',
                            );
                          } else if (state is ChatMessagesLoadingMore) {
                            _hasMoreMessages = state.hasNextPage;
                            debugPrint(
                              'ChatMessagesLoadingMore: hasNextPage=$_hasMoreMessages',
                            );
                          } else if (state is ChatMessagesFailure) {
                            debugPrint('ChatMessagesFailure: ${state.error}');
                            setState(() {
                              _isLoadingMore = false;
                            });
                          }
                        },
                      ),
                    ],
                    child: BlocBuilder<ChatMessagesCubit, ChatMessagesStates>(
                      builder: (context, historyState) {
                        final history = <Messages>[];
                        if (historyState is ChatMessagesLoaded) {
                          final list =
                              historyState.chatMessages.data?.messages ?? [];
                          history.addAll(list);
                          history.sort(
                            (a, b) => a.createdAtDate.compareTo(b.createdAtDate),
                          );
                        } else if (historyState is ChatMessagesLoadingMore) {
                          final list =
                              historyState.chatMessages.data?.messages ?? [];
                          history.addAll(list);
                          history.sort(
                            (a, b) =>
                                a.createdAtDate.compareTo(b.createdAtDate),
                          );
                        }

                        return BlocBuilder<PrivateChatCubit, PrivateChatState>(
                          builder: (context, liveState) {
                            final all = <Messages>[];
                            final seen = <String>{};

                            for (final m in history) {
                              final key = (m.id ?? m.createdAt.hashCode)
                                  .toString();
                              if (seen.add(key)) all.add(m);
                            }

                            for (final m in liveState.messages) {
                              final key = (m.id ?? m.createdAt.hashCode)
                                  .toString();
                              if (seen.add(key)) all.add(m);
                            }

                            if (liveState.isPeerTyping) {
                              all.add(
                                Messages(
                                  id: -1,
                                  senderId: int.tryParse(widget.receiverId),
                                  receiverId: int.tryParse(
                                    widget.currentUserId,
                                  ),
                                  type: 'typing',
                                  message: '',
                                  createdAt: DateTime.now().toIso8601String(),
                                ),
                              );
                            }

                            all.sort(
                              (a, b) =>
                                  a.createdAtDate.compareTo(b.createdAtDate),
                            );

                            return ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  all.length +
                                  (_hasMoreMessages && _isLoadingMore ? 1 : 0),
                              reverse: true,
                              itemBuilder: (context, index) {
                                // Show loader at the top (last index in reversed list)
                                if (_hasMoreMessages &&
                                    _isLoadingMore &&
                                    index == all.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final msg = all[index];
                                final isMe =
                                    (msg.senderId?.toString() ?? '') ==
                                    widget.currentUserId;
                                return _buildMessageBubble(context, msg, isMe);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                _buildInputArea(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text('Typing...', style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, Messages msg, bool isMe) {
    final bubbleColor = isMe ? _meBubble(context) : _otherBubble(context);
    final bodyText = AppTextStyles.bodyMedium(ThemeHelper.textColor(context));
    final timeText = AppTextStyles.labelSmall(
      ThemeHelper.textColor(context).withOpacity(.6),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if ((msg.type ?? 'text') == 'text')
                Text(
                  (msg.message ?? ''),
                  style: bodyText.copyWith(fontSize: 16),
                ),
              if ((msg.type ?? '') == 'image' &&
                  (msg.imageUrl ?? '').isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    msg.imageUrl!,
                    height: 220,
                    width: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 4),
              Text(msg.formattedTime, style: timeText),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final fill = _inputFill(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        color: ThemeHelper.backgroundColor(context),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: AppTextStyles.bodyMedium(textColor),
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  hintStyle: AppTextStyles.bodyMedium(_hintColor(context)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: fill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onChanged: (text) {
                  try {
                    final cubit = context.read<PrivateChatCubit>();
                    if (text.isNotEmpty) {
                      cubit.startTyping();
                    } else {
                      cubit.stopTyping();
                    }
                  } catch (e) {
                    debugPrint(
                      'Error accessing PrivateChatCubit in onChanged: $e',
                    );
                  }
                },
                onSubmitted: (_) => _sendText(context),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: textColor),
              onPressed: () => _sendText(context),
            ),
          ],
        ),
      ),
    );
  }

  void _sendText(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    try {
      context.read<PrivateChatCubit>().sendMessage(text);
      _controller.clear();
      context.read<PrivateChatCubit>().stopTyping();
    } catch (e) {
      debugPrint('Error accessing PrivateChatCubit in _sendText: $e');
    }
  }
}
