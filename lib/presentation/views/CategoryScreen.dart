import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/data/cubit/Categories/categories_states.dart';
import 'package:indiclassifieds/utils/color_constants.dart';
import '../../data/cubit/Categories/categories_cubit.dart';
import '../../data/cubit/PostCategories/categories_cubit.dart';
import '../../data/cubit/PostCategories/categories_states.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/spinkittsLoader.dart';
import '../../widgets/CommonLoader.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostCategoriesCubit>().getPostCategories();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bgColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);
    var height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What are you posting?',
              style: AppTextStyles.headlineMedium(textColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Select a category to continue',
              style: AppTextStyles.bodyMedium(Colors.grey),
            ),
            const SizedBox(height: 20),
            BlocBuilder<PostCategoriesCubit, PostCategoriesStates>(
              builder: (context, state) {
                if (state is PostCategoriesLoading) {
                  return SizedBox(
                    height: height*0.55,
                      child: Center(child: DottedProgressWithLogo()));
                } else if (state is PostCategoriesLoaded) {
                  final categories = state.categoryModel.categoriesList;
                  return Expanded(
                    child: GridView.builder(
                      itemCount: categories?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2.8,
                          ),
                      itemBuilder: (context, index) {
                        final categoryItem = categories![index];
                        return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                          ),
                          onPressed: () {
                            context.push(
                              '/select_sub_categories?categoryId=${categoryItem.categoryId ?? ""}&categoryName=${categoryItem.name ?? ""}',
                            );
                          },

                          child: Row(
                            children: [
                              SizedBox(
                                height: 48,
                                width: 60,
                                child: CachedNetworkImage(
                                  imageUrl: categoryItem.image ?? "",
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  placeholder: (context, url) => Center(
                                    child: spinkits.getSpinningLinespinkit(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey.shade100,
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(height: 18),
                              Expanded(
                                child: Text(
                                  categoryItem.name ?? "Un Known",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: primarycolor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is PostCategoriesFailure) {
                  return Center(child: Text(state.error ?? ""));
                }
                return Center(child: Text("No Data"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
