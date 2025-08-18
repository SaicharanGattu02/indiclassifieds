import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/Products/products_repository.dart';
import 'package:indiclassifieds/data/cubit/Products/products_states.dart';

import '../../../model/SubcategoryProductsModel.dart';

class ProductsCubit extends Cubit<ProductsStates> {
  final ProductsRepo productsRepo;
  ProductsCubit(this.productsRepo) : super(ProductsInitially());

  SubcategoryProductsModel productsModel = SubcategoryProductsModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  /// Initial fetch (reset to page 1)
  Future<void> getProducts(String subCategoryId) async {
    emit(ProductsLoading());
    _currentPage = 1;
    try {
      final response = await productsRepo.getProducts(
        subCategoryId,
        _currentPage, // 👈 pass page number
      );

      if (response != null && response.success == true) {
        productsModel = response;
        _hasNextPage = response.settings?.nextPage ?? false;

        emit(ProductsLoaded(productsModel, _hasNextPage));
      } else {
        emit(ProductsFailure(response?.message ?? "Failed to load products"));
      }
    } catch (e) {
      emit(ProductsFailure(e.toString()));
    }
  }

  /// Load more products (pagination)
  Future<void> getMoreProducts(String subCategoryId) async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;

    emit(ProductsLoadingMore(productsModel, _hasNextPage));

    try {
      final newData = await productsRepo.getProducts(
        subCategoryId,
        _currentPage, // 👈 pass next page
      );

      if (newData != null && newData.products?.isNotEmpty == true) {
        final combinedData = List<Products>.from(productsModel.products ?? [])
          ..addAll(newData.products!);

        productsModel = SubcategoryProductsModel(
          success: newData.success,
          message: newData.message,
          products: combinedData,
          settings: newData.settings,
        );

        _hasNextPage = newData.settings?.nextPage ?? false;

        emit(ProductsLoaded(productsModel, _hasNextPage));
      }
    } catch (e) {
      print("Products pagination error: $e");
    } finally {
      _isLoadingMore = false;
    }
  }

  void updateWishlistStatus(int productId, bool isLiked) {
    final updatedProducts = productsModel.products?.map((p) {
      if (p.id == productId) {
        return p.copyWith(isFavorited: isLiked);
      }
      return p;
    }).toList();

    productsModel = productsModel.copyWith(products: updatedProducts);
    emit(ProductsLoaded(productsModel, _hasNextPage));
  }
}
