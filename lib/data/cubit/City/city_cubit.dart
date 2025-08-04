import 'package:flutter_bloc/flutter_bloc.dart';
import 'city_repository.dart';
import 'city_state.dart';

class SelectCityCubit extends Cubit<SelectCity> {
  SelectCityRepository selectCityRepository;
  SelectCityCubit(this.selectCityRepository) : super(SelectCityInitially());

  Future<void> getSelectCity(int state_id, String search) async {
    emit(SelectCityLoading());
    try {
      final response = await selectCityRepository.getCity(state_id, search);
      if (response != null && response.success == true) {
        emit(SelectCityLoaded(response));
      } else {
        emit(SelectCityFailure("Failure To Load Data"));
      }
    } catch (e) {
      emit(SelectCityFailure(e.toString()));
    }
  }
}
