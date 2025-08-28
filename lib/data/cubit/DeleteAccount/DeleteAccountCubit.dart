import 'package:flutter_bloc/flutter_bloc.dart';

import 'DeleteAccountRepository.dart';
import 'DeleteAccountStates.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountStates> {
  DeleteAccountRepo deleteAccountRepo;
  DeleteAccountCubit(this.deleteAccountRepo) : super(DeleteAccountInitially());

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    try {
      final response = await deleteAccountRepo.deleteAccount();
      if (response != null && response.success == true) {
        emit(DeleteAccountLoaded(response));
      } else {
        emit(DeleteAccountFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(DeleteAccountFailure(e.toString()));
    }
  }
}
