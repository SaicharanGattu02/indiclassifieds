import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/theme/app_colors.dart';
import 'package:indiclassifieds/widgets/CommonTextField.dart';

import '../../data/cubit/category/category_cubit.dart';
import '../../data/cubit/category/category_state.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/media_query_helper.dart';
import '../../utils/spinkittsLoader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> topBanners = [
    {'image': 'assets/images/banner.png', 'url': 'assets/images/banner.png'},
  ];
  int currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryCubit>().getCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDarkMode = ThemeHelper.isDarkMode(context);
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                suffixIcon: Icon(Icons.mic, color: AppColors.primary),
                prefixIcon: Icon(Icons.search, color: Color(0xff6B72820)),
                hint: 'Search products, brands, .....',
                color: textColor,
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
                items: topBanners.map((banner) {
                  return InkWell(
                    // onTap: () => _launchUrl(banner['url']!),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          banner["image"]!,
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
                  topBanners.length,
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(2, 12, 2, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'assets/images/findInvestor.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Find Investor",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.titleSmall(textColor)
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Color(
                                      isDarkMode ? 0xffD7E4FF : 0xff374151,
                                    ),
                                  ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "144",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelSmall(textColor)
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Color(
                                      isDarkMode ? 0xffB5B5B5 : 0xff6B7280,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      );
                    }, childCount: 4),
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
              BlocBuilder<CategoryCubit, CategoryStates>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CategoryLoaded) {
                    final categories = state.categoryModel.data;
                    return CustomScrollView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.3,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final categoryItem = categories![index];
                            return InkResponse(
                              onTap: () {
                                context.push("/sub_categories?");
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
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(0xffF8FAFE),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: CachedNetworkImage(
                                          imageUrl: categoryItem.image ?? "",
                                          fit: BoxFit.cover,
                                          width: SizeConfig.screenWidth * 0.2,
                                          height:
                                              SizeConfig.screenHeight * 0.06,
                                          placeholder: (context, url) => Center(
                                            child: spinkits
                                                .getSpinningLinespinkit(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Color(0xffF8FAFE),
                                                ),
                                                child:  Icon(
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
                                      categoryItem.name ?? "Un Known",
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.titleSmall(textColor)
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Color(
                                              isDarkMode
                                                  ? 0xffD7E4FF
                                                  : 0xff374151,
                                            ),
                                          ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      categoryItem.noOfCounts.toString()??"0",
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.labelSmall(textColor)
                                          .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Color(
                                          isDarkMode ? 0xffB5B5B5 : 0xff6B7280,
                                        ),
                                      ),
                                    ),
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
                          }, childCount: categories?.length ?? 0),
                        ),
                      ],
                    );
                  } else if (state is CategoryFailure) {
                    return Center(child: Text(state.error ?? ""));
                  }
                  return Center(child: Text("No Data"));
                },
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
                        color: Color(isDarkMode ? 0xffDDDDDD : 0xff222222),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(
                                isDarkMode ? 0xff0D0D0D : 0xffFFFFFF,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    isDarkMode ? 0xffffffff : 0x1A000000,
                                  ),
                                  offset: Offset(0, 2), // x, y
                                  blurRadius: 5,
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.asset(
                                      width: 120,
                                      height: 120,
                                      'assets/images/product.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "₹1,899.99",
                                  style: AppTextStyles.titleLarge(textColor)
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Peloton Bike+ - With rotating screen and accessories",
                                  style: AppTextStyles.labelLarge(textColor)
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Color(
                                          isDarkMode ? 0xffB5B5B5 : 0xff6B7280,
                                        ),
                                      ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  spacing: 3,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Color(0xff6B7280),
                                    ),
                                    Text(
                                      "kavali",
                                      style: AppTextStyles.labelSmall(textColor)
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff6B7280),
                                          ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "• 2 days ago",
                                      style: AppTextStyles.labelSmall(textColor)
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff6B7280),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: -2,
                            top: 14,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.5,
                                ),
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12), // adjust as needed
                              ),
                              onPressed: () {},
                              child: Icon(Icons.favorite, color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }, childCount: 4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
