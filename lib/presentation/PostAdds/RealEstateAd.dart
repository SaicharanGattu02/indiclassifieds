import 'package:flutter/material.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';

class RealEstate extends StatefulWidget {
  const RealEstate({super.key});

  @override
  State<RealEstate> createState() => _RealEstateState();
}

class _RealEstateState extends State<RealEstate> {
  final _formKey = GlobalKey<FormState>();
  bool negotiable = false;

  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  final brandController = TextEditingController();
  final cityController = TextEditingController();
  final localityController = TextEditingController();
  final pincodeController = TextEditingController();

  List<String> selectedConditions = [];

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDarkMode = ThemeHelper.isDarkMode(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Real Estate Ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Choose Property Type', textColor),
              _buildCategoryGrid(textColor),
              CommonTextField1(
                lable: 'Ad Title',
                hint: '2Bhk flat for sale in madhapur',
                controller: titleController,
                color: textColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ad Title required';
                  }
                  return null;
                },
              ),
              CommonTextField1(
                lable: 'Description',
                hint: 'Include details',
                controller: descriptionController,
                color: textColor,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                "Location",
                style: AppTextStyles.bodyLarge(
                  textColor,
                ).copyWith(color: textColor, fontWeight: FontWeight.w600),
              ),

              CommonTextField1(
                lableFontSize: 12,
                lableFontWeight: FontWeight.w500,
                lable: 'City',
                hint: 'Enter city name',
                controller: cityController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required City' : null,
              ),

              CommonTextField1(
                lableFontSize: 12,
                lableFontWeight: FontWeight.w500,
                lable: 'Locality / Area',
                hint: 'Enter locality or area name',
                controller: localityController,
                color: textColor,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Locality / Area required'
                    : null,
              ),
              CommonTextField1(
                lableFontSize: 12,
                lableFontWeight: FontWeight.w500,
                lable: 'Pincode',
                hint: 'Enter 6-digit pincode',
                controller: pincodeController,
                color: textColor,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Locality / Area required'
                    : null,
              ),
              const SizedBox(height: 12),

              _buildUploadImagesSection(textColor),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: CustomAppButton1(
            text: 'Submit Ad',
            onPlusTap: () {
              if (_formKey.currentState?.validate() ?? false) {}
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: AppTextStyles.titleMedium(
          color,
        ).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCategoryGrid(Color color) {
    final categories = [
      'Apartment / Flat',
      'Independent House / Villa',
      'Plot / Land',
      'Commercial Property',
    ];
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.8,
      children: categories
          .map(
            (c) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
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

  Widget _buildUploadImagesSection(Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xffEFF6FF),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.photo_camera,
                color: color.withOpacity(0.6),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to upload a high-quality image of your property',
              style: AppTextStyles.bodyMedium(color.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
