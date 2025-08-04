import 'package:indiclassifieds/model/SendOtpModel.dart';
import 'package:indiclassifieds/model/VerifyOtpModel.dart';
import '../../remote_data_source.dart';


abstract class LogInWithMobileRepository {
  Future<SendOtpModel?> SendMobileOtp(Map<String, dynamic> data);
  Future<VerifyOtpModel?> verifyMobileOtp(Map<String, dynamic> data);
}

class LogInMobileRepositoryImpl implements LogInWithMobileRepository {
  final RemoteDataSource remoteDataSource;
  LogInMobileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SendOtpModel?> SendMobileOtp(Map<String, dynamic> data) async {
    return await remoteDataSource.sendMobileOTP(data);
  }

  Future<VerifyOtpModel?> verifyMobileOtp(Map<String, dynamic> data) async {
    return await remoteDataSource.verifyMobileOTP(data);
  }
}
