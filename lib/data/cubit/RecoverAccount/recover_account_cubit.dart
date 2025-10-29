import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:classifieds/data/cubit/RecoverAccount/recover_account_repository.dart';
import 'package:classifieds/data/cubit/RecoverAccount/recover_account_states.dart';

class RecoverAccountCubit extends Cubit<RecoverAccountStates> {
  RecoverAccountRepo recoverAccountRepo;
  RecoverAccountCubit(this.recoverAccountRepo)
    : super(RecoverAccountInitially());

  Future<void> recoverAccount(String id) async {
    emit(RecoverAccountLoading());
    try {
      final response = await recoverAccountRepo.recoverAccount(id);
      if (response != null && response.success == true) {
        emit(RecoverAccountLoaded(response));
      } else {
        emit(RecoverAccountFailure(response?.error ?? ""));
      }
    } catch (e) {
      emit(RecoverAccountFailure(e.toString()));
    }
  }
}
