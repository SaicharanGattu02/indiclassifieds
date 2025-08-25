import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/services/AuthService.dart';
import 'package:shimmer/shimmer.dart';
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

class _UserListScreenState extends State<UserListScreen> with SingleTickerProviderStateMixin {
  String? userId;
  final TextEditingController _search = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // --- at the top of your State class ---
  Timer? _searchDebounce;
  static const _searchDelay = Duration(milliseconds: 350);
  String _lastFiredQuery = '';   // avoids redundant fetches
  String _query = '';


  @override
  void initState() {
    super.initState();
    // Fetch chat users
    context.read<ChatUsersCubit>().fetchChatUsers("");
    getUserId();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  Future<void> getUserId() async {
    userId = await AuthService.getId();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _search.dispose();
    _searchDebounce?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) {
    setState(() => _query = v);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDelay, () {
      if (!mounted) return;
      final q = _query.trim();
      if (q == _lastFiredQuery) return; // no-op if same as last fired
      _lastFiredQuery = q;
      context.read<ChatUsersCubit>().fetchChatUsers(q);
    });
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    setState(() {
      _query = '';
    });
    _lastFiredQuery = '';
    context.read<ChatUsersCubit>().fetchChatUsers('');
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
        title: Text(
          'Messages',
          style: AppTextStyles.headlineMedium(textColor).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
        ],
      ),
      body: Column(
        children: [
          // Search Bar with Animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:TextField(
                  controller: _search,
                  onChanged: _onSearchChanged,                   // ← debounced
                  style: AppTextStyles.bodyMedium(textColor),
                  decoration: InputDecoration(
                    hintText: 'Search by name…',
                    hintStyle: AppTextStyles.bodyMedium(textColor.withOpacity(0.6)),
                    prefixIcon: Icon(Icons.search, color: textColor.withOpacity(0.8)),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: textColor.withOpacity(0.8)),
                      onPressed: _clearSearch,            // ← debounced clear
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
              ),
            ),
          ),

          // Dynamic List
          Expanded(
            child: BlocBuilder<ChatUsersCubit, ChatUsersStates>(
              builder: (context, state) {
                if (state is ChatUsersLoading) {
                  return _buildShimmerList(card, textColor);
                } else if (state is ChatUsersFailure) {
                  return _buildErrorState(context, state.error, textColor);
                } else if (state is ChatUsersLoaded) {
                  final users = state.chatUsersModel.data ?? [];
                  final filtered = _query.trim().isEmpty
                      ? users
                      : users
                      .where((u) => (u.name ?? '').toLowerCase().contains(_query.toLowerCase()))
                      .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No users found',
                        style: AppTextStyles.bodyLarge(textColor.withOpacity(0.7)),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => context.read<ChatUsersCubit>().fetchChatUsers(""),
                    color: textColor,
                    backgroundColor: card,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final user = filtered[i];
                        final id = user.userId ?? 0;
                        final name = user.name ?? '';
                        final imageUrl = user.profileImage ?? '';
                        return _ChatCard(
                          id: id,
                          name: name,
                          imageUrl: imageUrl, // ← pass it
                          onTap: () {
                            context.push('/chat?receiverId=$id&receiverName=$name&receiverImage=${user.profileImage}');
                          },
                          card: card,
                          textColor: textColor,
                          animationDelay: i * 100, // Staggered animation for each card
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

  // Shimmer effect for loading state
  Widget _buildShimmerList(Color card, Color textColor) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      itemCount: 6, // Number of shimmer placeholders
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: card.withOpacity(0.5),
        highlightColor: card.withOpacity(0.8),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // Error state with retry button
  Widget _buildErrorState(BuildContext context, String error, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: AppTextStyles.bodyLarge(textColor.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ChatUsersCubit>().fetchChatUsers(""),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Retry',
              style: AppTextStyles.bodyMedium(Colors.white),
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
    required this.imageUrl,
    required this.onTap,
    required this.card,
    required this.textColor,
    required this.animationDelay,
  });

  final int id;
  final String name;
  final String imageUrl;        // ← new
  final VoidCallback onTap;
  final Color card;
  final Color textColor;
  final int animationDelay;

  bool get _hasImage =>
      imageUrl.trim().isNotEmpty &&
          Uri.tryParse(imageUrl)?.hasAbsolutePath == true;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    final a = parts[0].characters.first.toUpperCase();
    final b = parts[1].characters.first.toUpperCase();
    return '$a$b';
  }

  Widget _initialsAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(name),
        style: AppTextStyles.titleLarge(Colors.white).copyWith(
          fontWeight: FontWeight.bold,
          fontSize: size * 0.42,
        ),
      ),
    );
  }

  Widget _avatar({double size = 48}) {
    if (_hasImage) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _initialsAvatar(size),
          // (optional) tiny placeholder while loading
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _initialsAvatar(size);
          },
        ),
      );
    }
    return _initialsAvatar(size);
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300 + animationDelay),
      child: Material(
        color: card,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                _avatar(size: 48),                 // ← image or initials
                const SizedBox(width: 12),

                // Name (and future: last message/time/unread)
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
                              style: AppTextStyles.titleLarge(textColor).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // You can add last message preview/time here later
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

