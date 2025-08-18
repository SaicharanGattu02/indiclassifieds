import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/ProductDetailsModel.dart';

abstract class ProductDetailsRepo {
  Future<ProductDetailsModel?> getProductDetails(int id);
}

class ProductDetailsRepoImpl implements ProductDetailsRepo {
  RemoteDataSource remoteDataSource;
  ProductDetailsRepoImpl({required this.remoteDataSource});
  @override
  Future<ProductDetailsModel?> getProductDetails(int id) async {
    return await remoteDataSource.getProductDetails(id);
  }
}
