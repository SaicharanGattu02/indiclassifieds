import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/Banners/banner_states.dart';
import 'package:indiclassifieds/data/cubit/Categories/categories_cubit.dart';
import 'package:indiclassifieds/data/cubit/Products/products_cubit.dart';
import 'package:indiclassifieds/data/cubit/Products/products_states.dart';
import 'package:indiclassifieds/model/BannersModel.dart';
import 'package:indiclassifieds/model/SubcategoryProductsModel.dart';
import '../../../model/CategoryModel.dart';
import '../Banners/banner_cubit.dart';
import '../Categories/categories_states.dart';
import 'DashboardState.dart';

class DashboardCubit extends Cubit<DashBoardState> {
  final BannerCubit bannersCubit;
  final CategoriesCubit categoryCubit;
  final ProductsCubit productsCubit;

  DashboardCubit({
    required this.bannersCubit,
    required this.categoryCubit,
    required this.productsCubit,
  }) : super(DashBoardInitially());

  Future<void> fetchDashboard() async {
    emit(DashBoardLoading());

    BannersModel? bannerModel;
    CategoryModel? categoryModel;
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

      // --- Fetch products ---
      try {
        await productsCubit.getProducts("");
        final state = productsCubit.state;
        if (state is ProductsLoaded) {
          subcategoryProductsModel = state.productsModel;
        } else if (state is ProductsFailure) {}
      } catch (e) {}

      // --- Emit result ---
      if (bannerModel != null || categoryModel != null) {
        emit(
          DashBoardLoaded(
            bannersModel: bannerModel,
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
