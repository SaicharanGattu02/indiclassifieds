import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';

class CommunityAdScreen extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  const CommunityAdScreen({super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,});

  @override
  State<CommunityAdScreen> createState() => _CommunityAdScreenState();
}

class _CommunityAdScreenState extends State<CommunityAdScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final rateController = TextEditingController();
  final availableslotsController = TextEditingController();
  final availableplayerslotsController = TextEditingController();
  final detailsController = TextEditingController();

  File? selectedImage;

  @override
  void dispose() {
    titleController.dispose();
    rateController.dispose();
    availableslotsController.dispose();
    availableplayerslotsController.dispose();
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
      appBar: CustomAppBar1(title: 'Community Ad', actions: []),
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
                lable: 'Type of sport or Game',
                hint: 'example :local events',
                controller: titleController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title required' : null,
              ),

              CommonTextField1(
                lable: 'Cost /day/ or Hour',
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
                lable: 'Enter Available slots',
                hint: 'Available slots',
                controller: availableslotsController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Available slots required'
                    : null,
              ),

              CommonTextField1(
                lable: 'Available Player slots ',
                hint: 'Enter Number',
                controller: availableplayerslotsController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Available Player slots required'
                    : null,
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
