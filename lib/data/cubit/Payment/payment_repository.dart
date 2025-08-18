// import 'package:taxconsultation/data/remote_data_source.dart';
//
// import '../../../model/CreatePaymentModel.dart';
// import '../../../model/VerifyPaymentModel.dart';
//
// abstract class PaymentRepository {
//   Future<CreatePaymentModel?> createPayment(Map<String, dynamic> data);
//   Future<VerifyPaymentModel?> verifyPayment(Map<String, dynamic> data);
// }
//
// class PaymentRepositoryImpl implements PaymentRepository {
//   RemoteDataSource remoteDataSource;
//   PaymentRepositoryImpl({required this.remoteDataSource});
//   @override
//   Future<CreatePaymentModel?> createPayment(Map<String, dynamic> data) async {
//     return await remoteDataSource.createPayment(data);
//   }
//
//   @override
//   Future<VerifyPaymentModel?> verifyPayment(Map<String, dynamic> data) async {
//     return await remoteDataSource.verifyPayment(data);
//   }
// }
