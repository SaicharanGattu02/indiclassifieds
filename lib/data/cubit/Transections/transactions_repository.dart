import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/AddToWishlistModel.dart';
import 'package:indiclassifieds/model/SubcategoryProductsModel.dart';

import '../../../model/TransectionHistoryModel.dart';
import '../../../model/WishlistModel.dart';

abstract class TransactionsRepository {
  Future<TransectionHistoryModel?> getTransactions(int page);
}

class TransactionsImpl implements TransactionsRepository {
  RemoteDataSource remoteDataSource;
  TransactionsImpl({required this.remoteDataSource});

  @override
  Future<TransectionHistoryModel?> getTransactions(int page) async {
    return await remoteDataSource.getTransections(page);
  }
}
