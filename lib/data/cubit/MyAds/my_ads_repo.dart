import 'package:indiclassifieds/data/remote_data_source.dart';

import '../../../model/MyAdsModel.dart';

abstract class MyAdsRepo {
  Future<MyAdsModel?> getMyAds(String type,int page);
}

class MyAdsRepoImpl implements MyAdsRepo {
  RemoteDataSource remoteDataSource;
  MyAdsRepoImpl({required this.remoteDataSource});
  @override
  Future<MyAdsModel?> getMyAds(String type,int page) async {
    return await remoteDataSource.getMyAds(type,page);
  }
}
