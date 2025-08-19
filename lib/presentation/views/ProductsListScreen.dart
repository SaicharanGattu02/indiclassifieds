import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/Components/CustomSnackBar.dart';
import 'package:indiclassifieds/data/cubit/Products/products_cubit.dart';
import 'package:indiclassifieds/utils/AppLogger.dart';
import '../../data/cubit/AddToWishlist/addToWishlistCubit.dart';
import '../../data/cubit/AddToWishlist/addToWishlistStates.dart';
import '../../data/cubit/Products/products_states.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/ProductCard.dart';

class ProductsListScreen extends StatefulWidget {
  final String subCategoryId;
  final String subCategoryname;
  const ProductsListScreen({
    super.key,
    required this.subCategoryId,
    required this.subCategoryname,
  });

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial load
    context.read<ProductsCubit>().getProducts(
      subCategoryId: widget.subCategoryId,
    );
    // Pagination on scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductsCubit>().getMoreProducts(widget.subCategoryId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final bgColor = ThemeHelper.backgroundColor(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.subCategoryname,
          style: AppTextStyles.headlineSmall(textColor),
        ),
        actions: [
          Icon(Icons.tune, color: textColor),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocListener<AddToWishlistCubit, AddToWishlistStates>(
        listener: (context, state) {
          if (state is AddToWishlistLoaded) {
            // API returned success → update ProductsCubit
            context.read<ProductsCubit>().updateWishlistStatus(
              state.product_id,
              state.addToWishlistModel.liked ?? false,
            );
          } else if (state is AddToWishlistFailure) {
            CustomSnackBar1.show(context, state.error);
          }
        },
        child: BlocBuilder<ProductsCubit, ProductsStates>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductsFailure) {
              return Center(child: Text(state.error));
            } else if (state is ProductsLoaded ||
                state is ProductsLoadingMore) {
              final productsModel = (state as dynamic).productsModel;
              final products = productsModel.products ?? [];
              final hasNextPage = (state as dynamic).hasNextPage;

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == products.length) {
                            // Loader at bottom for pagination
                            return hasNextPage
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }

                          final product = products[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProductCard(
                              products: product,
                              onWishlistToggle: () {
                                if (product.id != null) {
                                  context
                                      .read<AddToWishlistCubit>()
                                      .addToWishlist(product.id!);
                                }
                              },
                            ),
                          );
                        },
                        childCount: products.length + 1, // +1 for loader
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
