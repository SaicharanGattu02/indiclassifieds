import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/AdSuccessModel.dart';
import 'package:indiclassifieds/model/ProfileModel.dart';

abstract class ProfileRepo {
  Future<ProfileModel?> getProfileDetails();
  Future<AdSuccessModel?> updateProfileDetails(Map<String, dynamic> data);
}

class ProfileRepoImpl implements ProfileRepo {
  RemoteDataSource remoteDataSource;
  ProfileRepoImpl({required this.remoteDataSource});

  @override
  Future<ProfileModel?> getProfileDetails() async {
    return await remoteDataSource.getProfileDetails();
  }

  @override
  Future<AdSuccessModel?> updateProfileDetails(
    Map<String, dynamic> data,
  ) async {
    return await remoteDataSource.updateProfileDetails(data);
  }
}
