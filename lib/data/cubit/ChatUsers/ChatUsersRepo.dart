import '../../../model/ChatUsersModel.dart';
import '../../remote_data_source.dart';

abstract class ChatUsersRepo {
  Future<ChatUsersModel?> getChatUsers();
}

class ChatUsersRepoImpl implements ChatUsersRepo {
  final RemoteDataSource remoteDataSource;

  ChatUsersRepoImpl({required this.remoteDataSource});

  @override
  Future<ChatUsersModel?> getChatUsers() async {
    try {
      return await remoteDataSource.getChatUsers();
    } catch (e) {
      throw Exception('Failed to fetch chat users');
    }
  }
}
