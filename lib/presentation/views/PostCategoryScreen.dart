import 'package:flutter/material.dart';

import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class PostCategoryScreen extends StatelessWidget {
  const PostCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bgColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);

    final categories = [
      {'icon': Icons.card_giftcard, 'label': 'Books'},
      {'icon': Icons.pets, 'label': 'Pets'},
      {'icon': Icons.style, 'label': 'Life Style'},
      {'icon': Icons.home, 'label': 'Real Estate'},
      {'icon': Icons.home_work, 'label': 'Properties'},
      {'icon': Icons.directions_car, 'label': 'Vehicles'},
      {'icon': Icons.battery_charging_full, 'label': 'Electronics'},
      {'icon': Icons.menu_book, 'label': 'Jobs'},
      {'icon': Icons.school, 'label': 'Education'},
      {'icon': Icons.emoji_transportation, 'label': 'Transport'},
      {'icon': Icons.visibility, 'label': 'Find Inventor'},
      {'icon': Icons.auto_fix_high, 'label': 'Astrology'},
      {'icon': Icons.people, 'label': 'Community'},
      {'icon': Icons.movie, 'label': 'Films'},
      {'icon': Icons.directions_run, 'label': 'Events'},
      {'icon': Icons.meeting_room, 'label': 'Coworking'},
      {'icon': Icons.directions_car_filled, 'label': 'City Rentals'},
      {'icon': Icons.build, 'label': 'Services'},
    ];

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
            Text('What are you posting?', style: AppTextStyles.headlineMedium(textColor)),
            const SizedBox(height: 4),
            Text('Select a category to continue', style: AppTextStyles.bodyMedium(Colors.grey)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: Icon(item['icon'] as IconData, color: Colors.blue, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['label'].toString(),
                            style: AppTextStyles.bodyMedium(Colors.blue),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
