import 'package:flutter_bloc/flutter_bloc.dart';
import 'cars_ad_repo.dart';
import 'cars_ad_states.dart';

class PropertyAdCubit extends Cubit<CarsAdStates> {
  CarsAdRepository propertyAdRepository;
  PropertyAdCubit(this.propertyAdRepository) : super(CarsAdInitially());

  Future<void> postPropertyAd(Map<String, dynamic> data) async {
    emit(CarsAdLoading());
    try {
      final response = await propertyAdRepository.postCarsAd(data);
      if (response != null && response.success == true) {
        emit(CarsAdSuccess(response));
      } else {
        emit(CarsAdFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(CarsAdFailure(e.toString()));
    }
  }
}
