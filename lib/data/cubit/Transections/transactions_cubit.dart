import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/Transections/transactions_repository.dart';
import 'package:indiclassifieds/data/cubit/Transections/transactions_states.dart';
import 'package:indiclassifieds/model/TransectionHistoryModel.dart';


class TransactionCubit extends Cubit<TransactionsStates> {
  final TransactionsRepository transactionRepository;
  TransactionCubit(this.transactionRepository) : super(TransactionsInitially());

  TransectionHistoryModel transectionHistoryModel = TransectionHistoryModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;


  Future<void> getTransactions() async {
    emit(TransactionsLoading());
    _currentPage = 1;

    try {
      final response = await transactionRepository.getTransactions(_currentPage);

      if (response != null && response.success == true) {
        transectionHistoryModel = response;
        _hasNextPage = response.settings?.nextPage ?? false;

        emit(TransactionsLoaded(transectionHistoryModel, _hasNextPage));
      } else {
        emit(TransactionsFailure(response?.message ?? "Failed to load transactions"));
      }
    } catch (e) {
      emit(TransactionsFailure(e.toString()));
    }
  }


  Future<void> getMoreTransactions() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;

    emit(TransactionsLoadingMore(transectionHistoryModel, _hasNextPage));

    try {
      final newData = await transactionRepository.getTransactions(_currentPage);

      if (newData != null && newData.data?.formattedRows?.isNotEmpty == true) {
        // merge old + new rows
        final combinedRows = List<FormattedRows>.from(
          transectionHistoryModel.data?.formattedRows ?? [],
        )..addAll(newData.data!.formattedRows!);

        transectionHistoryModel = TransectionHistoryModel(
          success: newData.success,
          message: newData.message,
          data: Data(
            totalPayments: newData.data?.totalPayments,
            totalSuccess: newData.data?.totalSuccess,
            formattedRows: combinedRows,
          ),
          settings: newData.settings,
        );

        _hasNextPage = newData.settings?.nextPage ?? false;

        emit(TransactionsLoaded(transectionHistoryModel, _hasNextPage));
      }
    } catch (e) {
      print("Transaction pagination error: $e");
    } finally {
      _isLoadingMore = false;
    }
  }
}
