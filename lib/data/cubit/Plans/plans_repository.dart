import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/PlansModel.dart';

abstract class PlansRepository {
  Future<PlansModel?> getPlans();
}

class PlansRepositoryImpl implements PlansRepository {
  RemoteDataSource remoteDataSource;
  PlansRepositoryImpl({required this.remoteDataSource});
  @override
  Future<PlansModel?> getPlans() async {
    return await remoteDataSource.getPlans();
  }
}
