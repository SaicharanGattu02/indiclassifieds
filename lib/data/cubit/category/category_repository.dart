
import 'package:indiclassifieds/model/CategoryModel.dart';

import '../../remote_data_source.dart';

abstract class CategoryRepository {
  Future<CategoryModel?> getCategory();
}

class CategoryRepositoryImpl implements CategoryRepository {
  RemoteDataSource remoteDataSource;
  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CategoryModel?> getCategory() async {
    return await remoteDataSource.getCategory();
  }
}
