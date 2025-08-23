import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/Banners/banner_states.dart';
import 'package:indiclassifieds/data/cubit/Categories/categories_cubit.dart';
import 'package:indiclassifieds/data/cubit/NewCategories/new_categories_cubit.dart';
import 'package:indiclassifieds/data/cubit/NewCategories/new_categories_states.dart';
import 'package:indiclassifieds/data/cubit/Products/products_cubit.dart';
import 'package:indiclassifieds/data/cubit/Products/products_states.dart';
import 'package:indiclassifieds/model/BannersModel.dart';
import 'package:indiclassifieds/model/SubcategoryProductsModel.dart';
import '../../../model/CategoryModel.dart';
import '../Banners/banner_cubit.dart';
import '../Categories/categories_states.dart';
import '../Products/Product_cubit1.dart';
import '../Products/products_state1.dart';
import 'DashboardState.dart';

class DashboardCubit extends Cubit<DashBoardState> {
  final BannerCubit bannersCubit;
  final CategoriesCubit categoryCubit;
  final NewCategoriesCubit newCategoriesCubit;
  final ProductsCubit1 productsCubit;

  DashboardCubit({
    required this.bannersCubit,
    required this.categoryCubit,
    required this.productsCubit,
    required this.newCategoriesCubit,
  }) : super(DashBoardInitially());

  Future<void> fetchDashboard() async {
    emit(DashBoardLoading());

    BannersModel? bannerModel;
    CategoryModel? categoryModel;
    CategoryModel? newcategoryModel;
    SubcategoryProductsModel? subcategoryProductsModel;

    try {
      try {
        await bannersCubit.getBanners();
        final state = bannersCubit.state;
        if (state is BannerLoaded) {
          bannerModel = state.bannersModel;
        } else if (state is BannerFailure) {}
      } catch (e) {}

      // --- Fetch categories ---
      try {
        await categoryCubit.getCategories();
        final state = categoryCubit.state;
        if (state is CategoriesLoaded) {
          categoryModel = state.categoryModel;
        } else if (state is CategoriesFailure) {}
      } catch (e) {}

      // --- Fetch new categories ---
      try {
        await newCategoriesCubit.getNewCategories();
        final state = newCategoriesCubit.state;
        if (state is NewCategoryLoaded) {
          newcategoryModel = state.NewcategoryModel;
        } else if (state is NewCategoryFailure) {}
      } catch (e) {}

      // --- Fetch products ---
      try {
        await productsCubit.getProducts();
        final state = productsCubit.state;
        if (state is Products1Loaded) {
          subcategoryProductsModel = state.productsModel;
        } else if (state is ProductsFailure) {}
      } catch (e) {}

      // --- Emit result ---
      if (bannerModel != null || categoryModel != null) {
        emit(
          DashBoardLoaded(
            bannersModel: bannerModel,
            NewcategoryModel: newcategoryModel,
            categoryModel: categoryModel,
            subcategoryProductsModel: subcategoryProductsModel,
          ),
        );
      } else {
        emit(DashBoardFailure('All API calls failed.'));
      }
    } catch (e) {
      emit(DashBoardFailure('Dashboard error: ${e.toString()}'));
    }
  }
}
