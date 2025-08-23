import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/services/AuthService.dart';
import '../../data/cubit/Chat/private_chat_cubit.dart';
import '../../data/cubit/ChatUsers/ChatUsersCubit.dart';
import '../../data/cubit/ChatUsers/ChatUsersStates.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import 'ChatScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String? userId;
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Fetch chat users dynamically from cubit
    context.read<ChatUsersCubit>().fetchChatUsers();
    getUserId();
  }

  Future<void> getUserId() async {
    userId = await AuthService.getId();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);
    final card = ThemeHelper.cardColor(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        title: Text('Messages', style: AppTextStyles.headlineMedium(textColor)),
        actions: [
          IconButton(
            tooltip: 'New chat',
            onPressed: () {},
            icon: Icon(Icons.chat_bubble_outline, color: textColor),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withOpacity(.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                style: AppTextStyles.bodyMedium(textColor),
                decoration: InputDecoration(
                  hintText: 'Search by name…',
                  hintStyle: AppTextStyles.bodyMedium(
                    textColor.withOpacity(.6),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: textColor.withOpacity(.8),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Dynamic List
          Expanded(
            child: BlocBuilder<ChatUsersCubit, ChatUsersStates>(
              builder: (context, state) {
                if (state is ChatUsersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatUsersFailure) {
                  return Center(child: Text(state.error));
                } else if (state is ChatUsersLoaded) {
                  // Extract dynamic data from model
                  final users = state.chatUsersModel.data ?? [];
                  // final onlineIds = state.chatUsersModel.onlineIds ?? {};
                  // final meta = state.chatUsersModel.meta ?? {};

                  // Filter users by search
                  final filtered = _query.trim().isEmpty
                      ? users
                      : users
                            .where(
                              (u) => (u.name ?? '').toLowerCase().contains(
                                _query.toLowerCase(),
                              ),
                            )
                            .toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }
                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ChatUsersCubit>().fetchChatUsers(),
                    color: textColor,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final user = filtered[i];
                        final id = user.userId ?? 0;
                        final name = user.name ?? '';
                        return _ChatCard(
                          id: id,
                          name: name,
                          onTap: () {
                            context.push('/chat?receiverId=$id&receiverName=$name');
                          },
                          card: card,
                          textColor: textColor,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard({
    required this.id,
    required this.name,
    // required this.last,
    // required this.time,
    // required this.unread,
    // required this.isOnline,
    required this.onTap,
    required this.card,
    required this.textColor,
  });

  final int id;
  final String name;
  final VoidCallback onTap;
  final Color card;
  final Color textColor;

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final isToday =
        t.year == now.year && t.month == now.month && t.day == now.day;
    if (isToday) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${t.day}/${t.month}/${t.year.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Avatar + online dot
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: AppTextStyles.titleLarge(Colors.white),
                    ),
                  ),
                  // Positioned(
                  //   right: -1,
                  //   bottom: -1,
                  //   child: Container(
                  //     width: 14,
                  //     height: 14,
                  //     decoration: BoxDecoration(
                  //       color: isOnline ? Colors.green : Colors.grey,
                  //       shape: BoxShape.circle,
                  //       border: Border.all(color: card, width: 2),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(width: 12),

              // Name + last message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleLarge(
                              textColor,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Text(
                        //   _formatTime(time),
                        //   style: AppTextStyles.labelSmall(
                        //     textColor.withOpacity(.6),
                        //   ),
                        // ),
                      ],
                    ),
                    // const SizedBox(height: 4),
                    // Text(
                    //   last,
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: AppTextStyles.bodyMedium(
                    //     textColor.withOpacity(.75),
                    //   ),
                    // ),
                  ],
                ),
              ),
              //
              // if (unread > 0) ...[
              //   const SizedBox(width: 10),
              //   Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 8,
              //       vertical: 4,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.blue,
              //       borderRadius: BorderRadius.circular(999),
              //     ),
              //     child: Text(
              //       unread.toString(),
              //       style: AppTextStyles.labelSmall(Colors.white),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
