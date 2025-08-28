import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../Components/CutomAppBar.dart';
import '../../Components/ShakeWidget.dart';
import '../../data/cubit/Ad/CityRentalsAd/city_rentals_ad_cubit.dart';
import '../../data/cubit/Ad/CityRentalsAd/city_rentals_ad_states.dart';
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
import '../../utils/AppLogger.dart';
import '../../utils/ImagePickerHelper.dart';
import '../../utils/constants.dart';
import '../../utils/place_picker_bottomsheet.dart';
import '../../utils/planhelper.dart';
import '../../widgets/CommonLoader.dart';
import '../../widgets/CommonTextField.dart';
import '../../widgets/SelectCityBottomSheet.dart';
import '../../widgets/SelectStateBottomSheet.dart';

class CityRentalsAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  final String editId;
  const CityRentalsAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
    required this.editId,
  });

  @override
  State<CityRentalsAd> createState() => _CityRentalsAdState();
}

class _CityRentalsAdState extends State<CityRentalsAd> {
  final _formKey = GlobalKey<FormState>();

  bool negotiable = false;
  int? selectedStateId;
  int? selectedCityId;
  bool _showStateError = false;
  bool _showCityError = false;
  bool _showimagesError = false;
  bool _showDescriptionError = false;
  bool _showPriceError = false;
  bool _showVechicleNumberError = false;
  bool _showDurationError = false;
  final descriptionController = TextEditingController();
  final brandController = TextEditingController();
  final locationController = TextEditingController();
  final vechicleNumber = TextEditingController();
  final rentalDuration = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final planController = TextEditingController();

