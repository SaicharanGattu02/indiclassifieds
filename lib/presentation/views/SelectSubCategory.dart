import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';
import 'package:indiclassifieds/data/cubit/subCategory/sub_category_state.dart';
import 'package:indiclassifieds/services/AuthService.dart';
import 'package:indiclassifieds/widgets/CommonBackground.dart';

import '../../data/cubit/subCategory/sub_category_cubit.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonLoader.dart';

class SelectSubCategory extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const SelectSubCategory({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<SelectSubCategory> createState() => _SelectSubCategoryState();
}

class _SelectSubCategoryState extends State<SelectSubCategory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubCategoryCubit>().getSubCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);
    return FutureBuilder(
      future: AuthService.isGuest,
      builder: (context, asyncSnapshot) {
        final isGuest = asyncSnapshot.data??false;
        return Scaffold(
          backgroundColor: bgColor,
          appBar: CustomAppBar1(title: "${widget.categoryName ?? ""}", actions: []),
          body: Background1(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: BlocBuilder<SubCategoryCubit, SubCategoryStates>(
                builder: (context, state) {
                  if (state is SubCategoryLoading) {
                    return Center(child: DottedProgressWithLogo());
                  } else if (state is SubCategoryLoaded) {
                    final subcategories =
                        state.subCategoryModel.subcategories ?? [];

                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Text(
                            'Select Subcategory',
                            style: AppTextStyles.headlineSmall(textColor),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 25)),

                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final item = subcategories[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  item.name ?? "",
                                  style: AppTextStyles.bodyLarge(textColor),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                onTap:isGuest?(){
                                  context.push("/login");
                                }: () {
                                  context.push(
                                    '/${item.path}?catId=${widget.categoryId}&CatName=${widget.categoryName}&subCatId=${item.subCategoryId}&SubCatName=${item.name ?? ""}&editId=""',
                                  );
                                },
                              ),
                            );
                          }, childCount: subcategories.length),
                        ),
                      ],
                    );
                  } else if (state is SubCategoryFailure) {
                    return Center(
                      child: Text(
                        "Failed to load subcategories",
                        style: AppTextStyles.bodyMedium(textColor),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
      }
    );
  }
}
