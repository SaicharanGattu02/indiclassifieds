import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/ChatMessagesModel.dart';

abstract class ChatMessagesRepository {
  Future<ChatMessagesModel?> getChatMessages(String user_id,int page);
}

class ChatMessagesRepositoryImpl implements ChatMessagesRepository{
  RemoteDataSource remoteDataSource;
  ChatMessagesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ChatMessagesModel?> getChatMessages(String user_id,int page) async{
    return  await remoteDataSource.getChatMessages(user_id,page);
  }
}