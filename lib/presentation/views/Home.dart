import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/data/cubit/Dashboard/DashboardCubit.dart';
import 'package:indiclassifieds/data/cubit/Dashboard/DashboardState.dart';
import 'package:indiclassifieds/services/AuthService.dart';
import 'package:indiclassifieds/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/CustomSnackBar.dart';
import '../../data/cubit/AddToWishlist/addToWishlistCubit.dart';
import '../../data/cubit/AddToWishlist/addToWishlistStates.dart';
import '../../data/cubit/Location/location_cubit.dart';
import '../../data/cubit/Location/location_state.dart';
import '../../data/cubit/Products/Product_cubit1.dart';
import '../../data/cubit/Products/products_cubit.dart';
import '../../data/cubit/Products/products_state1.dart';
import '../../data/cubit/Products/products_states.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/media_query_helper.dart';
import '../../utils/spinkittsLoader.dart';
import '../../widgets/CommonLoader.dart';
import '../../widgets/SimilarProductCard.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentIndex = 0;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardCubit>().fetchDashboard();
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductsCubit>().getMoreProducts();
      }
    });
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => debugPrint('onStatus: $val'),
      onError: (val) => debugPrint('onError: $val'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _voiceText = val.recognizedWords;
          });

          if (val.finalResult) {
            setState(() => _isListening = false);
            if (_voiceText.isNotEmpty) {
              context.push("/search_screen", extra: _voiceText);
            }
          }
        },
        listenMode: stt.ListenMode.confirmation,
        localeId: 'en_IN', // You can adjust based on your audience
      );
    } else {
      debugPrint('Speech recognition not available');
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDarkMode = ThemeHelper.isDarkMode(context);
    final cardColor = ThemeHelper.cardColor(context);
    final borderColor = ThemeHelper.isDarkMode(context)
        ? Colors.white12
        : Colors.black12;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    SizeConfig.init(context);
    return FutureBuilder(
      future: AuthService.isGuest,
      builder: (context, asyncSnapshot) {
        final isGuest = asyncSnapshot.data ?? false;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: logo (fixed width)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/images/applogonew.png',
                    width: SizeConfig.screenWidth * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: SizeConfig.screenWidth * 0.15),
                // Right: takes remaining width, content aligned to end
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: BlocBuilder<LocationCubit, LocationState>(
                      builder: (context, state) {
                        if (state is! LocationLoaded)
                          return const SizedBox.shrink();
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              "assets/images/location.png",
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 6),
                            // Text will not push layout; it truncates with …
                            Flexible(
                              child: Text(
                                state.locationName,
                                style: AppTextStyles.bodyMedium(textColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // FilledButton(
              //   onPressed: () {},
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStateProperty.all(
              //       Color(isDarkMode ? 0xff171717 : 0xffF3F4F6),
              //     ),
              //     shape: WidgetStateProperty.all(CircleBorder()),
              //     padding: WidgetStateProperty.all(EdgeInsets.all(16)),
              //     minimumSize: WidgetStateProperty.all(Size.zero),
              //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //   ),
              //   child: Icon(Icons.location_pin, color: Color(0xff4B5563)),
              // ),
              // FilledButton(
              //   onPressed: () {},
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStateProperty.all(
              //       Color(isDarkMode ? 0xff171717 : 0xffF3F4F6),
              //     ),
              //     shape: WidgetStateProperty.all(CircleBorder()),
              //     padding: WidgetStateProperty.all(EdgeInsets.all(16)),
              //     minimumSize: WidgetStateProperty.all(Size.zero),
              //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //   ),
              //   child: Icon(Icons.notifications_active, color: Color(0xff4B5563)),
              // ),
            ],
          ),
          body: BlocBuilder<DashboardCubit, DashBoardState>(
            builder: (context, state) {
              if (state is DashBoardLoading) {
                return Center(child: DottedProgressWithLogo());
              } else if (state is DashBoardLoaded) {
                final banner_data = state.bannersModel;
                final category_data = state.categoryModel;
                final new_category_data = state.NewcategoryModel;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // InkWell(
                        //   onTap: () {
                        //     context.push("/search_screen");
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: 16,
                        //       vertical: 12,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: cardColor,
                        //       borderRadius: BorderRadius.circular(8),
                        //       border: Border.all(color: borderColor),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.search,
                        //           color: textColor,
                        //         ), // Prefix Icon
                        //         SizedBox(width: 8),
                        //         Text(
                        //           'Search products, brands, .....',
                        //           style: TextStyle(color: textColor),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            context.push("/search_screen");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                 Icon(Icons.search, color: textColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text('Search products, brands, .....',
                                    style: TextStyle(color: textColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _isListening ? _stopListening : _startListening,
                                  child: Icon(
                                    _isListening ? Icons.mic : Icons.mic_none,
                                    color: _isListening ? Colors.red : textColor,
                                  ),
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
                              onTap: () async {
                                final url = banner.linkUrl ?? "";
                                if (url.isNotEmpty &&
                                    await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Could not launch link"),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: banner.image ?? "",
                                      fit: BoxFit.cover,
                                      // placeholder: (context, url) => Center(
                                      //   child: spinkits
                                      //       .getSpinningLinespinkit(),
                                      // ),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    ),
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
                                    childAspectRatio: 0.8,
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
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Image container
                                        Container(
                                          height:
                                              SizeConfig.screenHeight * 0.05,
                                          width: SizeConfig.screenWidth * 0.25,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            color: isDarkMode
                                                ? Color(0xff111111)
                                                : Color(
                                                    0xffF8FAFE,
                                                  ), // placeholder color
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  new_categoryItem?.image ?? "",
                                              fit: BoxFit.cover,
                                              // placeholder: (context, url) =>
                                              //     Center(
                                              //       child: spinkits
                                              //           .getSpinningLinespinkit(),
                                              //     ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                          size: 40,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          new_categoryItem?.name ?? "Unknown",
                                          textAlign: TextAlign.center,
                                          style:
                                              AppTextStyles.titleSmall(
                                                textColor,
                                              ).copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontSize: 13,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                childCount:
                                    new_category_data?.categoriesList?.length,
                              ),
                            ),
                          ],
                        ),
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
                                    childAspectRatio: 1,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final categoryItem =
                                      category_data?.categoriesList![index];
                                  return InkResponse(
                                    onTap: () {
                                      context.push(
                                        '/sub_categories',
                                        extra: categoryItem,
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height:
                                              SizeConfig.screenHeight * 0.05,
                                          width: SizeConfig.screenWidth * 0.25,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            color: isDarkMode
                                                ? Color(0xff111111)
                                                : Color(
                                                    0xffF8FAFE,
                                                  ), // placeholder color
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  categoryItem?.image ?? "",
                                              fit: BoxFit.contain,
                                              // placeholder: (context, url) =>
                                              //     Center(
                                              //       child: spinkits
                                              //           .getSpinningLinespinkit(),
                                              //     ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                          size: 40,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 10),
                                        Text(
                                          categoryItem?.name ?? "Unknown",
                                          textAlign: TextAlign.center,
                                          style:
                                              AppTextStyles.titleSmall(
                                                textColor,
                                              ).copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontSize: 13,
                                              ),
                                        ),

                                        // Optional: Count or subtext
                                        // SizedBox(height: 4),
                                        // Text(
                                        //   categoryItem?.noOfCounts?.toString() ?? "0",
                                        //   style: AppTextStyles.labelSmall(textColor).copyWith(
                                        //     color: isDarkMode ? Color(0xffB5B5B5) : Color(0xff6B7280),
                                        //     fontWeight: FontWeight.w400,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  );
                                },
                                childCount:
                                    category_data?.categoriesList?.length ?? 0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        BlocBuilder<ProductsCubit, ProductsStates>(
                          builder: (context, state) {
                            if (state is ProductsLoaded ||
                                state is ProductsLoadingMore) {
                              final productsModel =
                                  (state as dynamic).productsModel;
                              final products = productsModel.products ?? [];
                              final hasNextPage =
                                  (state as dynamic).hasNextPage;

                              if (products.isEmpty) {
                                return SizedBox.shrink();
                              }

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Listings",
                                        style:
                                            AppTextStyles.titleLarge(
                                              textColor,
                                            ).copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Color(
                                                isDarkMode
                                                    ? 0xffDDDDDD
                                                    : 0xff222222,
                                              ),
                                            ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.push("/products_list");
                                        },
                                        child: Text(
                                          "See All",
                                          style:
                                              AppTextStyles.titleSmall(
                                                textColor,
                                              ).copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Color(
                                                  isDarkMode
                                                      ? 0xffDDDDDD
                                                      : 0xff222222,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
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
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            if (index == products.length) {
                                              if (hasNextPage) {
                                                context
                                                    .read<ProductsCubit>()
                                                    .getMoreProducts();
                                                return const Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox.shrink();
                                              }
                                            }
                                            final p = products[index];
                                            return BlocListener<
                                              AddToWishlistCubit,
                                              AddToWishlistStates
                                            >(
                                              listener: (context, wishlistState) {
                                                if (wishlistState
                                                    is AddToWishlistLoaded) {
                                                  context
                                                      .read<ProductsCubit>()
                                                      .updateWishlistStatus(
                                                        wishlistState
                                                            .product_id,
                                                        wishlistState
                                                                .addToWishlistModel
                                                                .liked ??
                                                            false,
                                                      );
                                                } else if (wishlistState
                                                    is AddToWishlistFailure) {
                                                  CustomSnackBar1.show(
                                                    context,
                                                    wishlistState.error,
                                                  );
                                                }
                                              },
                                              child: SimilarProductCard(
                                                title: p.title ?? "—",
                                                isFeatured:
                                                    p.featured_status ?? false,
                                                price:
                                                    "₹${_formatINR(p.price)}",
                                                location: p.location ?? "",
                                                imageUrl: p.image,
                                                isLiked: p.isFavorited ?? false,
                                                onLikeToggle: isGuest
                                                    ? () {
                                                        context.push("/login");
                                                      }
                                                    : () {
                                                        if (p.id != null) {
                                                          context
                                                              .read<
                                                                AddToWishlistCubit
                                                              >()
                                                              .addToWishlist(
                                                                p.id!,
                                                              );
                                                        }
                                                      },
                                                onTap: () async {
                                                  final shouldRefresh =
                                                      await context.push<bool>(
                                                        "/products_details?listingId=${p.id}&subcategory_id=${p.subCategory?.id}",
                                                      );
                                                  if (shouldRefresh == true) {
                                                    context
                                                        .read<DashboardCubit>()
                                                        .fetchDashboard();
                                                  }
                                                },
                                                borderColor: borderColor,
                                              ),
                                            );
                                          },
                                          // 🔹 +1 for loader slot
                                          childCount: products.length + 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        SizedBox(height: 18),
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
      },
    );
  }

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
