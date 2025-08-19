import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../Components/CutomAppBar.dart';
import '../../Components/ShakeWidget.dart';
import '../../data/cubit/Ad/CarsAd/cars_ad_cubit.dart';
import '../../data/cubit/Ad/CarsAd/cars_ad_states.dart';
import '../../data/cubit/States/states_cubit.dart';
import '../../data/cubit/States/states_repository.dart';
import '../../data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import '../../data/remote_data_source.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/color_constants.dart';
import '../../utils/planhelper.dart';
import '../../widgets/CommonTextField.dart';
import '../../widgets/CommonWrapChipSelector.dart';
import '../../widgets/SelectCityBottomSheet.dart';
import '../../widgets/SelectStateBottomSheet.dart';

class CarsAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  const CarsAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
  });

  @override
  State<CarsAd> createState() => _CarsAdState();
}

class _CarsAdState extends State<CarsAd> {
  final _formKey = GlobalKey<FormState>();
  bool negotiable = false;
  int? selectedStateId;
  int? selectedCityId;
  bool _showStateError = false;
  bool _showCityError = false;
  bool _showimagesError = false;
  final descriptionController = TextEditingController();
  final brandController = TextEditingController();
  final locationController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final yearOfManufacturingController = TextEditingController();
  final kmsController = TextEditingController();
  final ownerShipController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final nameController = TextEditingController();
  final planController = TextEditingController();
  String? fuelType;
  String? ownershipType;
  String? transmission;
  int? planId;
  int? packageId;

  @override
  void initState() {
    super.initState();
    brandController.text = widget.SubCatName ?? "";
  }

