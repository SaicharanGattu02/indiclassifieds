import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/Profile/profile_repo.dart';
import 'package:indiclassifieds/data/cubit/Profile/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileInitially());

  Future<void> getProfileDetails() async {
    emit(ProfileLoading());
    try {
      final response = await profileRepo.getProfileDetails();
      if (response != null && response.success == true) {
        emit(ProfileLoaded(response));
      } else {
        emit(ProfileFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
