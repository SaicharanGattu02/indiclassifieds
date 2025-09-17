import 'package:indiclassifieds/model/SendOtpModel.dart';
import 'package:indiclassifieds/model/VerifyOtpModel.dart';

abstract class LogInWithMobileState {}

class LogInWithMobileInitial extends LogInWithMobileState {}

class LogInwithMobileLoading extends LogInWithMobileState {}

class verifyWithMobileLoading extends LogInWithMobileState {}

class LogInwithMobileSuccess extends LogInWithMobileState {
  final SendOtpModel sendOtpModel;
  LogInwithMobileSuccess(this.sendOtpModel);
}

class LogInwithEmailSuccess extends LogInWithMobileState {
  final SendOtpModel sendOtpModel;
  LogInwithEmailSuccess(this.sendOtpModel);
}

class verifyMobileSuccess extends LogInWithMobileState {
  final VerifyOtpModel verifyOtpModel;
  verifyMobileSuccess(this.verifyOtpModel);
}

class verifyEmailSuccess extends LogInWithMobileState {
  final VerifyOtpModel verifyOtpModel;
  verifyEmailSuccess(this.verifyOtpModel);
}

class TestLoginSuccessState extends LogInWithMobileState {
  final VerifyOtpModel verifyOtpModel;
  TestLoginSuccessState(this.verifyOtpModel);
}

class LogInwithMobileFailure extends LogInWithMobileState {
  final String error;
  LogInwithMobileFailure(this.error);
}

class OtpVerifyFailure extends LogInWithMobileState {
  final String error;
  OtpVerifyFailure(this.error);
}
