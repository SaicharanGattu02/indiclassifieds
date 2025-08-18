
import 'package:indiclassifieds/model/AdSuccessModel.dart';

abstract class PostAdvertisementStates {}

class PostAdvertisementInitially extends PostAdvertisementStates {}

class PostAdvertisementLoading extends PostAdvertisementStates {}

class PostAdvertisementLoaded extends PostAdvertisementStates {
  AdSuccessModel adSuccessModel;
  PostAdvertisementLoaded(this.adSuccessModel);
}

class PostAdvertisementFailure extends PostAdvertisementStates {
  String error;
  PostAdvertisementFailure(this.error);
}
