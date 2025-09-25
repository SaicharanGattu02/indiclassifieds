import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_with_mobile_repository.dart';
import 'login_with_mobile_state.dart';

class LogInwithMobileCubit extends Cubit<LogInWithMobileState> {
  final LogInWithMobileRepository logInWithMobileRepository;
  LogInwithMobileCubit(this.logInWithMobileRepository)
    : super(LogInWithMobileInitial());

  Future<void> postLogInWithMobile(Map<String, dynamic> data) async {
    emit(LogInwithMobileLoading());
    try {
      final response = await logInWithMobileRepository.SendMobileOtp(data);
      if (response != null && response.success == true) {
        emit(LogInwithMobileSuccess(response));
      } else {
        emit(LogInwithMobileFailure("${response?.message ?? ''}"));
      }
    } catch (e) {
      emit(LogInwithMobileFailure(e.toString()));
    }
  }

  Future<void> verifyLoginOtp(Map<String, dynamic> data) async {
    emit(verifyWithMobileLoading());
    try {
      final response = await logInWithMobileRepository.verifyMobileOtp(data);
      if (response != null) {
        emit(verifyMobileSuccess(response));
      } else {
        emit(OtpVerifyFailure("${response?.message ?? ''}"));
      }
    } catch (e) {
      emit(OtpVerifyFailure(e.toString()));
    }
  }

  Future<void> postLogInWithEmail(Map<String, dynamic> data) async {
    emit(LogInwithMobileLoading());
    try {
      final response = await logInWithMobileRepository.SendEmailOtp(data);
      if (response != null && response.success == true) {
        emit(LogInwithEmailSuccess(response));
      } else {
        emit(LogInwithMobileFailure("${response?.message ?? ''}"));
      }
    } catch (e) {
      emit(LogInwithMobileFailure(e.toString()));
    }
  }

  Future<void> verifyEmailLoginOtp(Map<String, dynamic> data) async {
    emit(verifyWithMobileLoading());
    try {
      final response = await logInWithMobileRepository.verifyEmailOtp(data);
      if (response != null && response.success == true) {
        emit(verifyEmailSuccess(response));
      } else {
        emit(OtpVerifyFailure("${response?.message ?? ''}"));
      }
    } catch (e) {
      emit(OtpVerifyFailure(e.toString()));
    }
  }

  Future<void> postTestLogin(Map<String, dynamic> data) async {
    emit(LogInwithMobileLoading());
    try {
      final response = await logInWithMobileRepository.byPassLogin(data);
      if (response != null && response.success == true) {
        emit(TestLoginSuccessState(response));
      } else {
        emit(LogInwithMobileFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(
        LogInwithMobileFailure(
          "An error occurred while logging in. Please check your network connection and try again.",
        ),
      );
    }
  }
}
