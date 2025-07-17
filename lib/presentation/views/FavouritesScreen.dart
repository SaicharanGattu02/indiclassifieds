import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class FavouriteItem {
  final String name;
  final String date;
  final String price;
  final String imageUrl;

  FavouriteItem({
    required this.name,
    required this.date,
    required this.price,
    required this.imageUrl,
  });
}

class FavouritesScreen extends StatelessWidget {
  final List<FavouriteItem> items = [
    FavouriteItem(
      name: 'Apple AirPods Pro',
      date: '21 Jan 2025',
      price: '₹ 8,999',
      imageUrl: 'assets/images/carimg.png',
    ),
    FavouriteItem(
      name: 'JBL Charge 2 Speaker',
      date: '20 Dec 2025',
      price: '₹ 6,499',
      imageUrl: 'assets/images/carimg.png',
    ),
    FavouriteItem(
      name: 'PlayStation Controller',
      date: '14 Nov 2024',
      price: '₹ 1,299',
      imageUrl: 'assets/images/carimg.png',
    ),
    FavouriteItem(
      name: 'Nexus Mountain Bike',
      date: '05 Oct 2023',
      price: '₹ 9,100',
      imageUrl: 'assets/images/carimg.png',
    ),
    FavouriteItem(
      name: 'Wildcraft Ranger Tent',
      date: '30 Sep 2022',
      price: '₹ 999',
      imageUrl: 'assets/images/carimg.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final backgroundColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Favourites',
          style: AppTextStyles.titleLarge(textColor).copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDark
                  ? []
                  : [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.imageUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTextStyles.bodySmall(textColor).copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.date,
                        style: AppTextStyles.labelMedium(isDark ? Colors.grey[400]! : Colors.grey[700]!),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.price,
                        style: AppTextStyles.titleLarge(textColor).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
