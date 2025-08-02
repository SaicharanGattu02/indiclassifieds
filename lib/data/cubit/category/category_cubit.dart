import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/category/category_repository.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryStates> {
  CategoryRepository categoryRepository;
  CategoryCubit(this.categoryRepository) : super(CategoryInitially());

  Future<void> getCategory() async {
    emit(CategoryLoading());
    try {
      final response = await categoryRepository.getCategory();
      if (response != null && response.success == true) {
        emit(CategoryLoaded(response));
      } else {
        emit(CategoryFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}