  String? imagePath;
  List<File> _images = [];
  final int _maxImages = 6;
  final ImagePicker _picker = ImagePicker();

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
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDarkMode = ThemeHelper.isDarkMode(context);
    return Scaffold(
      appBar: CustomAppBar1(title: '${widget.SubCatName}', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField1(
                isRead: true,
                lable: 'Brand',
                controller: brandController,
                color: textColor,
              ),
              CommonTextField1(
                lable: ' Add Title',
                hint: 'Enter Title',
                controller: titleController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required title' : null,
              ),
              CommonTextField1(
                lable: 'Year of Manufacturing',
                hint: 'Enter Year of Manufacturing',
                controller: yearOfManufacturingController,
                keyboardType: TextInputType.number,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Year of Manufacturing is required'
                    : null,
              ),
              CommonTextField1(
                lable: 'KMs Run',
                hint: 'Enter KMs Run',
                controller: kmsController,
                keyboardType: TextInputType.number,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Memory ( RAM) required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Description',
                hint: 'Enter  Upto  500 words',
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

              GestureDetector(
                onTap: () async {
                  final selectedState = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return BlocProvider(
                        create: (_) => SelectStatesCubit(
                          SelectStatesImpl(
                            remoteDataSource: RemoteDataSourceImpl(),
                          ),
                        ),
                        child: const SelectStateBottomSheet(),
                      );
                    },
                  );

                  if (selectedState != null) {
                    stateController.text = selectedState.name ?? "";
                    selectedStateId = selectedState.id ?? "";
                    setState(() {});
                  }
                },
                child: AbsorbPointer(
                  // 👈 stops inner TextField from eating taps
                  child: CommonTextField1(
                    lable: 'State',
                    hint: 'Select State',
                    controller: stateController,
                    color: textColor,
                    keyboardType: TextInputType.text,
                    isRead: true,
                    prefixIcon: Icon(
                      Icons.location_city_outlined,
                      color: textColor,
                      size: 16,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'State required'
                        : null,
                  ),
                ),
              ),
              if (_showStateError) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ShakeWidget(
                    key: Key("state"),
                    duration: const Duration(milliseconds: 700),
                    child: const Text(
                      'Please Select State',
                      style: TextStyle(
                        fontFamily: 'roboto_serif',
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              GestureDetector(
                onTap: () async {
                  final selectedCity = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return SelectCityBottomSheet(
                        stateId: selectedStateId ?? 0,
                      );
                    },
                  );

                  if (selectedCity != null) {
                    cityController.text = selectedCity.name ?? "";
                    selectedCityId = selectedCity.id ?? "";
                    setState(() {});
                  }
                },
                child: AbsorbPointer(
                  child: CommonTextField1(
                    lable: 'City',
                    hint: 'Select City',
                    controller: cityController,
                    color: textColor,
                    keyboardType: TextInputType.text,
                    isRead: true,
                    prefixIcon: Icon(
                      Icons.location_city_outlined,
                      color: textColor,
                      size: 16,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'City required'
                        : null,
                  ),
                ),
              ),
              if (_showCityError) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ShakeWidget(
                    key: Key(
                      "dropdown_city_error_${DateTime.now().millisecondsSinceEpoch}",
                    ),
                    duration: const Duration(milliseconds: 700),
                    child: const Text(
                      'Please Select City',
                      style: TextStyle(
                        fontFamily: 'roboto_serif',
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              _sectionTitle('Upload Product Images', textColor),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0D000000),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: _images.isEmpty
                    ? InkWell(
                        onTap: _pickImage,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                color: textColor.withOpacity(0.6),
                                size: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '+ Add Photos ${_maxImages}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.8,
                        ),
                        itemCount: _images.length < _maxImages
                            ? _images.length + 1
                            : _images.length,
                        itemBuilder: (context, index) {
                          if (index == _images.length &&
                              _images.length < _maxImages) {
                            return InkWell(
                              onTap: _pickImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      color: textColor.withOpacity(0.6),
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Add Photo',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (_showimagesError && _images.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ShakeWidget(
                    key: Key(
                      "images_error_${DateTime.now().millisecondsSinceEpoch}",
                    ),
                    duration: const Duration(milliseconds: 700),
                    child: const Text(
                      'Please upload at least one image',
                      style: TextStyle(
                        fontFamily: 'roboto_serif',
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 12),
              ChipSelector(
                title: "Fuel Type",
                options: [
                  {"label": "Petrol", "value": "petrol"},
                  {"label": "Diesel", "value": "diesel"},
                  {"label": "CNG", "value": "cng"},
                  {"label": "Electric", "value": "electric"},
                  {"label": "Hybrid", "value": "hybrid"},
                ],
                onSelected: (val) => setState(() => fuelType = val),
              ),
              SizedBox(height: 12),
              ChipSelector(
                title: "Ownership Type",
                options: [
                  {"label": "1st Owner", "value": "1st-owner"},
                  {"label": "2nd Owner", "value": "2nd-owner"},
                  {"label": "3rd Owner", "value": "3rd-owner"},
                  {"label": "4th Owner", "value": "4th-owner"},
                  {"label": "Above 4 Owners", "value": "above-4-owners"},
                ],
                onSelected: (val) => setState(() => ownershipType = val),
              ),
              SizedBox(height: 12),
              ChipSelector(
                title: "Transmission",
                options: [
                  {"label": "Manual", "value": "manual"},
                  {"label": "Automatic", "value": "automatic"},
                ],
                onSelected: (val) => setState(() => transmission = val),
              ),

              CommonTextField1(
                lable: 'Name',
                hint: 'Enter name',
                controller: nameController,
                color: textColor,
                prefixIcon: Icon(Icons.person, color: textColor, size: 16),
              ),
              CommonTextField1(
                lable: 'Phone Number',
                hint: 'Enter phone number',
                controller: phoneController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                color: textColor,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.call, color: textColor, size: 16),
              ),
              CommonTextField1(
                lable: 'Address',
                hint: 'Enter Address',
                controller: locationController,
                color: textColor,
              ),
              CommonTextField1(
                lable: 'Plan',
                isRead: true,
                hint: 'Select Plan',
                controller: planController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Plan is Required' : null,
                onTap: () {
                  context.read<UserActivePlanCubit>().getUserActivePlansData();
                  showPlanBottomSheet(
                    context: context,
                    controller: planController,
                    onSelectPlan: (selectedPlan) {
                      print('Selected plan: ${selectedPlan.planName}');
                      planId = selectedPlan.planId;
                      packageId = selectedPlan.packageId;
                    },
                    title:
                    'Choose Your Plan', // Optional title for the bottom sheet
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: BlocConsumer<CarsAdCubit, CarsAdStates>(
            listener: (context, state) {
              if (state is CarsAdSuccess) {
                context.pushReplacement("/successfully");
              } else if (state is CarsAdFailure) {
                CustomSnackBar1.show(context, state.error);
              }
            },
            builder: (context, state) {
              return CustomAppButton1(
                isLoading: state is CarsAdLoading,
                text: 'Submit Ad',
                onPlusTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final Map<String, dynamic> data = {
                      "title": titleController.text,
                      "brand": brandController.text,
                      "description": descriptionController.text,
                      "sub_category_id": widget.subCatId,
                      "category_id": widget.catId,
                      "location": locationController.text,
                      "mobile_number": phoneController.text,
                      "plan_id": planId,
                      "package_id": packageId,
                      "price": priceController.text,
                      "full_name": nameController.text,
                      "state_id": selectedStateId,
                      "city_id": selectedCityId,
                      "year_of_manufacturing":
                          yearOfManufacturingController.text,
                      "kms_run": kmsController.text,
                      "ownership": ownershipType,
                      "fuel_type": fuelType,
                      "transmission": transmission,
                    };
                    if (_images.isNotEmpty) {
                      data["images"] = _images
                          .map((file) => file.path)
                          .toList();
                    }
                    context.read<CarsAdCubit>().postCarsAd(data);
                  }
                },
              );
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
}
