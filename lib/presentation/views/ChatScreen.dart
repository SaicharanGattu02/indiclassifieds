import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:indiclassifieds/data/cubit/ChatMessages/ChatMessagesCubit.dart';
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

class _ListItem {
  final Messages? message;
  final DateTime? day;
  final bool isHeader;
  const _ListItem.message(this.message) : day = null, isHeader = false;
  const _ListItem.header(this.day) : message = null, isHeader = true;
}

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();

  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;

  // ScrollablePositionedList controls
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener =
      ItemPositionsListener.create();

  // Sticky header state
  bool _showStickyHeader = true;
  String _stickyDateLabel = '';
  List<_ListItem> _lastItems = const [];

  // "show while scrolling" state
  Timer? _scrollIdleTimer;
  bool _isScrolling = false;

  void _onScrollActivity() {
    if (!_isScrolling) setState(() => _isScrolling = true);
    _scrollIdleTimer?.cancel();
    _scrollIdleTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _isScrolling = false);
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      context.read<ChatMessagesCubit>().fetchMessages(widget.receiverId);
    } catch (_) {}

    _positionsListener.itemPositions.addListener(() {
      final positions = _positionsListener.itemPositions.value;
      if (positions.isEmpty || _lastItems.isEmpty) return;

      // First visible item (lowest index)
      final first = positions
          .where((p) => p.itemTrailingEdge > 0) // visible
          .reduce((a, b) => a.index < b.index ? a : b);

      String _labelForIndex(int idx) {
        if (idx < 0 || idx >= _lastItems.length) return '';
        final it = _lastItems[idx];
        if (it.isHeader) return _dateLabel(it.day!);
        final d = it.message!.createdAtDate;
        return _dateLabel(d);
      }

      final newLabel = _labelForIndex(first.index);

      // hide sticky if the inline header with same label is already at/near top
      bool topHasSameInlineHeader = false;
      for (final p in positions) {
        final idx = p.index;
        if (idx < 0 || idx >= _lastItems.length) continue;
        final it = _lastItems[idx];
        if (it.isHeader) {
          final lbl = _dateLabel(it.day!);
          if (lbl == newLabel && p.itemLeadingEdge <= 0.18) {
            topHasSameInlineHeader = true;
            break;
          }
        }
      }

      final nextShowSticky = !topHasSameInlineHeader;
      if (nextShowSticky != _showStickyHeader || newLabel != _stickyDateLabel) {
        setState(() {
          _showStickyHeader = nextShowSticky;
          _stickyDateLabel = newLabel;
        });
      }

      // Load more when scrolled near the top (older side) with reverse:true
      final nearTop = positions.any((p) => p.index >= _lastItems.length - 3);
      if (nearTop && !_isLoadingMore && _hasMoreMessages) {
        setState(() => _isLoadingMore = true);
        context.read<ChatMessagesCubit>().getMoreMessages(widget.receiverId);
      }

      // Important: do NOT call _onScrollActivity() here,
      // we only want the sticky to appear on *user* scroll via NotificationListener.
    });
  }

  @override
  void dispose() {
    _scrollIdleTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_lastItems.isEmpty) return;
    if (_itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: 0, // index 0 is newest (bottom) when reverse:true
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0, // stick to bottom
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

  bool get _hasReceiverImage =>
      (widget.receiverImage).trim().isNotEmpty &&
          Uri.tryParse(widget.receiverImage)?.hasAbsolutePath == true;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    final first = parts[0].characters.first.toUpperCase();
    final second = parts[1].characters.first.toUpperCase();
    return '$first$second';
  }

  Widget _fallbackAvatar(double size, String initials) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade300,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.42,
        ),
      ),
    );
  }

  Widget _profileAvatar({double size = 36}) {
    final initials = _initials(widget.receiverName);
    if (_hasReceiverImage) {
      return ClipOval(
        child: Image.network(
          widget.receiverImage,
          width: size,
          height: size,
          fit: BoxFit.cover,
          // If network image fails, show initials
          errorBuilder: (_, __, ___) => _fallbackAvatar(size, initials),
        ),
      );
    }
    return _fallbackAvatar(size, initials);
  }


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
              crossAxisAlignment: CrossAxisAlignment.start,   // ← left align
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _profileAvatar(size: 36),             // ← avatar or initials
                    const SizedBox(width: 10),
                    Expanded( // ← prevent overflow with long names
                      child: Text(
                        widget.receiverName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleLarge(textColor)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<PrivateChatCubit, PrivateChatState>(
                  buildWhen: (p, c) => p.isPeerTyping != c.isPeerTyping, // ← only rebuild this line
                  builder: (context, state) {
                    return AnimatedSwitcher(                 // ← smooth show/hide
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: state.isPeerTyping
                          ? _buildTypingIndicator(context)   // visible
                          : const SizedBox(height: 16),      // ← placeholder height to avoid jump
                    );
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
                          } else if (state is ChatMessagesLoadingMore) {
                            _hasMoreMessages = state.hasNextPage;
                          } else if (state is ChatMessagesFailure) {
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
                          history.addAll(
                            historyState.chatMessages.data?.messages ??
                                const [],
                          );
                        } else if (historyState is ChatMessagesLoadingMore) {
                          history.addAll(
                            historyState.chatMessages.data?.messages ??
                                const [],
                          );
                        }

                        return BlocBuilder<PrivateChatCubit, PrivateChatState>(
                          builder: (context, liveState) {
                            // Merge + dedupe
                            final all = <Messages>[];
                            final seen = <String>{};

                            void addMsg(Messages m) {
                              final key =
                                  (m.id?.toString() ?? m.createdAt.toString());
                              if (seen.add(key)) all.add(m);
                            }

                            for (final m in history) addMsg(m);
                            for (final m in liveState.messages) addMsg(m);

                            // NEWEST → OLDEST (DESC) for reverse:true
                            all.sort(
                              (a, b) =>
                                  b.createdAtDate.compareTo(a.createdAtDate),
                            );

                            // Build flat items and cache for sticky logic
                            final items = _buildItems(all);
                            _lastItems = items;

                            final overlayVisible =
                                _isScrolling &&
                                _showStickyHeader &&
                                _stickyDateLabel.isNotEmpty;

                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                // Add top padding so inline chips don't sit under the floating chip.
                                Padding(
                                  padding: const EdgeInsets.only(top: 44),
                                  child: NotificationListener<ScrollNotification>(
                                    onNotification: (n) {
                                      if (n is ScrollStartNotification ||
                                          n is ScrollUpdateNotification ||
                                          n is OverscrollNotification) {
                                        _onScrollActivity(); // sets _isScrolling=true, hides after 300ms idle
                                      }
                                      return false;
                                    },
                                    child: ScrollablePositionedList.builder(
                                      itemScrollController:
                                          _itemScrollController,
                                      itemPositionsListener: _positionsListener,
                                      reverse: true,
                                      itemCount:
                                          items.length +
                                          (_hasMoreMessages && _isLoadingMore
                                              ? 1
                                              : 0),
                                      itemBuilder: (context, index) {
                                        // Loader at "top" (end) with reverse:true
                                        if (_hasMoreMessages &&
                                            _isLoadingMore &&
                                            index == items.length) {
                                          return const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }

                                        final it = items[index];
                                        if (it.isHeader) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: _dateChip(
                                              _dateLabel(it.day!),
                                              ThemeHelper.textColor(context),
                                            ),
                                          );
                                        } else {
                                          final msg = it.message!;
                                          final isMe =
                                              (msg.senderId?.toString() ??
                                                  '') ==
                                              widget.currentUserId;
                                          return _buildMessageBubble(
                                            context,
                                            msg,
                                            isMe,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                // Sticky date chip — visible ONLY while scrolling
                                if (overlayVisible)
                                  Positioned(
                                    top: 6,
                                    child: _dateChip(
                                      _stickyDateLabel,
                                      ThemeHelper.textColor(context),
                                    ),
                                  ),
                              ],
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
    return Semantics(
      liveRegion: true, // a11y: announce updates
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          'Typing…',
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: 12,
            height: 1.2,
          ),
        ),
      ),
    );
  }


  String _dateLabel(DateTime day) {
    final now = DateTime.now();
    final d0 = DateTime(day.year, day.month, day.day);
    final n0 = DateTime(now.year, now.month, now.day);
    final diff = n0.difference(d0).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(day);
  }

  /// Build flat list with headers that appear ABOVE their day (works with reverse:true)
  List<_ListItem> _buildItems(List<Messages> allDesc) {
    // allDesc is NEWEST → OLDEST
    final items = <_ListItem>[];
    final buffer = <Messages>[];
    DateTime? bucketDay;

    void flush() {
      if (buffer.isEmpty || bucketDay == null) return;
      for (final m in buffer) items.add(_ListItem.message(m));
      // header after its messages so it appears above with reverse:true
      items.add(_ListItem.header(bucketDay));
      buffer.clear();
      bucketDay = null;
    }

    for (final m in allDesc) {
      if ((m.type ?? 'text') == 'typing')
        continue; // skip ephemeral typing here
      final d = m.createdAtDate.toLocal();
      final key = DateTime(d.year, d.month, d.day);
      if (bucketDay == null || bucketDay == key) {
        bucketDay = key;
        buffer.add(m);
      } else {
        flush();
        bucketDay = key;
        buffer.add(m);
      }
    }
    flush();
    return items;
  }

  Widget _dateChip(String label, Color textColor) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: textColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label, style: AppTextStyles.labelMedium(textColor)),
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
