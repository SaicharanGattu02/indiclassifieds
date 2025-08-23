import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/data/cubit/Wishlist/wishlist_cubit.dart';
import 'package:indiclassifieds/data/cubit/Wishlist/wishlist_states.dart';

import '../../Components/CustomSnackBar.dart';
import '../../data/cubit/AddToWishlist/addToWishlistCubit.dart';
import '../../data/cubit/AddToWishlist/addToWishlistStates.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/AppLogger.dart';
import '../../widgets/CommonLoader.dart';
import '../../widgets/ProductCard.dart';

class WishlistListScreen extends StatefulWidget {
  const WishlistListScreen({super.key});

  @override
  State<WishlistListScreen> createState() => _WishlistListScreenState();
}

class _WishlistListScreenState extends State<WishlistListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().getWishlist();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<WishlistCubit>().getMoreWishlist();
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
          'Favourites List',
          style: AppTextStyles.headlineSmall(textColor),
        ),
        actions: [
          GestureDetector(onTap: (){
    context.push('/filter');
    },child: Icon(Icons.tune, color: textColor)),
          const SizedBox(width: 16),
        ],
      ),

      body:  BlocListener<AddToWishlistCubit, AddToWishlistStates>(
        listener: (context, state) {
          if (state is AddToWishlistLoaded) {
            // API returned success → update ProductsCubit
            context.read<WishlistCubit>().updateWishlistStatus(
              state.product_id,
              state.addToWishlistModel.liked ?? false,
            );
          } else if (state is AddToWishlistFailure) {
            CustomSnackBar1.show(context, state.error);
          }
        },
        child: BlocBuilder<WishlistCubit, WishlistStates>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return Center(child:DottedProgressWithLogo());
            } else if (state is WishlistFailure) {
              return Center(child: Text(state.error));
            } else if (state is WishlistLoaded || state is WishlistLoadingMore) {
              final wishlistModel = (state as dynamic).wishlistModel;
              final products = wishlistModel.productslist ?? [];
              final hasNextPage = (state as dynamic).hasNextPage;

              if (products.isEmpty) {
                return Center(child: Text("No data"));
              }

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
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
                        AppLogger.info("${product.location}");
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ProductCard1(
                            productsList: product,
                            onWishlistToggle: () {
                              if (product.id != null) {
                                context.read<AddToWishlistCubit>().addToWishlist(
                                  product.id!,
                                );
                              }
                            },
                          ),
                        );
                      }, childCount: products.length + 1),
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
