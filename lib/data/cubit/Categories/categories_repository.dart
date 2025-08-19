import 'package:indiclassifieds/data/remote_data_source.dart';
import 'package:indiclassifieds/model/CategoryModel.dart';

abstract class CategoriesRepo {
  Future<CategoryModel?> getCategories();
  Future<CategoryModel?> getNewCategories();
}

class CategoriesRepoImpl implements CategoriesRepo {
  RemoteDataSource remoteDataSource;
  CategoriesRepoImpl({required this.remoteDataSource});

  @override
  Future<CategoryModel?> getCategories() async {
    return await remoteDataSource.getCategory();
  }

  @override
  Future<CategoryModel?> getNewCategories() async {
    return await remoteDataSource.getNewCategory();
  }
}
