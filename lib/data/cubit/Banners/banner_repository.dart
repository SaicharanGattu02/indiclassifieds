import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/BannersModel.dart';

abstract class BannersRepository {
  Future<BannersModel?> getBanners();
}

class BannersRepositoryImpl implements BannersRepository {
  RemoteDataSource remoteDataSource;
  BannersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BannersModel?> getBanners() async {
    return await remoteDataSource.getBanners();
  }
}
