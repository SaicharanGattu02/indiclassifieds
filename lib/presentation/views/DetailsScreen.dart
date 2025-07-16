import 'package:flutter/material.dart';

import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
        title: Text('2023 Tesla Model', style: AppTextStyles.headlineSmall(textColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: textColor),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/carimg.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Carousel dots
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.blue : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            // Price & title
            Text('₹43,85,000', style: AppTextStyles.headlineMedium(textColor)),
            Text('2023 Tesla Model Y Long Range AWD', style: AppTextStyles.bodyMedium(textColor)),
            const SizedBox(height: 16),

            // Vehicle info
            Text('Vehicle Information', style: AppTextStyles.titleLarge(textColor)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile('Year', '2023', textColor),
                _infoTile('Mileage', '2,012 km', textColor),
                _infoTile('Location', 'Mumbai,\nMaharashtra', textColor),
                _infoTile('Condition', 'Like New', textColor),
              ],
            ),

            const SizedBox(height: 20),

            // Performance
            Text('Performance', style: AppTextStyles.titleLarge(textColor)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _perfTile('Range', '531 km', textColor),
                _perfTile('0-100', '4.8 sec', textColor),
                _perfTile('Top Speed', '217 km/h', textColor),
              ],
            ),

            const SizedBox(height: 20),

            // Key Features
            Text('Key Performance', style: AppTextStyles.titleLarge(textColor)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _featureChip('All-Wheel Drive'),
                _featureChip('Premium Interior'),
                _featureChip('Glass Roof'),
                _featureChip('Heated Seats'),
                _featureChip('Autopilot'),
                _featureChip('15" Touchscreen'),
                _featureChip('Wireless Charging'),
                _featureChip('Supercharging'),
              ],
            ),

            const SizedBox(height: 20),

            // Description
            Text('Description', style: AppTextStyles.titleLarge(textColor)),
            const SizedBox(height: 8),
            Text(
              'This 2023 Tesla Model Y Long Range AWD is in pristine condition... '
                  'Recently serviced, charged, and ready for delivery. Located in Mumbai’s premium location with great resale value. Listed at ₹43,85,000.',
              style: AppTextStyles.bodyMedium(textColor),
            ),

            const SizedBox(height: 20),

            // Dimensions
            Text('Dimensions', style: AppTextStyles.titleLarge(textColor)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _dimensionTile('Length', '4,750 mm', textColor),
                _dimensionTile('Width', '1,920 mm', textColor),
                _dimensionTile('Height', '1,623 mm', textColor),
                _dimensionTile('Cargo', '2,158 L', textColor),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value, Color color) {
    return Column(
      children: [
        Icon(Icons.circle, size: 20, color: Colors.blue),
        const SizedBox(height: 4),
        Text(title, style: AppTextStyles.labelMedium(color)),
        Text(value, style: AppTextStyles.bodySmall(color), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _perfTile(String label, String value, Color color) {
    return Column(
      children: [
        Icon(Icons.speed, color: Colors.blue),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyMedium(color)),
        Text(label, style: AppTextStyles.labelSmall(color)),
      ],
    );
  }

  Widget _featureChip(String label) {
    return Chip(
      label: Text(label, style: AppTextStyles.labelMedium(Colors.black)),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _dimensionTile(String title, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.bodyMedium(color)),
        Text(title, style: AppTextStyles.labelSmall(color)),
      ],
    );
  }
}
