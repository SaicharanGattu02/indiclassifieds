import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Components/CustomSnackBar.dart';
import '../../data/cubit/AddToWishlist/addToWishlistCubit.dart';
import '../../data/cubit/AddToWishlist/addToWishlistStates.dart';
import '../../data/cubit/Products/Product_cubit2.dart';
import '../../data/cubit/Products/products_cubit.dart';
import '../../data/cubit/Products/products_state2.dart';
import '../../data/cubit/Products/products_states.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonLoader.dart';
import '../../widgets/CommonTextField.dart';
import '../../widgets/ProductCard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();
  Timer? _debounce; // Timer for debounce

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductsCubit>().getMoreProducts("");
      }
    });
    searchController.addListener(() {
      _onSearchChanged(searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Call API with the debounced query
      context.read<ProductsCubit2>().getProducts(search: query);
    });
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
        title: Text("Listings", style: AppTextStyles.headlineSmall(textColor)),
        actions: [
          GestureDetector(
            onTap: () {
              context.push('/filter');
            },
            child: Icon(Icons.tune, color: textColor),
          ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: TextFormField(
                controller: searchController,
                style: AppTextStyles.bodyLarge(textColor),
                decoration: InputDecoration(
                  hintText: "Search for products...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductsCubit2, ProductsStates2>(
                builder: (context, state) {
                  if (state is Products2Loading) {
                    return Center(child: DottedProgressWithLogo());
                  } else if (state is Products2Failure) {
                    return Center(child: Text(state.error));
                  } else if (state is Products2Loaded ||
                      state is Products2LoadingMore) {
                    final productsModel = (state as dynamic).productsModel;
                    final products = productsModel.products ?? [];
                    final hasNextPage = (state as dynamic).hasNextPage;

                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/nodata/no_data.png',
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Text(
                              'No Products Found!',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: ThemeHelper.textColor(context),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
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
          ],
        ),
      ),
    );
  }
}
