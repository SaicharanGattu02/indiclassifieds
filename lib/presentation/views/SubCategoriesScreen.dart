import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/data/cubit/subCategory/sub_category_state.dart';
import 'package:indiclassifieds/model/CategoryModel.dart';
import '../../data/cubit/subCategory/sub_category_cubit.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/spinkittsLoader.dart';
import '../../widgets/CommonLoader.dart';

class SubCategoriesScreen extends StatefulWidget {
  final CategoriesList? categoriesList;
  const SubCategoriesScreen({super.key, required this.categoriesList});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubCategoryCubit>().getSubCategory(
      widget.categoriesList?.categoryId.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bgColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          widget.categoriesList?.name ?? "",
          style: AppTextStyles.headlineSmall(textColor),
        ),
      ),
      body: BlocBuilder<SubCategoryCubit, SubCategoryStates>(
        builder: (context, state) {
          if (state is SubCategoryLoading) {
            return Center(child: DottedProgressWithLogo());
          } else if (state is SubCategoryLoaded) {
            final subcategories = state.subCategoryModel.subcategories;
            return CustomScrollView(
              slivers: [
                // // ----- Banner -----
                // SliverToBoxAdapter(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 16),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(8),
                //       child: Image.asset(
                //         'assets/images/banner1.png',
                //         fit: BoxFit.cover,
                //         height: 150,
                //         width: double.infinity,
                //       ),
                //     ),
                //   ),
                // ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = subcategories?[index];
                      return InkWell(
                        onTap: () {
                          context.push(
                            "/products_list?subCategoryname=${item?.name ?? ""}&sub_categoryId=${item?.subCategoryId ?? ""}",
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    imageUrl: item?.image ?? "",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: spinkits.getSpinningLinespinkit(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8),
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
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item?.name ?? "",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium(textColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: subcategories?.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                  ),
                ),

                // ----- Bottom Spacing -----
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            );
          } else {
            return Center(child: Text("No data Found"));
          }
        },
      ),
    );
  }
}
