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

extension MessagesX on Messages {
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

  @override
  void initState() {
    super.initState();
    try {
      context.read<ChatMessagesCubit>().fetchMessages(widget.receiverId);
      debugPrint('ChatMessagesCubit accessed successfully in initState');
    } catch (e) {
      debugPrint('Error accessing ChatMessagesCubit in initState: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
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
            title: Row(
              children: [
                Text(
                  widget.receiverName,
                  style: AppTextStyles.titleLarge(textColor)
                      .copyWith(fontWeight: FontWeight.w600),
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
                        listener: (ctx, state) => _scrollToBottom(),
                      ),
                    ],
                    child: BlocBuilder<ChatMessagesCubit, ChatMessagesStates>(
                      builder: (context, historyState) {
                        final history = <Messages>[];
                        if (historyState is ChatMessagesLoaded) {
                          final list =
                              historyState.chatMessages.messages ?? const <Messages>[];
                          history.addAll(list);
                          history.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));
                        }

                        return BlocBuilder<PrivateChatCubit, PrivateChatState>(
                          builder: (context, liveState) {
                            final all = <Messages>[];
                            final seen = <String>{};

                            for (final m in history) {
                              final key = (m.id ?? m.createdAt.hashCode).toString();
                              if (seen.add(key)) all.add(m);
                            }

                            for (final m in liveState.messages) {
                              final key = (m.id ?? m.createdAt.hashCode).toString();
                              if (seen.add(key)) all.add(m);
                            }

                            if (liveState.isPeerTyping) {
                              all.add(Messages(
                                id: -1,
                                senderId: int.tryParse(widget.receiverId),
                                receiverId: int.tryParse(widget.currentUserId),
                                type: 'typing',
                                message: '',
                                createdAt: DateTime.now().toIso8601String(),
                              ));
                            }

                            all.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

                            return ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: all.length,
                              itemBuilder: (context, index) {
                                final msg = all[index];
                                if (msg.type == 'typing') {
                                  return _buildTypingIndicator(context);
                                }
                                final isMe =
                                    (msg.senderId?.toString() ?? '') == widget.currentUserId;
                                return _buildMessageBubble(context, msg, isMe);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                _buildInputArea(newContext),
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
            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 8),
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
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if ((msg.type ?? 'text') == 'text')
                Text((msg.message ?? ''), style: bodyText.copyWith(fontSize: 16)),
              if ((msg.type ?? '') == 'image' && (msg.imageUrl ?? '').isNotEmpty)
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
            IconButton(
              icon: Icon(Icons.photo, color: textColor),
              onPressed: () => _pickAndUploadImage(context),
            ),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    debugPrint('Error accessing PrivateChatCubit in onChanged: $e');
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

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    try {
      final dio = Dio();
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          picked.path,
          filename: picked.name.split('/').last,
        ),
      });

      final res = await dio.post('http://your-server-url/upload_image', data: form);
      final imageUrl = res.data['image_url'] ?? res.data['url'];

      if (imageUrl is String && imageUrl.isNotEmpty) {
        context.read<PrivateChatCubit>().sendMessage('', type: 'image', imageUrl: imageUrl);
      } else {
        debugPrint('Upload response missing image_url/url');
      }
    } catch (e) {
      debugPrint('Upload error: $e');
    }
  }
}