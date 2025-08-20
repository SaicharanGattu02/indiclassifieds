import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../Components/CutomAppBar.dart';
import '../../Components/ShakeWidget.dart';
import '../../data/cubit/Ad/AstrologyAd/astrology_ad_cubit.dart';
import '../../data/cubit/Ad/AstrologyAd/astrology_ad_states.dart';
import '../../data/cubit/States/states_cubit.dart';
import '../../data/cubit/States/states_repository.dart';
import '../../data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import '../../data/remote_data_source.dart';
import '../../services/AuthService.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/ImagePickerHelper.dart';
import '../../utils/planhelper.dart';
import '../../widgets/CommonTextField.dart';
import '../../theme/AppTextStyles.dart';
import '../../widgets/SelectCityBottomSheet.dart';
import '../../widgets/SelectStateBottomSheet.dart';

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

  final locationController = TextEditingController();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();
  // final costOfFeeController = TextEditingController();
  final descriptionController = TextEditingController();
  final planController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  List<String> selectedConditions = [];
  List<File> _images = [];
  final int _maxImages = 6;
  bool _showStateError = false;
  bool _showCityError = false;
  bool _showimagesError = false;

  int? selectedStateId;
  int? selectedCityId;
  int? planId;
  int? packageId;

  final Set<String> selectedLanguages = {};
  final List<String> languages = ['English', 'Hindi', 'Sanskrit', 'Telugu'];

  void _pickImage() {
    ImagePickerHelper.showImagePickerBottomSheet(
      context: context,
      onImageSelected: (image) {
        setState(() {
          if (_images.length < _maxImages) {
            _images.add(image);
          }
        });
      },
      maxImages: _maxImages,
      images: _images,
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }
  @override
  void initState() {
    super.initState();
    titleController.text = widget.SubCatName ?? "";
  }
  @override
  void dispose() {
    locationController.dispose();
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    priceController.dispose();
    // costOfFeeController.dispose();
    descriptionController.dispose();
    planController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    stateController.dispose();
    cityController.dispose();
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
                lable: ' Add Title',
                hint: 'Enter Title',
                controller: titleController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required title' : null,
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
                lable: 'Price',
                hint: 'Enter Price',
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
              // CommonTextField1(
              //   lable: 'Cost Of Fee',
              //   hint: 'Enter Cost Of Fee',
              //   controller: costOfFeeController,
              //   color: textColor,
              //   keyboardType: TextInputType.number,
              //   prefixIcon: Icon(
              //     Icons.currency_rupee,
              //     color: textColor,
              //     size: 16,
              //   ),
              //   validator: (v) =>
              //   (v == null || v.trim().isEmpty) ? 'Fee required' : null,
              // ),
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

              _sectionTitle('Contact Information', textColor),
              CommonTextField1(
                lable: 'Name',
                hint: 'Enter name',
                controller: nameController,
                color: textColor,
                prefixIcon: Icon(Icons.person, color: textColor, size: 16),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name required' : null,
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
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Phone required' : null,
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
                        child: SelectStateBottomSheet(),
                      );
                    },
                  );

                  if (selectedState != null) {
                    stateController.text = selectedState.name ?? "";
                    selectedStateId = selectedState.id;
                    setState(() {});
                  }
                },
                child: AbsorbPointer(
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
                    // validator: (v) => (v == null || v.trim().isEmpty)
                    //     ? 'State required'
                    //     : null,
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
                    selectedCityId = selectedCity.id;
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
                    // validator: (v) =>
                    // (v == null || v.trim().isEmpty) ? 'City required' : null,
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
              CommonTextField1(
                lable: 'Email (Optional)',
                hint: 'Enter email',
                controller: emailController,
                color: textColor,
                prefixIcon: Icon(Icons.mail, color: textColor, size: 16),
              ),
              CommonTextField1(
                lable: 'Address',
                hint: 'Enter Location',
                controller: locationController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Required location'
                    : null,
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
                      planId = selectedPlan.planId;
                      packageId = selectedPlan.packageId;
                    },
                    title: 'Choose Your Plan',
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: FutureBuilder(
            future: AuthService.isEligibleForAd,
            builder: (context, asyncSnapshot) {
              final isEligible = asyncSnapshot.data ?? false;
              return BlocConsumer<AstrologyAdCubit, AstrologyAdStates>(
                listener: (context, state) {
                  if (state is AstrologyAdSuccess) {
                    context.pushReplacement("/successfully");
                  } else if (state is AstrologyAdFailure) {
                    CustomSnackBar1.show(context, state.error);
                  }
                },
                builder: (context, state) {
                  return CustomAppButton1(
                    isLoading: state is AstrologyAdLoading,
                    text: 'Submit Ad',
                    onPlusTap: isEligible
                        ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        bool isValid = true;

                        // Validate State
                        if (selectedStateId == null) {
                          setState(() {
                            _showStateError = true;
                          });
                          isValid = false;
                        } else {
                          setState(() {
                            _showStateError = false;
                          });
                        }

                        // Validate City
                        if (selectedCityId == null) {
                          setState(() {
                            _showCityError = true;
                          });
                          isValid = false;
                        } else {
                          setState(() {
                            _showCityError = false;
                          });
                        }

                        // Validate Images
                        if (_images.isEmpty) {
                          setState(() {
                            _showimagesError = true;
                          });
                          isValid = false;
                        } else {
                          setState(() {
                            _showimagesError = false;
                          });
                        }

                        if (isValid) {
                          final Map<String, dynamic> data = {
                            "title": titleController.text,
                            "description": descriptionController.text,
                            "sub_category_id": widget.subCatId,
                            "category_id": widget.catId,
                            "location": locationController.text,
                            "mobile_number": phoneController.text,
                            "languages_spoken": selectedLanguages.join(", "),
                            "plan_id": planId,
                            "package_id": packageId,
                            "price": priceController.text,
                            // "cost_of_fee": costOfFeeController.text,
                            "full_name": nameController.text,
                            "state_id": selectedStateId,
                            "city_id": selectedCityId,
                          };

                          if (emailController.text.trim().isNotEmpty) {
                            data["email"] = emailController.text.trim();
                          }

                          if (_images.isNotEmpty) {
                            data["images"] = _images.map((file) => file.path).toList();
                          }

                          context.read<AstrologyAdCubit>().postAstrologyAd(data);
                        }
                      }
                    }
                        : () {
                      context.push("/plans");
                    },

                  );
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
