// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:indiclassifieds/data/cubit/ChatMessages/ChatMessagesCubit.dart';
// import 'package:intl/intl.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import '../../data/cubit/Chat/private_chat_cubit.dart';
// import '../../data/cubit/ChatMessages/ChatMessagesStates.dart';
// import '../../model/ChatMessagesModel.dart';
// import '../../theme/AppTextStyles.dart';
// import '../../theme/ThemeHelper.dart';
// import 'package:flutter/widgets.dart' show ScrollDirection;
//
//
// extension ChatScreenMessagesX on Messages {
//   DateTime get createdAtDate {
//     final raw = createdAt?.toString() ?? '';
//     return DateTime.tryParse(raw) ?? DateTime.now();
//   }
//
//   String get formattedTime {
//     return DateFormat('hh:mm a').format(createdAtDate);
//   }
//
//   bool get isImage => (type ?? '') == 'image';
//   bool get isText => (type ?? '') == 'text';
// }
//
//
// class _ListItem {
//   final Messages? message;
//   final DateTime? day;
//   final bool isHeader;
//   const _ListItem.message(this.message) : day = null, isHeader = false;
//   const _ListItem.header(this.day)      : message = null, isHeader = true;
// }
//
//
// class ChatScreen extends StatefulWidget {
//   final String currentUserId;
//   final String receiverId;
//   final String receiverName;
//
//   const ChatScreen({
//     super.key,
//     required this.currentUserId,
//     required this.receiverId,
//     required this.receiverName,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();
//   final _scrollController = ScrollController();
//   bool _isLoadingMore = false;
//   bool _hasMoreMessages = true;
//
//   // replace/augment your existing controllers
//   final ItemScrollController _itemScrollController = ItemScrollController();
//   final ItemPositionsListener _positionsListener = ItemPositionsListener.create();
//
//   bool _showStickyHeader = true;  // whether to draw the floating header
//   String _stickyDateLabel = '';   // you already had this, keep it
//   List<_ListItem> _lastItems = const []; // you already had this, keep it
//
//   Timer? _scrollIdleTimer;
//   bool _isScrolling = false;
//
//
//   void _onScrollActivity() {
//     if (!_isScrolling) setState(() => _isScrolling = true);
//     _scrollIdleTimer?.cancel();
//     _scrollIdleTimer = Timer(const Duration(milliseconds: 300), () {
//       if (!mounted) return;
//       setState(() => _isScrolling = false);
//     });
//   }
//
//
//
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   try {
//   //     context.read<ChatMessagesCubit>().fetchMessages(widget.receiverId);
//   //     debugPrint('ChatMessagesCubit accessed successfully in initState');
//   //   } catch (e) {
//   //     debugPrint('Error accessing ChatMessagesCubit in initState: $e');
//   //   }
//   //
//   //   // Detect when the user scrolls near the top to load more messages
//   //   _scrollController.addListener(() {
//   //     final pos = _scrollController.position;
//   //     // near top (older side) for reverse:true
//   //     if (pos.pixels >= pos.maxScrollExtent - 100 && !_isLoadingMore && _hasMoreMessages) {
//   //       setState(() => _isLoadingMore = true);
//   //       context.read<ChatMessagesCubit>().getMoreMessages(widget.receiverId);
//   //     }
//   //   });
//   //
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     try {
//       context.read<ChatMessagesCubit>().fetchMessages(widget.receiverId);
//     } catch (_) {}
//
//     _positionsListener.itemPositions.addListener(() {
//       final positions = _positionsListener.itemPositions.value;
//       if (positions.isEmpty || _lastItems.isEmpty) return;
//
//       // First visible item (lowest index)
//       final first = positions
//           .where((p) => p.itemTrailingEdge > 0) // visible
//           .reduce((a, b) => a.index < b.index ? a : b);
//
//       String _labelForIndex(int idx) {
//         if (idx < 0 || idx >= _lastItems.length) return '';
//         final it = _lastItems[idx];
//         if (it.isHeader) return _dateLabel(it.day!);
//         final d = it.message!.createdAtDate;
//         return _dateLabel(d);
//       }
//
//       final newLabel = _labelForIndex(first.index);
//
//       // 🔎 Is an inline header with the SAME label currently at the very top?
//       bool topHasSameInlineHeader = false;
//       for (final p in positions) {
//         final idx = p.index;
//         if (idx < 0 || idx >= _lastItems.length) continue;
//         final it = _lastItems[idx];
//         if (it.isHeader) {
//           final lbl = _dateLabel(it.day!);
//           // "near the top": leading edge <= ~12% of viewport height
//           if (lbl == newLabel && p.itemLeadingEdge <= 0.12) {
//             topHasSameInlineHeader = true;
//             break;
//           }
//         }
//       }
//
//       final nextShowSticky = !topHasSameInlineHeader;
//       if (nextShowSticky != _showStickyHeader || newLabel != _stickyDateLabel) {
//         setState(() {
//           _showStickyHeader = nextShowSticky;
//           _stickyDateLabel = newLabel;
//         });
//       }
//
//       // Load more when scrolled near the "top" (older side) with reverse:true
//       final nearTop = positions.any((p) => p.index >= _lastItems.length - 3);
//       if (nearTop && !_isLoadingMore && _hasMoreMessages) {
//         setState(() => _isLoadingMore = true);
//         context.read<ChatMessagesCubit>().getMoreMessages(widget.receiverId);
//       }
//     });
//   }
//
//
//   @override
//   void dispose() {
//     _scrollIdleTimer?.cancel();
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   //
//   // void _scrollToBottom() {
//   //   if (!_scrollController.hasClients) return;
//   //   _scrollController.animateTo(
//   //     _scrollController.position.minScrollExtent, // bottom with reverse:true
//   //     duration: const Duration(milliseconds: 250),
//   //     curve: Curves.easeOut,
//   //   );
//   // }
//
//
//   void _scrollToBottom() {
//     if (_lastItems.isEmpty) return;
//     if (_itemScrollController.isAttached) {
//       _itemScrollController.scrollTo(
//         index: 0,                 // index 0 is newest (bottom) with reverse:true
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//         alignment: 0,             // stick to bottom
//       );
//     }
//   }
//
//
//   Color _meBubble(BuildContext context) {
//     final dark = ThemeHelper.isDarkMode(context);
//     return dark ? const Color(0xFF234476) : Colors.blue[100]!;
//   }
//
//   Color _otherBubble(BuildContext context) {
//     final dark = ThemeHelper.isDarkMode(context);
//     return dark ? const Color(0xFF2A2A2A) : Colors.grey[200]!;
//   }
//
//   Color _inputFill(BuildContext context) {
//     final dark = ThemeHelper.isDarkMode(context);
//     return dark ? const Color(0xFF222222) : Colors.grey[100]!;
//   }
//
//   Color _hintColor(BuildContext context) =>
//       ThemeHelper.textColor(context).withOpacity(.6);
//
//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//       builder: (BuildContext newContext) {
//         final bg = ThemeHelper.backgroundColor(newContext);
//         final textColor = ThemeHelper.textColor(newContext);
//
//         return Scaffold(
//           backgroundColor: bg,
//           appBar: AppBar(
//             backgroundColor: bg,
//             elevation: 0,
//             surfaceTintColor: Colors.transparent,
//             title: Column(
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       widget.receiverName,
//                       style: AppTextStyles.titleLarge(
//                         textColor,
//                       ).copyWith(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//                 BlocBuilder<PrivateChatCubit, PrivateChatState>(
//                   builder: (context, state) {
//                     return state.isPeerTyping
//                         ? _buildTypingIndicator(context)
//                         : const SizedBox.shrink();
//                   },
//                 ),
//               ],
//             ),
//             iconTheme: IconThemeData(color: textColor),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: MultiBlocListener(
//                     listeners: [
//                       BlocListener<PrivateChatCubit, PrivateChatState>(
//                         listenWhen: (p, c) =>
//                             p.messages.length != c.messages.length ||
//                             p.isPeerTyping != c.isPeerTyping,
//                         listener: (ctx, state) => _scrollToBottom(),
//                       ),
//                       BlocListener<ChatMessagesCubit, ChatMessagesStates>(
//                         listener: (ctx, state) {
//                           if (state is ChatMessagesLoaded) {
//                             _hasMoreMessages = state.hasNextPage;
//                             setState(() {
//                               _isLoadingMore = false;
//                             });
//                             debugPrint(
//                               'ChatMessagesLoaded: hasNextPage=$_hasMoreMessages',
//                             );
//                           } else if (state is ChatMessagesLoadingMore) {
//                             _hasMoreMessages = state.hasNextPage;
//                             debugPrint(
//                               'ChatMessagesLoadingMore: hasNextPage=$_hasMoreMessages',
//                             );
//                           } else if (state is ChatMessagesFailure) {
//                             debugPrint('ChatMessagesFailure: ${state.error}');
//                             setState(() {
//                               _isLoadingMore = false;
//                             });
//                           }
//                         },
//                       ),
//                     ],
//                     child: BlocBuilder<ChatMessagesCubit, ChatMessagesStates>(
//                       builder: (context, historyState) {
//                         final history = <Messages>[];
//
//                         if (historyState is ChatMessagesLoaded) {
//                           history.addAll(historyState.chatMessages.data?.messages ?? const []);
//                         } else if (historyState is ChatMessagesLoadingMore) {
//                           history.addAll(historyState.chatMessages.data?.messages ?? const []);
//                         }
//
//                         return BlocBuilder<PrivateChatCubit, PrivateChatState>(
//                           builder: (context, liveState) {
//                             final all = <Messages>[];
//                             final seen = <String>{};
//
//                             void addMsg(Messages m) {
//                               final key = (m.id?.toString() ?? m.createdAt.toString());
//                               if (seen.add(key)) all.add(m);
//                             }
//
//                             for (final m in history) addMsg(m);
//                             for (final m in liveState.messages) addMsg(m);
//
//                             // NEWEST → OLDEST (DESC) for reverse:true
//                             all.sort((a, b) => b.createdAtDate.compareTo(a.createdAtDate));
//
//                             // Build date-grouped flat items (msg/msg/.. then header)
//                             final items = _buildItems(all);
//                             final textColor = ThemeHelper.textColor(context);
//
//                             // return ListView.builder(
//                             //   controller: _scrollController,
//                             //   reverse: true,
//                             //   itemCount: items.length + (_hasMoreMessages && _isLoadingMore ? 1 : 0),
//                             //   itemBuilder: (context, index) {
//                             //     // loader at the "top" (end when reverse:true)
//                             //     if (_hasMoreMessages && _isLoadingMore && index == items.length) {
//                             //       return const Padding(
//                             //         padding: EdgeInsets.symmetric(vertical: 10),
//                             //         child: Center(child: CircularProgressIndicator()),
//                             //       );
//                             //     }
//                             //
//                             //     final it = items[index];
//                             //     if (it.isHeader) {
//                             //       return _dateChip(_dateLabel(it.day!), textColor);
//                             //     } else {
//                             //       final msg = it.message!;
//                             //       final isMe = (msg.senderId?.toString() ?? '') == widget.currentUserId;
//                             //       return _buildMessageBubble(context, msg, isMe);
//                             //     }
//                             //   },
//                             // );
//                             return Builder(
//                               builder: (context) {
//                                 // Merge + dedupe as you already do
//                                 final all = <Messages>[];
//                                 final seen = <String>{};
//
//                                 void addMsg(Messages m) {
//                                   final key = (m.id?.toString() ?? m.createdAt.toString());
//                                   if (seen.add(key)) all.add(m);
//                                 }
//
//                                 for (final m in history) addMsg(m);
//                                 for (final m in liveState.messages) addMsg(m);
//
//                                 // NEWEST → OLDEST (DESC) for reverse:true
//                                 all.sort((a, b) => b.createdAtDate.compareTo(a.createdAtDate));
//
//                                 // Build flat items and cache for sticky logic
//                                 final items = _buildItems(all);
//                                 _lastItems = items;
//
//                                 final textColor = ThemeHelper.textColor(context);
//                                 final overlayVisible = _isScrolling && _showStickyHeader && _stickyDateLabel.isNotEmpty;
//                                 return Stack(
//                                   alignment: Alignment.topCenter,
//                                   children: [
//                                     // Give space so inline chips never sit under the floating chip
//                                     Padding(
//                                       // optional tiny gap so the chip doesn't touch screen edge
//                                       padding: const EdgeInsets.only(top: 12),
//                                       child: NotificationListener<ScrollNotification>(
//                                         onNotification: (n) {
//                                           // mark as scrolling for any user-driven movement
//                                           if (n is ScrollStartNotification ||
//                                               n is ScrollUpdateNotification ||
//                                               n is OverscrollNotification ||
//                                               (n is UserScrollNotification && n.direction != ScrollDirection.idle)) {
//                                             _onScrollActivity(); // sets _isScrolling = true, debounces to false
//                                           }
//                                           return false;
//                                         },
//                                         child: ScrollablePositionedList.builder(
//                                           itemScrollController: _itemScrollController,
//                                           itemPositionsListener: _positionsListener,
//                                           reverse: true,
//                                           itemCount: items.length + (_hasMoreMessages && _isLoadingMore ? 1 : 0),
//                                           itemBuilder: (context, index) {
//                                             if (_hasMoreMessages && _isLoadingMore && index == items.length) {
//                                               return const Padding(
//                                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                                 child: Center(child: CircularProgressIndicator()),
//                                               );
//                                             }
//                                             final it = items[index];
//                                             if (it.isHeader) {
//                                               return Padding(
//                                                 padding: const EdgeInsets.symmetric(vertical: 8),
//                                                 child: _dateChip(_dateLabel(it.day!), textColor),
//                                               );
//                                             } else {
//                                               final msg = it.message!;
//                                               final isMe = (msg.senderId?.toString() ?? '') == widget.currentUserId;
//                                               return _buildMessageBubble(context, msg, isMe);
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                     ),
//
//                                     // Floating (sticky) chip — ONLY while scrolling
//                                     if (overlayVisible)
//                                       Positioned(
//                                         top: 6,
//                                         child: _dateChip(_stickyDateLabel, textColor),
//                                       ),
//                                   ],
//                                 );
//
//
//                               },
//                             );
//
//                           },
//                         );
//                       },
//                     ),
//
//                   ),
//                 ),
//                 _buildInputArea(context),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTypingIndicator(BuildContext context) {
//     final textColor = ThemeHelper.textColor(context);
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           children: [
//             const SizedBox(width: 8),
//             Text('Typing...', style: TextStyle(color: textColor)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _dateLabel(DateTime day) {
//     final now = DateTime.now();
//     final d0 = DateTime(day.year, day.month, day.day);
//     final n0 = DateTime(now.year, now.month, now.day);
//     final diff = n0.difference(d0).inDays;
//     if (diff == 0) return 'Today';
//     if (diff == 1) return 'Yesterday';
//     return DateFormat('d MMM yyyy').format(day);
//   }
//
//   /// Build flat list with headers that appear ABOVE their day (works with reverse:true)
//   List<_ListItem> _buildItems(List<Messages> allDesc) {
//     // allDesc is NEWEST → OLDEST
//     final items = <_ListItem>[];
//     final buffer = <Messages>[];
//     DateTime? bucketDay;
//
//     void flush() {
//       if (buffer.isEmpty || bucketDay == null) return;
//       for (final m in buffer) items.add(_ListItem.message(m));
//       items.add(_ListItem.header(bucketDay)); // header after its messages (appears above with reverse:true)
//       buffer.clear();
//       bucketDay = null;
//     }
//
//     for (final m in allDesc) {
//       if ((m.type ?? 'text') == 'typing') continue; // skip ephemeral typing here
//       final d = m.createdAtDate.toLocal();
//       final key = DateTime(d.year, d.month, d.day);
//       if (bucketDay == null || bucketDay == key) {
//         bucketDay = key;
//         buffer.add(m);
//       } else {
//         flush();
//         bucketDay = key;
//         buffer.add(m);
//       }
//     }
//     flush();
//     return items;
//   }
//
//   Widget _dateChip(String label, Color textColor) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: textColor.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Text(label, style: AppTextStyles.labelMedium(textColor)),
//       ),
//     );
//   }
//
//   Widget _buildMessageBubble(BuildContext context, Messages msg, bool isMe) {
//     final bubbleColor = isMe ? _meBubble(context) : _otherBubble(context);
//     final bodyText = AppTextStyles.bodyMedium(ThemeHelper.textColor(context));
//     final timeText = AppTextStyles.labelSmall(
//       ThemeHelper.textColor(context).withOpacity(.6),
//     );
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 320),
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: bubbleColor,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(16),
//               topRight: const Radius.circular(16),
//               bottomLeft: Radius.circular(isMe ? 16 : 4),
//               bottomRight: Radius.circular(isMe ? 4 : 16),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: isMe
//                 ? CrossAxisAlignment.end
//                 : CrossAxisAlignment.start,
//             children: [
//               if ((msg.type ?? 'text') == 'text')
//                 Text(
//                   (msg.message ?? ''),
//                   style: bodyText.copyWith(fontSize: 16),
//                 ),
//               if ((msg.type ?? '') == 'image' &&
//                   (msg.imageUrl ?? '').isNotEmpty)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     msg.imageUrl!,
//                     height: 220,
//                     width: 220,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               const SizedBox(height: 4),
//               Text(msg.formattedTime, style: timeText),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputArea(BuildContext context) {
//     final textColor = ThemeHelper.textColor(context);
//     final fill = _inputFill(context);
//
//     return SafeArea(
//       top: false,
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
//         color: ThemeHelper.backgroundColor(context),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 style: AppTextStyles.bodyMedium(textColor),
//                 decoration: InputDecoration(
//                   hintText: 'Type a message…',
//                   hintStyle: AppTextStyles.bodyMedium(_hintColor(context)),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: fill,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 10,
//                   ),
//                 ),
//                 onChanged: (text) {
//                   try {
//                     final cubit = context.read<PrivateChatCubit>();
//                     if (text.isNotEmpty) {
//                       cubit.startTyping();
//                     } else {
//                       cubit.stopTyping();
//                     }
//                   } catch (e) {
//                     debugPrint(
//                       'Error accessing PrivateChatCubit in onChanged: $e',
//                     );
//                   }
//                 },
//                 onSubmitted: (_) => _sendText(context),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.send, color: textColor),
//               onPressed: () => _sendText(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _sendText(BuildContext context) {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//     try {
//       context.read<PrivateChatCubit>().sendMessage(text);
//       _controller.clear();
//       context.read<PrivateChatCubit>().stopTyping();
//     } catch (e) {
//       debugPrint('Error accessing PrivateChatCubit in _sendText: $e');
//     }
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
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

  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;

  // ScrollablePositionedList controls
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener = ItemPositionsListener.create();

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
                      style: AppTextStyles.titleLarge(textColor)
                          .copyWith(fontWeight: FontWeight.w600),
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
                                  const []);
                        } else if (historyState is ChatMessagesLoadingMore) {
                          history.addAll(
                              historyState.chatMessages.data?.messages ??
                                  const []);
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
                            all.sort((a, b) =>
                                b.createdAtDate.compareTo(a.createdAtDate));

                            // Build flat items and cache for sticky logic
                            final items = _buildItems(all);
                            _lastItems = items;

                            final overlayVisible = _isScrolling &&
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
                                    child:
                                    ScrollablePositionedList.builder(
                                      itemScrollController:
                                      _itemScrollController,
                                      itemPositionsListener:
                                      _positionsListener,
                                      reverse: true,
                                      itemCount: items.length +
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
                                                vertical: 10),
                                            child: Center(
                                                child:
                                                CircularProgressIndicator()),
                                          );
                                        }

                                        final it = items[index];
                                        if (it.isHeader) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: _dateChip(
                                                _dateLabel(it.day!),
                                                ThemeHelper.textColor(
                                                    context)),
                                          );
                                        } else {
                                          final msg = it.message!;
                                          final isMe =
                                              (msg.senderId?.toString() ?? '') ==
                                                  widget.currentUserId;
                                          return _buildMessageBubble(
                                              context, msg, isMe);
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                // Sticky date chip — visible ONLY while scrolling
                                if (overlayVisible)
                                  Positioned(
                                    top: 6,
                                    child: _dateChip(_stickyDateLabel,
                                        ThemeHelper.textColor(context)),
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
      if ((m.type ?? 'text') == 'typing') continue; // skip ephemeral typing here
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
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                        'Error accessing PrivateChatCubit in onChanged: $e');
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