  List<String> selectedConditions = [];
  List<File> _images = [];
  final int _maxImages = 6;

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
          titleController.text=commonAdData.data?.listing?.title??"";
          locationController.text = commonAdData.data?.listing?.location ?? '';
          priceController.text = commonAdData.data?.listing?.price ?? '';
          nameController.text = commonAdData.data?.listing?.fullName ?? '';
          phoneController.text = commonAdData.data?.listing?.mobileNumber ?? '';
          vechicleNumber.text = commonAdData.data?.listing?.vechileNumber ?? '';
          rentalDuration.text =
              commonAdData.data?.listing?.rentalDuration ?? '';

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
    // titleController.text = widget.CatName ?? "";
    fetchData();
  }

  void fetchData() async {
    String? name = await AuthService.getName();
    String? phone = await AuthService.getMobile();
    String? stateIdStr = await AuthService.getState();
    String? cityIdStr = await AuthService.getCity();
    String? stateId = await AuthService.getStateId();
    String? cityId = await AuthService.getCityId();

    if (name != null && name.isNotEmpty) {
      nameController.text = name;
    }

    if (phone != null && phone.isNotEmpty) {
      phoneController.text = phone;
    }

    if (stateIdStr != null && stateIdStr.isNotEmpty) {
      stateController.text = stateIdStr;
    }

    if (cityIdStr != null && cityIdStr.isNotEmpty) {
      cityController.text = cityIdStr;
    }
    if (stateId != null && stateId.isNotEmpty) {
      setState(() {
        selectedStateId = int.tryParse(stateId);
      });
    } if (cityId != null && cityId.isNotEmpty) {
      setState(() {
        selectedCityId = int.tryParse(cityId);
      });
    }
    debugPrint("✅ INFO: state: $stateId");
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return FutureBuilder(
      future: AuthService.isEligibleForFree,
      builder: (context, asyncSnapshot) {
        final isEligibleForFree = asyncSnapshot.data ?? false;
        AppLogger.info("isEligibleForFree:${isEligibleForFree}");
        return Scaffold(
          appBar: CustomAppBar1(
            title: (widget.editId.replaceAll('"', '').trim().isNotEmpty ?? false)
                ? "Edit ${widget.CatName}"
                : widget.CatName,
            actions: [],
          ),
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
                          hint: 'Enter Upto 500 words',
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
                        CommonTextField1(
                          lable: 'Vehicle Number',
                          hint: 'Enter Vehicle Number',
                          controller: vechicleNumber,
                          color: textColor,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Vehicle number required'
                              : null,
                        ),
                        CommonTextField1(
                          lable: 'Rental Duration',
                          hint: 'Enter Rental Duration (e.g. 6 months, 1 year)',
                          controller: rentalDuration,
                          color: textColor,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Rental duration required'
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
                              selectedStateId = selectedState.id ?? 0;
                              setState(() {});
                            }
                          },
                          child: AbsorbPointer(
                            child: CommonTextField1(
                              lable: 'State',
                              hint: 'Select State',
                              controller: stateController,
                              color: textColor,
                              isRead: true,
                              prefixIcon: Icon(
                                Icons.location_city_outlined,
                                color: textColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        if (_showStateError) _buildErrorText("Please Select State"),
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
                              selectedCityId = selectedCity.id ?? 0;
                              setState(() {});
                            }
                          },
                          child: AbsorbPointer(
                            child: CommonTextField1(
                              lable: 'City',
                              hint: 'Select City',
                              controller: cityController,
                              color: textColor,
                              isRead: true,
                              prefixIcon: Icon(
                                Icons.location_city_outlined,
                                color: textColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        if (_showCityError) _buildErrorText("Please Select City"),

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
                        CommonTextField1(
                          lable: 'Address',
                          hint: 'Enter Location',
                          controller: locationController,
                          color: ThemeHelper.textColor(context),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required Location'
                              : null,
                          isRead: true,
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            final picked = await openPlacePickerBottomSheet(
                              context: context,
                              googleApiKey: google_map_key,
                              controller: locationController,
                              appendToExisting: false,
                              components: 'country:in',
                              language: 'en',
                            );
                            if (picked != null) {
                              latlng = "${picked.lat}, ${picked.lng}";
                            }
                          },
                        ),
                        if (widget.editId == null ||
                            widget.editId.replaceAll('"', '').trim().isEmpty && !isEligibleForFree) ...[
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
              child: FutureBuilder(
                future: Future.wait([
                  AuthService.isNewUser,
                ]),
                builder: (context, asyncSnapshot) {
                  final isNewUser = asyncSnapshot.data?[0] ?? false;
                  return BlocConsumer<MarkAsListingCubit, MarkAsListingState>(
                    listener: (context, updateState) {
                      if (updateState is MarkAsListingSuccess ||
                          updateState is MarkAsListingUpdateSuccess) {
                        context.pushReplacement(
                          "/successfully?title=Your ad has been updated successfully",
                        );
                      } else if (updateState is MarkAsListingFailure) {
                        CustomSnackBar1.show(context, updateState.error);
                      }
                    },
                    builder: (context, updateState) {
                      return BlocConsumer<CityRentalsAdCubit, CityRentalsAdStates>(
                        listener: (context, state) {
                          if (state is CityRentalsAdSuccess) {
                            context.pushReplacement(
                              "/successfully?title=Your ad has been Added successfully",
                            );
                          } else if (state is CityRentalsAdFailure) {
                            CustomSnackBar1.show(context, state.error);
                          }
                        },
                        builder: (context, state) {
                          return CustomAppButton1(
                            isLoading:
                                state is CityRentalsAdLoading ||
                                updateState is MarkAsListingUpdateLoading,
                            text: 'Submit Ad',
                            onPlusTap: isNewUser
                                ? () {
                              context.push(
                                '/register?from=ad',
                              );
                            }
                                : () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      bool isValid = true;
                                      if (selectedStateId == null) {
                                        setState(() => _showStateError = true);
                                        isValid = false;
                                      } else {
                                        setState(() => _showStateError = false);
                                      }
                                      if (locationController.text
                                          .trim()
                                          .isEmpty) {
                                        CustomSnackBar1.show(
                                          context,
                                          "Please enter location",
                                        );
                                        isValid = false;
                                      }
                                      // if ((widget.editId == null ||
                                      //     widget.editId
                                      //         .replaceAll('"', '')
                                      //         .trim()
                                      //         .isEmpty) &&
                                      //     (planId == null ||
                                      //         packageId == null)) {
                                      //   CustomSnackBar1.show(
                                      //     context,
                                      //     "Please select a plan",
                                      //   );
                                      //   isValid = false;
                                      // }
                                      if (selectedCityId == null) {
                                        setState(() => _showCityError = true);
                                        isValid = false;
                                      } else {
                                        setState(() => _showCityError = false);
                                      }
                                      if (_images.isEmpty &&
                                          (widget.editId == null ||
                                              widget.editId
                                                  .replaceAll('"', '')
                                                  .trim()
                                                  .isEmpty)) {
                                        CustomSnackBar1.show(
                                          context,
                                          "Please select atleast 2 images",
                                        );
                                        setState(() => _showimagesError = true
                                        );
                                      } else {
                                        setState(() => _showimagesError = false);
                                      }
                                      if (descriptionController.text.trim().isEmpty) {
                                        setState(() => _showDescriptionError = true);
                                        isValid = false;
                                      } else {
                                        setState(() => _showDescriptionError = false);
                                      }
                                      if (priceController.text.trim().isEmpty) {
                                        setState(() => _showPriceError = true);
                                        isValid = false;
                                      } else {
                                        setState(() => _showPriceError = false);
                                      }
                                      if (vechicleNumber.text.trim().isEmpty) {
                                        setState(() => _showVechicleNumberError = true);
                                        isValid = false;
                                      } else {
                                        setState(() => _showVechicleNumberError = false);
                                      }
                                      if (rentalDuration.text.trim().isEmpty) {
                                        setState(() => _showDurationError = true);
                                        isValid = false;
                                      } else {
                                        setState(() => _showDurationError = false);
                                      }
                                      if (isValid) {
                                        final Map<String, dynamic> data = {
                                          "title": titleController.text,
                                          "description": descriptionController
                                              .text,
                                          "sub_category_id": widget.subCatId,
                                          "category_id": widget.catId,
                                          "location": locationController.text,
                                          "mobile_number": phoneController.text,
                                          "vehicle_number": vechicleNumber.text,
                                          "rental_duration": rentalDuration
                                              .text,
                                          "price": priceController.text,
                                          "full_name": nameController.text,
                                          "state_id": selectedStateId,
                                          "city_id": selectedCityId,
                                          "location_key": latlng,
                                        };

                                        final editId = widget.editId
                                            .replaceAll('"', '')
                                            .trim();

                                        if (editId.isEmpty) {
                                          data["plan_id"] = planId;
                                          data["package_id"] = packageId;
                                        }

                                        if (_images.isNotEmpty) {
                                          data["images"] = _images
                                              .map((file) => file.path)
                                              .toList();
                                        }
                                        if (editId.isNotEmpty) {
                                          context
                                              .read<MarkAsListingCubit>()
                                              .markAsUpdate(editId, data);
                                        } else {
                                          context
                                              .read<CityRentalsAdCubit>()
                                              .postCityRentalsAd(data);
                                        }
                                      }
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
          ),
        );
      }
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

  Widget _buildErrorText(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ShakeWidget(
        key: Key("error_${DateTime.now().millisecondsSinceEpoch}"),
        duration: const Duration(milliseconds: 700),
        child: Text(
          message,
          style: const TextStyle(
            fontFamily: 'roboto_serif',
            fontSize: 12,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
