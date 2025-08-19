import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/color_constants.dart';
import '../../widgets/CommonTextField.dart';
import '../../theme/AppTextStyles.dart';

class AstrologyAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  const AstrologyAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
  });

  @override
  State<AstrologyAd> createState() => _AstrologyAdState();
}

class _AstrologyAdState extends State<AstrologyAd> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final contactController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();
  final notesController = TextEditingController();
  final planController = TextEditingController();
  bool _showStateError = false;
  bool _showCityError = false;
  bool _showimagesError = false;

  @override
  void initState() {
    super.initState();
    // brandController.text = widget.SubCatName ?? "";
  }
  int? selectedStateId;
  int? selectedCityId;
  int? planId;
  int? packageId;
  String? imagePath;
  List<File> _images = [];
  final int _maxImages = 6;
  final ImagePicker _picker = ImagePicker();
  final Set<String> selectedLanguages = {};
  final List<String> languages = ['English', 'Hindi', 'Sanskrit'];
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: primarycolor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: primarycolor),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),

                // Camera Option
                ListTile(
                  leading: Icon(Icons.camera_alt, color: primarycolor),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        setState(() {
          if (_images.length < _maxImages) {
            _images.add(compressedFile); // ✅ add to list
          }
        });
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        setState(() {
          if (_images.length < _maxImages) {
            _images.add(compressedFile); // ✅ add to list
          }
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    contactController.dispose();
    locationController.dispose();
    dateController.dispose();
    timeController.dispose();
    priceController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Astrology ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Astrologer Information', textColor),
              CommonTextField1(
                lable: 'Full Name',
                hint: 'Enter your full name',
                controller: fullNameController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Full name required'
                    : null,
              ),

              _sectionSubTitle('Languages', textColor),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: languages.map((lang) {
                  final isSelected = selectedLanguages.contains(lang);
                  return ChoiceChip(
                    label: Text(
                      lang,
                      style: AppTextStyles.bodySmall(textColor),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedLanguages.add(lang);
                        } else {
                          selectedLanguages.remove(lang);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              CommonTextField1(
                lable: 'Contact Number',
                hint: 'Enter your contact number',
                controller: contactController,
                color: textColor,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone, color: textColor, size: 16),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Contact required' : null,
              ),
              CommonTextField1(
                prefixIcon: Icon(Icons.location_on, color: textColor, size: 16),
                lable: 'Location',
                hint: 'Enter location',
                controller: locationController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Location required'
                    : null,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CommonTextField1(
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: textColor,
                      size: 16,
                    ),
                    lable: 'Consultation Date',
                    hint: 'Select date',
                    controller: dateController,
                    color: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Date required'
                        : null,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: CommonTextField1(
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: textColor,
                      size: 16,
                    ),
                    lable: 'Consultation Time',
                    hint: 'Select time',
                    controller: timeController,
                    color: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Time required'
                        : null,
                  ),
                ),
              ),
              CommonTextField1(
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: textColor,
                  size: 16,
                ),
                lable: 'Consultation Price',
                hint: 'Enter consultation price',
                controller: priceController,
                color: textColor,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Price required' : null,
              ),
              CommonTextField1(
                maxLines: 3,
                lable: 'Additional Notes',
                hint: 'Any special requirements or notes',
                controller: notesController,
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
              if (_formKey.currentState?.validate() ?? false) {
                debugPrint(
                  'Astrologer: ${fullNameController.text}, Languages: ${selectedLanguages.join(',')}, Contact: ${contactController.text}, Date: ${dateController.text}, Time: ${timeController.text}, Price: ${priceController.text}',
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
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.titleMedium(
          color,
        ).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _sectionSubTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.bodyLarge(
          color,
        ).copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
