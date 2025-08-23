import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../data/cubit/OnlineUsers/online_users_cubit.dart';
import '../../data/cubit/chat/private_chat_cubit.dart';
import '../../model/message.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

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
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      } catch (_) {}
    });
  }

  // Bubble & input colors derived from theme
  Color _meBubble(BuildContext context) {
    final dark = ThemeHelper.isDarkMode(context);
    return dark ? const Color(0xFF234476) /* deep desaturated blue */ : Colors.blue[100]!;
  }

  Color _otherBubble(BuildContext context) {
    final dark = ThemeHelper.isDarkMode(context);
    return dark ? const Color(0xFF2A2A2A) /* dark card-ish */ : Colors.grey[200]!;
  }

  Color _inputFill(BuildContext context) {
    final dark = ThemeHelper.isDarkMode(context);
    return dark ? const Color(0xFF222222) : Colors.grey[100]!;
  }

  Color _hintColor(BuildContext context) =>
      ThemeHelper.textColor(context).withOpacity(.6);

  @override
  Widget build(BuildContext context) {
    final bg = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PrivateChatCubit(widget.currentUserId, widget.receiverId),
        ),
        BlocProvider(create: (_) => OnlineUsersCubit()),
      ],
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Row(
            children: [
              Text(
                widget.receiverName,
                style: AppTextStyles.titleLarge(textColor).copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              BlocBuilder<OnlineUsersCubit, OnlineUsersState>(
                builder: (context, state) {
                  final isOnline = state.onlineUsers.contains(widget.receiverId);
                  return Icon(
                    Icons.circle,
                    color: isOnline ? Colors.green : Colors.grey,
                    size: 12,
                  );
                },
              ),
            ],
          ),
          iconTheme: IconThemeData(color: textColor),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<PrivateChatCubit, PrivateChatState>(
                listener: (context, state) => _scrollToBottom(),
                builder: (context, state) {
                  final items = [
                    ...state.messages,
                    if (state.isPeerTyping)
                      Message(
                        id: '_typing_',
                        senderId: widget.receiverId,
                        receiverId: widget.currentUserId,
                        message: '',
                        type: 'typing',
                        createdAt: DateTime.now(),
                      ),
                  ];

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final msg = items[index];
                      if (msg.type == 'typing') {
                        return _buildTypingIndicator(context);
                      }
                      final isMe = msg.senderId == widget.currentUserId;
                      return _buildMessageBubble(context, msg, isMe);
                    },
                  );
                },
              ),
            ),
            _buildInputArea(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, Message msg, bool isMe) {
    final bubbleColor = isMe ? _meBubble(context) : _otherBubble(context);
    final bodyText = AppTextStyles.bodyMedium(ThemeHelper.textColor(context));
    final timeText = AppTextStyles.labelSmall(ThemeHelper.textColor(context).withOpacity(.6));

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
              if (msg.type == 'text')
                Text(msg.message, style: bodyText.copyWith(fontSize: 16)),
              if (msg.type == 'image' && msg.imageUrl != null)
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

  Widget _buildTypingIndicator(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            Text('Typing...', style: AppTextStyles.bodySmall(textColor)),
          ],
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
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onChanged: (text) {
                  final cubit = context.read<PrivateChatCubit>();
                  if (text.isNotEmpty) {
                    cubit.startTyping();
                  } else {
                    cubit.stopTyping();
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
    context.read<PrivateChatCubit>().sendMessage(text);
    _controller.clear();
    context.read<PrivateChatCubit>().stopTyping();
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
        context.read<PrivateChatCubit>()
            .sendMessage('', type: 'image', imageUrl: imageUrl);
      } else {
        debugPrint('Upload response missing image_url/url');
      }
    } catch (e) {
      debugPrint('Upload error: $e');
    }
  }
}

