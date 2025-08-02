import 'package:indiclassifieds/model/CategoryModel.dart';

abstract class CategoryStates {}

class CategoryInitially extends CategoryStates {}

class CategoryLoading extends CategoryStates {}

class CategoryLoaded extends CategoryStates {
  CategoryModel categoryModel;
  CategoryLoaded(this.categoryModel);
}

class CategoryFailure extends CategoryStates {
  String error;
  CategoryFailure(this.error);
}
