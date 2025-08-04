import 'package:indiclassifieds/model/SelectCityModel.dart';
import '../../remote_data_source.dart';

abstract class SelectCityRepository {
  Future<SelectCityModel?> getCity(int state_id, String search);
}

class SelectCityImpl implements SelectCityRepository {
  RemoteDataSource remoteDataSource;
  SelectCityImpl({required this.remoteDataSource});
  @override
  Future<SelectCityModel?> getCity(int state_id, String search) async {
    return await remoteDataSource.getCity(state_id, search);
  }
}
