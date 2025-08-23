import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/ChatMessagesModel.dart';

abstract class ChatMessagesRepository {
  Future<ChatMessagesModel?> getChatMessages(String user_id);
}

class ChatMessagesRepositoryImpl implements ChatMessagesRepository{
  RemoteDataSource remoteDataSource;
  ChatMessagesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ChatMessagesModel?> getChatMessages(String user_id) async{
    return  await remoteDataSource.getChatMessages(user_id);
  }
}