import 'package:indiclassifieds/model/BannersModel.dart';
import 'package:indiclassifieds/model/SubcategoryProductsModel.dart';

import '../../../model/CategoryModel.dart';

abstract class DashBoardState {}

class DashBoardInitially extends DashBoardState {}

class DashBoardLoading extends DashBoardState {}

class DashBoardLoaded extends DashBoardState {
  final BannersModel? bannersModel;
  final CategoryModel? categoryModel;
  final SubcategoryProductsModel? subcategoryProductsModel;

  DashBoardLoaded({
    this.bannersModel,
    this.categoryModel,
    this.subcategoryProductsModel,
  });
}

class DashBoardFailure extends DashBoardState {
  final String error;
  DashBoardFailure(this.error);
}
