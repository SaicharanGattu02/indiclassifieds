import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';

class FindInventoryAdScreen extends StatefulWidget {
  const FindInventoryAdScreen({super.key});

  @override
  State<FindInventoryAdScreen> createState() => _FindInventoryAdScreenState();
}

class _FindInventoryAdScreenState extends State<FindInventoryAdScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final rateController = TextEditingController();
  final locationController = TextEditingController();
  final managerController = TextEditingController();
  final detailsController = TextEditingController();

  File? selectedImage;

  @override
  void dispose() {
    titleController.dispose();
    rateController.dispose();
    locationController.dispose();
    managerController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Find inventory ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Service Image', textColor),
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: [6, 3],
                  color: const Color(0xFFD1D5DB),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: const Color(0xFFF9FAFB),
                    child: selectedImage == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: textColor.withOpacity(0.5),
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Upload service image\nTap to browse from gallery',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall(
                                    textColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                  ),
                ),
              ),

              CommonTextField1(
                lable: 'Service Title',
                hint: 'e.g. Co-Working Hub Delhi',
                controller: titleController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title required' : null,
              ),

              CommonTextField1(
                lable: 'Service Rate',
                hint: '0.00',
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: textColor,
                  size: 16,
                ),
                controller: rateController,
                color: textColor,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Rate required' : null,
              ),
              Text(
                'Enter base rate per hour/month',
                style: AppTextStyles.bodySmall(textColor.withOpacity(0.6)),
              ),

              CommonTextField1(
                lable: 'Location',
                hint: 'e.g. Sector 62, Noida',
                prefixIcon: Icon(Icons.location_on, color: textColor, size: 16),
                controller: locationController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Location required'
                    : null,
              ),

              CommonTextField1(
                lable: 'Manager Name',
                hint: 'Your name or company name.',
                controller: managerController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Seller required' : null,
              ),

              CommonTextField1(
                lable: 'Additional Details (Optional)',
                hint: 'Enter specs, facilities, terms',
                maxLines: 3,
                controller: detailsController,
                color: textColor,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: CustomAppButton1(
            text: 'Submit Details',
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
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.titleMedium(
          color,
        ).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
