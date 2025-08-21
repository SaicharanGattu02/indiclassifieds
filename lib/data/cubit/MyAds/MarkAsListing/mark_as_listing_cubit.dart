import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/MyAds/MarkAsListing/mark_as_listing_state.dart';
import '../my_ads_repo.dart';

class MarkAsListingCubit extends Cubit<MarkAsListingState> {
  MyAdsRepo myAdsRepo;
  MarkAsListingCubit(this.myAdsRepo) : super(MarkAsListingInitially());

  Future<void> markAsSold(int id) async {
    emit(MarkAsListingLoading());
    try {
      final response = await myAdsRepo.markAsSold(id);
      if (response != null && response.success == true) {
        emit(MarkAsListingSuccess(response));
      } else {
        emit(MarkAsListingFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(MarkAsListingFailure(e.toString()));
    }
  }

  Future<void> markAsDelete(int id) async {
    emit(MarkAsListingLoading());
    try {
      final response = await myAdsRepo.markAsDelete(id);
      if (response != null && response.success == true) {
        emit(MarkAsListingDeleted(response));
      } else {
        emit(MarkAsListingFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(MarkAsListingFailure(e.toString()));
    }
  }

  Future<void> markAsUpdate(int id) async {
    emit(MarkAsListingLoading());
    try {
      final response = await myAdsRepo.markAsUpdate(id);
      if (response != null && response.success == true) {
        emit(MarkAsListingUpdateSuccess(response));
      } else {
        emit(MarkAsListingFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(MarkAsListingFailure(e.toString()));
    }
  }
  Future<void> removeImageOnListingAd(int id) async {
    emit(MarkAsListingLoading());
    try {
      final response = await myAdsRepo.removeImageOnListingAD(id);
      if (response != null && response.success == true) {
        emit(MarkAsListingUpdateSuccess(response));
      } else {
        emit(MarkAsListingFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(MarkAsListingFailure(e.toString()));
    }
  }
}
