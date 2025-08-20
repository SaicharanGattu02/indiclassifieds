import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/data/cubit/Categories/categories_states.dart';
import 'package:indiclassifieds/utils/color_constants.dart';
import '../../data/cubit/Categories/categories_cubit.dart';
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
   context.read<CategoriesCubit>().getCategories();

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
            BlocBuilder<CategoriesCubit, CategoriesStates>(
              builder: (context, state) {
                if (state is CategoriesLoading) {
                  return Center(child:DottedProgressWithLogo());
                } else if (state is CategoriesLoaded) {
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
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: categoryItem.image ?? "",
                                    fit: BoxFit.cover,
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
                              ),
                              const SizedBox(width: 12),
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
                } else if (state is CategoriesFailure) {
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

  void _handleCategoryTap(BuildContext context, String label) {
    switch (label) {
      case 'Books':
        context.push('/'); // You can assign actual routes
        break;
      case 'Pets':
        context.push('/');
        break;
      case 'Life Style':
        context.push('/life_style_ad');
        break;
      case 'Real Estate':
      case 'Properties':
        context.push('/real_estate');
        break;
      case 'Vehicles':
        context.push('/vechile_ad');
        break;
      case 'Electronics':
        context.push('/ad_electronics');
        break;
      case 'Jobs':
        context.push('/job_ad');
        break;
      case 'Education':
        context.push('/educational_ad');
        break;
      case 'Transport':
      case 'City Rentals':
        context.push('/mobile_ad');
        break;
      case 'Find Inventor':
        context.push('/find_inventory_ad');
        break;
      case 'Astrology':
        context.push('/astrology_ad');
        break;
      case 'Community':
        context.push('/community_ad');
        break;
      case 'Films':
        context.push('/film_ad');
        break;
      case 'Events':
        context.push('/events_ad');
        break;
      case 'Coworking':
        context.push('/co_work_space_ad');
        break;
      case 'Services':
        context.push('/service_ad');
        break;
      default:
    }
  }
}
