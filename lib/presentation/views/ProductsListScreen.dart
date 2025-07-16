import 'package:flutter/material.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class ProductsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final bgColor = ThemeHelper.backgroundColor(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: textColor),
        title: Text(
          'Coworking Spaces',
          style: AppTextStyles.headlineSmall(textColor),
        ),
        actions: [
          Icon(Icons.tune, color: textColor),
          SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6, // just for example
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProductCard(
              imagePath: index % 3 == 0
                  ? 'assets/images/product.png'
                  : index % 3 == 1
                  ? 'assets/images/product.png'
                  : 'assets/images/product.png',
              location: index % 3 == 0
                  ? 'Hyderabad, Madhapur'
                  : index % 3 == 1
                  ? 'Chennai'
                  : 'Hyderabad',
              distance: '12 km',
              type: index % 3 == 0
                  ? 'Startups and Small Businesses'
                  : index % 3 == 1
                  ? 'Digital Nomads'
                  : 'Remote Workers',
              seats: index % 3 == 0
                  ? '4 seats'
                  : index % 3 == 1
                  ? '1 Office Available'
                  : '2 seats',
              price: index % 3 == 0
                  ? '₹2,800/ Person /M'
                  : index % 3 == 1
                  ? '₹4,800/ Person/M'
                  : '₹3,800/ Person/M',
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String location;
  final String distance;
  final String type;
  final String seats;
  final String price;

  const ProductCard({
    required this.imagePath,
    required this.location,
    required this.distance,
    required this.type,
    required this.seats,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final cardColor = ThemeHelper.isDarkMode(context)
        ? Colors.grey[900]
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12,right: 12,top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 12,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTextStyles.titleMedium(textColor),
                        ),
                      ),
                      Text(distance, style: AppTextStyles.bodySmall(textColor)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(type, style: AppTextStyles.bodyMedium(textColor)),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: textColor),
                      SizedBox(width: 4),
                      Text(seats, style: AppTextStyles.bodySmall(textColor)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.titleMedium(Colors.blue),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Connect',
                          style: AppTextStyles.bodySmall(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
