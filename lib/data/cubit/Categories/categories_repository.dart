import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/CategoryModel.dart';

abstract class CategoriesRepo {
  Future<CategoryModel?> getCategories();
}

class CategoriesRepoImpl implements CategoriesRepo {
  RemoteDataSource remoteDataSource;
  CategoriesRepoImpl({required this.remoteDataSource});

  @override
  Future<CategoryModel?> getCategories() async {
    return await remoteDataSource.getCategory();
  }
}
