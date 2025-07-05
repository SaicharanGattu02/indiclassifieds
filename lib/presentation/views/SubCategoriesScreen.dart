import 'package:flutter/material.dart';

import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bgColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);

    final categories = [
      {'title': 'Wellness spa', 'image': 'assets/images/subcat1.png'},
      {'title': 'Sports & Fitness', 'image': 'assets/images/subcat2.png'},
      {'title': 'Fashion', 'image': 'assets/images/subcat3.png'},
      {'title': 'Watches', 'image': 'assets/images/subcat4.png'},
      {'title': 'Wellness spa', 'image': 'assets/images/subcat1.png'},
      {'title': 'Sports & Fitness', 'image': 'assets/images/subcat2.png'},
      {'title': 'Fashion', 'image': 'assets/images/subcat3.png'},
      {'title': 'Watches', 'image': 'assets/images/subcat4.png'},
      {'title': 'Wellness spa', 'image': 'assets/images/subcat1.png'},
      {'title': 'Sports & Fitness', 'image': 'assets/images/subcat2.png'},
      {'title': 'Fashion', 'image': 'assets/images/subcat3.png'},
      {'title': 'Watches', 'image': 'assets/images/subcat4.png'},
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Life Style Categories',
          style: AppTextStyles.headlineSmall(textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/banner1.png',
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return InkWell(
                    onTap: () {
                      // Navigate to category detail
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
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Image.asset(
                                item['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item['title']!,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium(textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
