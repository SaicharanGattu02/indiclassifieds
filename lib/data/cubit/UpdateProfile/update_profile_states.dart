import 'package:indiclassifieds/model/AdSuccessModel.dart';

abstract class UpdateProfileStates {}

class UpdateProfileInitially extends UpdateProfileStates {}

class UpdateProfileLoading extends UpdateProfileStates {}

class UpdateProfileLoaded extends UpdateProfileStates {
  AdSuccessModel successModel;
  UpdateProfileLoaded(this.successModel);
}

class UpdateProfileFailure extends UpdateProfileStates {
  String error;
  UpdateProfileFailure(this.error);
}
