import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/Plans/plans_repository.dart';
import 'package:indiclassifieds/data/cubit/UserActivePlans/user_active_plans_states.dart';

class UserActivePlanCubit extends Cubit<UserActivePlanStates> {
  PlansRepository plansRepository;
  UserActivePlanCubit(this.plansRepository) : super(UserActivePlanInitially());

  Future<void> getUserActivePlans() async {
    emit(UserActivePlanLoading());
    try {
      final response = await plansRepository.getUserActivePlans();
      if (response != null && response.success == true) {
        emit(UserActivePlanLoaded(response));
      } else {
        emit(UserActivePlanFailure("User active plans loading failed"));
      }
    } catch (e) {
      emit(UserActivePlanFailure(e.toString()));
    }
  }
}
