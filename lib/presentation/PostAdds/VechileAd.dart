import 'package:flutter/material.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';

class VechileAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  const VechileAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
  });

  @override
  State<VechileAd> createState() => _VechileAdState();
}

class _VechileAdState extends State<VechileAd> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  final brandController = TextEditingController();
  final cityController = TextEditingController();
  final localityController = TextEditingController();
  final pincodeController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // State for preferred contact
  String selectedContactMethod = 'Phone';

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Vehicles Ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Product Images', textColor),
              _buildUploadImagesSection(textColor),

              _sectionTitle('Basic Information', textColor),
              CommonTextField1(
                lable: 'Product Title ',
                hint: 'Enter product title',
                controller: titleController,
                color: textColor,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Product title required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Brand',
                hint: 'Brand Name',
                controller: brandController,
                color: textColor,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Brand required'
                    : null,
              ),
              CommonTextField1(
                maxLines: 5,
                lable: 'Description',
                hint: 'Describe your product in detail',
                controller: descriptionController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Price',
                hint: 'Enter price',
                controller: priceController,
                color: textColor,
                keyboardType: TextInputType.number,
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  color: textColor,
                  size: 16,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Price required' : null,
              ),
              CommonTextField1(
                lable: 'Location',
                hint: 'Enter locality or area name',
                controller: localityController,
                color: textColor,
                prefixIcon: Icon(
                  Icons.location_pin,
                  color: textColor,
                  size: 16,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Locality required'
                    : null,
              ),

              _sectionTitle('Contact Information', textColor),
              CommonTextField1(
                lable: 'Phone Number',
                hint: 'Enter phone number',
                controller: phoneController,
                color: textColor,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.call, color: textColor, size: 16),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Phone required' : null,
              ),
              CommonTextField1(
                lable: 'Email (Optional)',
                hint: 'Enter email',
                controller: emailController,
                color: textColor,
                prefixIcon: Icon(Icons.mail, color: textColor, size: 16),
              ),

              _sectionTitle('Preferred Contact Method', textColor),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildRadioOption('Phone', textColor),
                  const SizedBox(width: 12),
                  _buildRadioOption('Email', textColor),
                  const SizedBox(width: 12),
                  _buildRadioOption('Both', textColor),
                ],
              ),
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
              if (_formKey.currentState?.validate() ?? false) {
                // Submit logic here
                debugPrint(
                  'Form Submitted with preferred: $selectedContactMethod',
                );
              }
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

  Widget _buildUploadImagesSection(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffEFF6FF),
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedContactMethod,
          onChanged: (val) {
            setState(() {
              selectedContactMethod = val!;
            });
          },
          activeColor: color,
        ),
        Text(value, style: TextStyle(color: color)),
      ],
    );
  }
}
