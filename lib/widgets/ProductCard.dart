import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/model/WishlistModel.dart';

import '../data/cubit/AddToWishlist/addToWishlistCubit.dart';
import '../model/SubcategoryProductsModel.dart';
import '../theme/AppTextStyles.dart';
import '../theme/ThemeHelper.dart';
import '../utils/spinkittsLoader.dart';

class ProductCard extends StatelessWidget {
  final Products products;
  final VoidCallback onWishlistToggle;
  const ProductCard({required this.products, required this.onWishlistToggle});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final cardColor = ThemeHelper.isDarkMode(context)
        ? Colors.grey[900]
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Image + Wishlist overlay
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Stack(
              children: [
                // Product Image
                CachedNetworkImage(
                  width: 120,
                  height: 120,
                  imageUrl: products.image ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    width: 120,
                    height: 120,
                    child: Center(child: spinkits.getSpinningLinespinkit()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 120,
                    height: 120,
                    color: const Color(0xffF8FAFE),
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Wishlist Icon (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: onWishlistToggle, // 👈 delegate action
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Color(0xff1677FF).withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        (products.isFavorited ?? false)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products.title ?? "",
                    style: AppTextStyles.titleMedium(textColor),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          products.location ?? "",
                          style: AppTextStyles.titleMedium(textColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "₹${products.price ?? ""}",
                    style: AppTextStyles.titleMedium(Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard1 extends StatelessWidget {
  final ProductsList productsList;
  final VoidCallback onWishlistToggle;
  const ProductCard1({required this.productsList, required this.onWishlistToggle});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final cardColor = ThemeHelper.isDarkMode(context)
        ? Colors.grey[900]
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Image + Wishlist overlay
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Stack(
              children: [
                // Product Image
                CachedNetworkImage(
                  width: 120,
                  height: 120,
                  imageUrl: productsList.image ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    width: 120,
                    height: 120,
                    child: Center(child: spinkits.getSpinningLinespinkit()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 120,
                    height: 120,
                    color: const Color(0xffF8FAFE),
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Wishlist Icon (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: onWishlistToggle, // 👈 delegate action
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Color(0xff1677FF).withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        (productsList.isFavorited ?? false)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productsList.title ?? "",
                    style: AppTextStyles.titleMedium(textColor),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          productsList.location ?? "",
                          style: AppTextStyles.titleMedium(textColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "₹${productsList.price ?? ""}",
                    style: AppTextStyles.titleMedium(Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}