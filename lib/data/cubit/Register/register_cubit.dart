import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/Register/register_repo.dart';
import 'package:indiclassifieds/data/cubit/Register/register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterRepo registerRepo;
  RegisterCubit(this.registerRepo) : super(RegisterInitially());

  Future<void> register(Map<String, dynamic> data) async {
    emit(RegisterLoading());
    try {
      final response = await registerRepo.register(data);
      if (response != null && response.success == true) {
        emit(RegisterLoaded(response));
      } else {
        emit(RegisterFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
