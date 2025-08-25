import '../../../model/ChatUsersModel.dart';
import '../../remote_data_source.dart';

abstract class ChatUsersRepo {
  Future<ChatUsersModel?> getChatUsers(String query);
}

class ChatUsersRepoImpl implements ChatUsersRepo {
  final RemoteDataSource remoteDataSource;

  ChatUsersRepoImpl({required this.remoteDataSource});

  @override
  Future<ChatUsersModel?> getChatUsers(String query) async {
    try {
      return await remoteDataSource.getChatUsers(query);
    } catch (e) {
      throw Exception('Failed to fetch chat users');
    }
  }
}
