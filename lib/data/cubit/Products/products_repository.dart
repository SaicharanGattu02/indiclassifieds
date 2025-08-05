import 'package:indiclassifieds/data/remote_data_source.dart';

import '../../../model/SubcategoryProductsModel.dart';

abstract class ProductsRepo {
  Future<SubcategoryProductsModel?> getProducts(
    String sub_category_id,
      int page
  );
}

class ProductsRepoImpl implements ProductsRepo {
  RemoteDataSource remoteDataSource;
  ProductsRepoImpl({required this.remoteDataSource});

  @override
  Future<SubcategoryProductsModel?> getProducts(
    String sub_category_id,
      int page
  ) async {
    return await remoteDataSource.getProducts(sub_category_id,page);
  }
}
