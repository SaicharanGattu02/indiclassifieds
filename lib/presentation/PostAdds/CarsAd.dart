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
import '../../data/cubit/MyAds/GetMarkAsListing/get_listing_ad_cubit.dart';
import '../../data/cubit/MyAds/MarkAsListing/mark_as_listing_cubit.dart';
import '../../data/cubit/MyAds/MarkAsListing/mark_as_listing_state.dart';
import '../../data/cubit/States/states_cubit.dart';
import '../../data/cubit/States/states_repository.dart';
import '../../data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import '../../data/remote_data_source.dart';
import '../../services/AuthService.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/ImagePickerHelper.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/color_constants.dart';
import '../../utils/planhelper.dart';
import '../../widgets/CommonLoader.dart';
import '../../widgets/CommonTextField.dart';
import '../../widgets/CommonWrapChipSelector.dart';
import '../../widgets/SelectCityBottomSheet.dart';
import '../../widgets/SelectStateBottomSheet.dart';

class CarsAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  final String editId;
  const CarsAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
    required this.editId,
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

  bool isLoading = true;
  List<ImageData> _imageDataList = [];
  @override
  void initState() {
    super.initState();
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
          ownershipType = commonAdData.data?.listing?.ownership ?? "";
          yearOfManufacturingController.text = commonAdData.data?.listing?.yearOfManufacturing.toString()??"";
          fuelType = commonAdData.data?.listing?.fuelType ?? "";
          transmission = commonAdData.data?.listing?.transmission ?? "";
          kmsController.text =
              commonAdData.data?.listing?.kmsRun.toString() ?? "";

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

        }
        setState(() => isLoading = false);
      });
    } else {
      setState(() => isLoading = false);
    }
    brandController.text = widget.SubCatName ?? "";
    titleController.text = widget.CatName ?? "";
  }

  String? imagePath;
  List<File> _images = [];
  final int _maxImages = 6;

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: '${widget.SubCatName}', actions: []),
      body: isLoading
          ? Center(child: DottedProgressWithLogo())
          : SingleChildScrollView(
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
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required title'
                          : null,
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
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Price required'
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
                    SizedBox(height: 12),
                    ChipSelector(
                      initialValue: fuelType,
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
                      initialValue: ownershipType,
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
                      initialValue: transmission,
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
                      prefixIcon: Icon(
                        Icons.person,
                        color: textColor,
                        size: 16,
                      ),
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
                  ],
                ),
              ),
            ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: FutureBuilder<bool>(
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
                    return BlocConsumer<CarsAdCubit, CarsAdStates>(
                      listener: (context, state) {
                        if (state is CarsAdSuccess) {
                          context.pushReplacement("/successfully");
                        } else if (state is CarsAdFailure) {
                          CustomSnackBar1.show(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        return CustomAppButton1(
                          isLoading: state is CarsAdLoading ||
                              updateState is MarkAsListingUpdateLoading,
                          text: 'Submit Ad',
                          onPlusTap: () {
                            if (isEligible) {
                              if (_formKey.currentState?.validate() ?? false) {
                                final Map<String, dynamic> data = {
                                  "title": titleController.text,
                                  "brand": brandController.text,
                                  "description": descriptionController.text,
                                  "sub_category_id": widget.subCatId,
                                  "category_id": widget.catId,
                                  "location": locationController.text,
                                  "mobile_number": phoneController.text,
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

                                final editId = widget.editId.replaceAll('"', '').trim();
                                if (editId.isEmpty) {
                                  data["plan_id"] = planId;
                                  data["package_id"] = packageId;
                                }

                                if (_images.isNotEmpty) {
                                  data["images"] =
                                      _images.map((file) => file.path).toList();
                                }

                                if (editId.isNotEmpty) {
                                  context.read<MarkAsListingCubit>().markAsUpdate(editId, data);
                                } else {
                                  context.read<CarsAdCubit>().postCarsAd(data);
                                }
                              }
                            } else {
                              context.push("/plans");
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        )

    );
  }
}
