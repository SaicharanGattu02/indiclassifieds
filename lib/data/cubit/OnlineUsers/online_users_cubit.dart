// lib/data/cubit/chat/online_users_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineUsersState {
  final Set<String> onlineUsers;
  const OnlineUsersState({this.onlineUsers = const {}});
}

class OnlineUsersCubit extends Cubit<OnlineUsersState> {
  OnlineUsersCubit() : super(const OnlineUsersState());

  void setUsers(Iterable<String> ids) {
    emit(OnlineUsersState(onlineUsers: ids.toSet()));
  }

  void userOnline(String id) {
    final next = {...state.onlineUsers, id};
    emit(OnlineUsersState(onlineUsers: next));
  }

  void userOffline(String id) {
    final next = {...state.onlineUsers}..remove(id);
    emit(OnlineUsersState(onlineUsers: next));
  }
}
