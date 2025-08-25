import 'package:indiclassifieds/model/SubcategoryProductsModel.dart';

import '../../../model/TransectionHistoryModel.dart';
import '../../../model/WishlistModel.dart';

abstract class TransactionsStates {}

class TransactionsInitially extends TransactionsStates {}

class TransactionsLoading extends TransactionsStates {}

class TransactionsLoadingMore extends TransactionsStates {
  final TransectionHistoryModel wishlistModel;
  final bool hasNextPage;

  TransactionsLoadingMore(this.wishlistModel, this.hasNextPage);
}

class TransactionsLoaded extends TransactionsStates {
  final TransectionHistoryModel wishlistModel;
  final bool hasNextPage;

  TransactionsLoaded(this.wishlistModel, this.hasNextPage);
}

class TransactionsFailure extends TransactionsStates {
  final String error;
  TransactionsFailure(this.error);
}
