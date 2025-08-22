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
import '../../data/cubit/MyAds/GetMarkAsListing/get_listing_ad_cubit.dart';
import '../../data/cubit/MyAds/MarkAsListing/mark_as_listing_cubit.dart';
import '../../data/cubit/MyAds/MarkAsListing/mark_as_listing_state.dart';
import '../../data/cubit/States/states_cubit.dart';
import '../../data/cubit/States/states_repository.dart';
import '../../data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import '../../data/remote_data_source.dart';
import '../../services/AuthService.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/ImagePickerHelper.dart';
import '../../utils/planhelper.dart';
import '../../widgets/CommonLoader.dart';
import '../../widgets/CommonTextField.dart';
import '../../theme/AppTextStyles.dart';
import '../../widgets/SelectCityBottomSheet.dart';
import '../../widgets/SelectStateBottomSheet.dart';

class AstrologyAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  final String editId;
  const AstrologyAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
    required this.editId,
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

  bool isLoading = true;
  List<ImageData> _imageDataList = [];

  @override
  void initState() {
    final id = widget.editId.replaceAll('"', '').trim();
    if (id != null && id.isNotEmpty) {
      context.read<GetListingAdCubit>().getListingAd(widget.editId).then((
        commonAdData,
      ) {
        if (commonAdData != null) {
          descriptionController.text =
              commonAdData.data?.listing?.description ?? '';
          locationController.text = commonAdData.data?.listing?.location ?? '';
          priceController.text = commonAdData.data?.listing?.price ?? '';
          nameController.text = commonAdData.data?.listing?.fullName ?? '';
          phoneController.text = commonAdData.data?.listing?.mobileNumber ?? '';

          if (commonAdData.data?.listing?.stateId != null) {
            selectedStateId = commonAdData.data?.listing?.stateId;
            stateController.text = commonAdData.data?.listing?.stateName ?? '';
          }
          if (commonAdData.data?.listing?.cityId != null) {
            selectedCityId = commonAdData.data?.listing?.cityId;
            cityController.text = commonAdData.data?.listing?.cityName ?? '';
          }

          if (commonAdData.data?.listing?.images != null) {
            _imageDataList = commonAdData.data!.listing!.images!
                .where((img) => (img.image ?? "").isNotEmpty)
                .map((img) => ImageData(id: img.id ?? 0, url: img.image ?? ""))
                .toList();
          }
          final langString = commonAdData.data?.listing?.languagesSpoken ?? "";
          selectedLanguages.clear();

          if (langString.isNotEmpty) {
            selectedLanguages.addAll(
              langString.split(',').map((e) => e.trim()),
            );
          }
        }
        setState(() => isLoading = false);
      });
    } else {
      setState(() => isLoading = false);
    }
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
      body: isLoading
          ? Center(child: DottedProgressWithLogo())
          : SingleChildScrollView(
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
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required title'
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
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Price required'
                          : null,
                    ),

                    SizedBox(height: 12),
                    CommonImagePicker(
                      title: "Upload Product Images",
                      images: _images,
                      existingImages: _imageDataList,
                      maxImages: _maxImages,
                      textColor: textColor,
                      showError: _showimagesError,
                      editId: widget.editId,
                      onImagesChanged: (newList) {
                        setState(() => _images = newList);
                      },
                      onExistingImagesChanged: (newList) {
                        setState(() => _imageDataList = newList);
                      },
                    ),
                    _sectionTitle('Contact Information', textColor),
                    CommonTextField1(
                      lable: 'Name',
                      hint: 'Enter name',
                      controller: nameController,
                      color: textColor,
                      prefixIcon: Icon(
                        Icons.person,
                        color: textColor,
                        size: 16,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name required'
                          : null,
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
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Phone required'
                          : null,
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
                    // CommonTextField1(
                    //   lable: 'Email (Optional)',
                    //   hint: 'Enter email',
                    //   controller: emailController,
                    //   color: textColor,
                    //   prefixIcon: Icon(Icons.mail, color: textColor, size: 16),
                    // ),
                    CommonTextField1(
                      lable: 'Address',
                      hint: 'Enter Location',
                      controller: locationController,
                      color: textColor,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required location'
                          : null,
                    ),
                    if (widget.editId == null ||
                        widget.editId.replaceAll('"', '').trim().isEmpty) ...[
                      CommonTextField1(
                        lable: 'Plan',
                        isRead: true,
                        hint: 'Select Plan',
                        controller: planController,
                        color: textColor,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Plan is Required'
                            : null,
                        onTap: () {
                          context
                              .read<UserActivePlanCubit>()
                              .getUserActivePlansData();
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
              return BlocConsumer<MarkAsListingCubit, MarkAsListingState>(
                listener: (context, updateState) {
                  if (updateState is MarkAsListingSuccess ||
                      updateState is MarkAsListingUpdateSuccess) {
                    context.pushReplacement("/successfully");
                  } else if (updateState is MarkAsListingFailure) {
                    CustomSnackBar1.show(context, updateState.error);
                  }
                },
                builder: (context, updateState) {
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
                        isLoading:
                            state is AstrologyAdLoading ||
                            updateState is MarkAsListingUpdateLoading,
                        text: 'Submit Ad',
                        onPlusTap: isEligible
                            ? () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  bool isValid = true;

                                  // Validate State
                                  if (selectedStateId == null) {
                                    setState(() => _showStateError = true);
                                    isValid = false;
                                  } else {
                                    setState(() => _showStateError = false);
                                  }

                                  // Validate City
                                  if (selectedCityId == null) {
                                    setState(() => _showCityError = true);
                                    isValid = false;
                                  } else {
                                    setState(() => _showCityError = false);
                                  }

                                  // Validate Images
                                  if (_images.isEmpty &&
                                      (widget.editId == null ||
                                          widget.editId
                                              .replaceAll('"', '')
                                              .trim()
                                              .isEmpty)) {
                                    setState(() => _showimagesError = true);
                                    isValid = false;
                                  } else {
                                    setState(() => _showimagesError = false);
                                  }

                                  if (isValid) {
                                    final Map<String, dynamic> data = {
                                      "title": titleController.text,
                                      "description": descriptionController.text,
                                      "sub_category_id": widget.subCatId,
                                      "category_id": widget.catId,
                                      "location": locationController.text,
                                      "mobile_number": phoneController.text,
                                      "languages_spoken": selectedLanguages
                                          .join(", "),
                                      "price": priceController.text,
                                      "full_name": nameController.text,
                                      "state_id": selectedStateId,
                                      "city_id": selectedCityId,
                                    };

                                    if (widget.editId == null ||
                                        widget.editId
                                            .replaceAll('"', '')
                                            .trim()
                                            .isEmpty) {
                                      data["plan_id"] = planId;
                                      data["package_id"] = packageId;
                                    }

                                    if (_images.isNotEmpty) {
                                      data["images"] = _images
                                          .map((file) => file.path)
                                          .toList();
                                    }

                                    if (widget.editId
                                        .replaceAll('"', '')
                                        .trim()
                                        .isNotEmpty) {
                                      context
                                          .read<MarkAsListingCubit>()
                                          .markAsUpdate(widget.editId, data);
                                    } else {
                                      context
                                          .read<AstrologyAdCubit>()
                                          .postAstrologyAd(data);
                                    }
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
