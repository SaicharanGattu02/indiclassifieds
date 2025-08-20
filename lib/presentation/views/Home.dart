import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/data/cubit/Dashboard/DashboardCubit.dart';
import 'package:indiclassifieds/data/cubit/Dashboard/DashboardState.dart';
import 'package:indiclassifieds/theme/app_colors.dart';
import 'package:intl/intl.dart';
import '../../data/cubit/Products/products_cubit.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/media_query_helper.dart';
import '../../utils/spinkittsLoader.dart';
import '../../widgets/CommonLoader.dart';
import '../../widgets/SimilarProductCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  void initState() {
    context.read<DashboardCubit>().fetchDashboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDarkMode = ThemeHelper.isDarkMode(context);
    final borderColor = ThemeHelper.isDarkMode(context)
        ? Colors.white12
        : Colors.black12;
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: SizeConfig.screenWidth * 0.16,
              fit: BoxFit.cover,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Color(isDarkMode ? 0xff171717 : 0xffF3F4F6),
              ),
              shape: WidgetStateProperty.all(CircleBorder()),
              padding: WidgetStateProperty.all(EdgeInsets.all(16)),
              minimumSize: WidgetStateProperty.all(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Icon(Icons.location_pin, color: Color(0xff4B5563)),
          ),
          FilledButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Color(isDarkMode ? 0xff171717 : 0xffF3F4F6),
              ),
              shape: WidgetStateProperty.all(CircleBorder()),
              padding: WidgetStateProperty.all(EdgeInsets.all(16)),
              minimumSize: WidgetStateProperty.all(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Icon(Icons.notifications_active, color: Color(0xff4B5563)),
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashBoardState>(
        builder: (context, state) {
          if (state is DashBoardLoading) {
            return Center(child:DottedProgressWithLogo());
          } else if (state is DashBoardLoaded) {
            final banner_data = state.bannersModel;
            final category_data = state.categoryModel;
            final new_category_data = state.NewcategoryModel;
            final products_data = state.subcategoryProductsModel;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.push("/search_screen");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Color(0xff6B72820),
                            ), // Prefix Icon
                            SizedBox(width: 8),
                            Text(
                              'Search products, brands, .....',
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: SizeConfig.screenHeight * 0.2,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        enableInfiniteScroll: true,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        autoPlay: true,
                        scrollDirection: Axis.horizontal,
                        pauseAutoPlayOnTouch: true,
                        aspectRatio: 1,
                      ),
                      items: banner_data?.data?.map((banner) {
                        return InkWell(
                          // onTap: () => _launchUrl(banner['url']!),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                banner.image ?? "",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banner_data?.data?.length ?? 0,
                        (index) => Container(
                          margin: EdgeInsets.all(3),
                          height: SizeConfig.screenHeight * 0.008,
                          width: currentIndex == index
                              ? SizeConfig.screenWidth * 0.025
                              : SizeConfig.screenWidth * 0.014,
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? AppColors.primary
                                : Color(0xff90A9D3),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "What's New",
                      style: AppTextStyles.titleLarge(textColor).copyWith(
                        fontWeight: FontWeight.w600,
                        color: Color(isDarkMode ? 0xffDDDDDD : 0xff222222),
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomScrollView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.9,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final new_categoryItem =
                                  new_category_data?.categoriesList![index];
                              return InkResponse(
                                onTap: () {
                                  context.push(
                                    '/sub_categories',
                                    extra:
                                        new_categoryItem, // pass the full object
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(2, 12, 2, 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Color(0xffF8FAFE),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                new_categoryItem?.image ?? "",
                                            fit: BoxFit.cover,
                                            width: SizeConfig.screenWidth * 0.2,
                                            height:
                                                SizeConfig.screenHeight * 0.04,
                                            placeholder: (context, url) =>
                                                Center(
                                                  child: spinkits
                                                      .getSpinningLinespinkit(),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: Color(0xffF8FAFE),
                                                  ),
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 6),
                                      Text(
                                        new_categoryItem?.name ?? "Un Known",
                                        textAlign: TextAlign.center,
                                        style:
                                            AppTextStyles.titleSmall(
                                              textColor,
                                            ).copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Color(
                                                isDarkMode
                                                    ? 0xffD7E4FF
                                                    : 0xff374151,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount:
                                new_category_data?.categoriesList?.length,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Categories",
                      style: AppTextStyles.titleLarge(textColor).copyWith(
                        fontWeight: FontWeight.w600,
                        color: Color(isDarkMode ? 0xffDDDDDD : 0xff222222),
                      ),
                    ),
                    SizedBox(height: 8),
                    CustomScrollView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.85,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final categoryItem =
                                  category_data?.categoriesList![index];
                              return InkResponse(
                                onTap: () {
                                  context.push(
                                    '/sub_categories',
                                    extra: categoryItem, // pass the full object
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(2, 12, 2, 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Color(0xffF8FAFE),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: categoryItem?.image ?? "",
                                            fit: BoxFit.cover,
                                            width: SizeConfig.screenWidth * 0.2,
                                            height:
                                                SizeConfig.screenHeight * 0.04,
                                            placeholder: (context, url) =>
                                                Center(
                                                  child: spinkits
                                                      .getSpinningLinespinkit(),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    color: Color(0xffF8FAFE),
                                                  ),
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 6),
                                      Text(
                                        categoryItem?.name ?? "Un Known",
                                        textAlign: TextAlign.center,
                                        style:
                                            AppTextStyles.titleSmall(
                                              textColor,
                                            ).copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Color(
                                                isDarkMode
                                                    ? 0xffD7E4FF
                                                    : 0xff374151,
                                              ),
                                            ),
                                      ),
                                      // SizedBox(height: 2),
                                      // Text(
                                      //   categoryItem.noOfCounts.toString()??"0",
                                      //   textAlign: TextAlign.center,
                                      //   style: AppTextStyles.labelSmall(textColor)
                                      //       .copyWith(
                                      //     fontWeight: FontWeight.w400,
                                      //     color: Color(
                                      //       isDarkMode ? 0xffB5B5B5 : 0xff6B7280,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 2),
                                      // Text(
                                      //   categoryItem.name??"Un Known",
                                      //   textAlign: TextAlign.center,
                                      //   style: AppTextStyles.labelSmall(textColor)
                                      //       .copyWith(
                                      //         fontWeight: FontWeight.w400,
                                      //         color: Color(
                                      //           isDarkMode
                                      //               ? 0xffB5B5B5
                                      //               : 0xff6B7280,
                                      //         ),
                                      //       ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount:
                                category_data?.categoriesList?.length ?? 0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Products",
                          style: AppTextStyles.titleLarge(textColor).copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(isDarkMode ? 0xffDDDDDD : 0xff222222),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "See All",
                            style: AppTextStyles.bodyMedium(textColor).copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(
                                isDarkMode ? 0xffDDDDDD : 0xff222222,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    CustomScrollView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.95,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final p = products_data?.products?[index];
                            final title = (p?.title ?? "—").trim();
                            final price = "₹${_formatINR(p?.price)}";
                            final location = (p?.location ?? "").trim();
                            final img = p?.image;
                            return SimilarProductCard(
                              title: title,
                              price: price,
                              location: location,
                              imageUrl: img,
                              isLiked: p?.isFavorited ?? false,
                              onLikeToggle: () {
                                if (p?.id != null) {
                                  final newVal = !(p?.isFavorited ?? false);
                                  context
                                      .read<ProductsCubit>()
                                      .updateWishlistStatus(p?.id ?? 0, newVal);
                                }
                              },
                              onTap: () {
                                context.pushReplacement(
                                  "/products_details?listingId=${p?.id}&subcategory_id=${p?.subCategory}",
                                );
                              },
                              borderColor: borderColor,
                            );
                          }, childCount: 4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (state is DashBoardFailure) {
            return Center(child: Text("No Data Found!"));
          }
          return Center(child: Text("No Data Found!"));
        },
      ),
    );
  }

  // ===== Utility formatting =====

  String _formatINR(String? price) {
    final val = double.tryParse(price ?? "");
    if (val == null) return "0";
    final f = NumberFormat.currency(
      locale: 'en_IN',
      symbol: "",
      decimalDigits: 0,
    );
    return f.format(val);
  }
}
