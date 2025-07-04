import 'package:flutter/material.dart';

import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../theme/app_colors.dart';
import '../../widgets/CommonTextField.dart';

class PetAdScreen extends StatefulWidget {
  const PetAdScreen({super.key});

  @override
  State<PetAdScreen> createState() => _PetAdScreenState();
}

class _PetAdScreenState extends State<PetAdScreen> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);
    final isDark = ThemeHelper.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Ad', style: AppTextStyles.titleLarge(textColor)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Pet Category',
              style: AppTextStyles.titleMedium(textColor).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildCategoryGrid(textColor),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Title',
                    style: AppTextStyles.bodyLarge(Colors.black).copyWith(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Enter Location',
                    style: AppTextStyles.bodyLarge(Colors.black).copyWith(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: CommonTextField(hint: 'Add Title', color: textColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CommonTextField(
                    hint: 'Enter Location',
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              style: AppTextStyles.bodyLarge(Colors.black).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            _buildMultilineField(
              'Include breed, behaviour, vaccination, food habits, etc.s',
              textColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Furniture Type',
              style: AppTextStyles.titleMedium(textColor).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildChips(
              ['Wooden', 'Metal', 'Plastic', 'Leather', 'Fabric'],
              textColor,
              isDark,
            ),

            const SizedBox(height: 15),
            Text(
              'Style (Optional)',
              style: AppTextStyles.titleMedium(textColor).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildChips(
              ['Modern', 'Traditional', 'Minimal', 'Rustic'],
              textColor,
              isDark,
            ),

            const SizedBox(height: 20),
            Text(
              'Condition',
              style: AppTextStyles.titleMedium(textColor).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildConditionOptions(textColor),
            const SizedBox(height: 20),
            Text(
              'Dimensions (Optional)',
              style: AppTextStyles.titleMedium(textColor).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildDimensionFields(textColor),

            const SizedBox(height: 20),
            Text('Price', style: AppTextStyles.titleMedium(textColor)),
            const SizedBox(height: 10),
            CommonTextField(hint: 'Selling Price (₹)', color: textColor),

            const SizedBox(height: 10),
            _buildSwitchRow('Is it negotiable?', textColor),

            const SizedBox(height: 20),
            Text(
              'Delivery Info',
              style: AppTextStyles.titleMedium(textColor).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildSwitchRow('Home Delivery Available', textColor),
            _buildSwitchRow('Pickup Only', textColor),
            _buildSwitchRow('Assembly Required', textColor),

            const SizedBox(height: 20),
            Text(
              'Upload Images',
              style: AppTextStyles.titleMedium(textColor).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _buildUploadImagesSection(textColor),

            const SizedBox(height: 20),
            Text(
              'Contact Information',
              style: AppTextStyles.titleMedium(textColor).copyWith(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text('Name', style: AppTextStyles.labelLarge(textColor)),
            SizedBox(height: 4),
            CommonTextField(hint: 'Name', color: textColor),
            SizedBox(height: 4),
            Text('Phone Number', style: AppTextStyles.labelLarge(textColor)),
            SizedBox(height: 4),
            CommonTextField(hint: 'Phone Number', color: textColor),
            SizedBox(height: 4),
            Text("Email", style: AppTextStyles.labelLarge(textColor)),
            SizedBox(height: 4),
            CommonTextField(hint: 'Email (Optional)', color: textColor),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: Text(
                  'Submit Ad',
                  style: AppTextStyles.titleMedium(AppColors.lightBackground),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(Color color) {
    final categories = [
      'Dogs',
      'Cats',
      'Birds',
      'Rabbits',
      'Turtles',
      'Fish',
    ];
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
      children: categories
          .map(
            (c) => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                c,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(color),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMultilineField(String hint, Color color) {
    return TextField(
      style: AppTextStyles.bodyMedium(color),
      maxLines: 5,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium(color.withOpacity(0.6)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildChips(List<String> items, Color color, bool isDark) {
    return Wrap(
      spacing: 8,
      children: items
          .map(
            (e) => Chip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(100)),
                side: BorderSide(
                  color: isDark ? Color(0xff666666) : Color(0xffD9D9D9),
                ),
              ),
              label: Text(e, style: AppTextStyles.bodySmall(color)),
              backgroundColor: isDark ? Colors.black : Colors.grey.shade200,
            ),
          )
          .toList(),
    );
  }

  Widget _buildConditionOptions(Color color) {
    final conditions = ['Brand New', 'Like New', 'Used', 'Needs Repair'];
    return Wrap(
      spacing: 8,
      children: conditions
          .map(
            (c) => ChoiceChip(
              label: Text(c, style: AppTextStyles.bodySmall(color)),
              selected: false,
            ),
          )
          .toList(),
    );
  }

  Widget _buildDimensionFields(Color color) {
    return Row(
      children: [
        Expanded(
          child: CommonTextField(hint: 'Length', color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonTextField(hint: 'Width', color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonTextField(hint: 'Height', color: color),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium(color)),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            padding: EdgeInsets.all(0),
            value: false,
            onChanged: (v) {},
          ),
        ),
      ],
    );
  }

  Widget _buildUploadImagesSection(Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.photo_camera, color: color.withOpacity(0.6), size: 40),
            const SizedBox(height: 8),
            Text(
              '+ Add Photos (Max 8)',
              style: AppTextStyles.bodyMedium(color.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
