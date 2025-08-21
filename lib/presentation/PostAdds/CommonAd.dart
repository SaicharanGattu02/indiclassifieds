import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indiclassifieds/Components/CustomAppButton.dart';
import 'package:indiclassifieds/Components/CustomSnackBar.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';

import '../../Components/ShakeWidget.dart';
import '../../data/cubit/Ad/CommonAd/common_ad_cubit.dart';
import '../../data/cubit/Ad/CommonAd/common_ad_states.dart';
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
import '../../utils/spinkittsLoader.dart';
import '../../widgets/CommonTextField.dart';
import '../../widgets/SelectCityBottomSheet.dart';
import '../../widgets/SelectStateBottomSheet.dart';

class CommonAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  final String editId;
  const CommonAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
    required this.editId,
  });

  @override
  State<CommonAd> createState() => _CommonAdState();
}

class _CommonAdState extends State<CommonAd> {
  final _formKey = GlobalKey<FormState>();
  bool negotiable = false;
  int? selectedStateId;
  int? selectedCityId;
  bool _showStateError = false;
  bool _showCityError = false;
  bool _showimagesError = false;
  bool _showPaymentError = false;
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final planController = TextEditingController();
  int? imageId;
  List<String> selectedConditions = [];
  List<File> _images = [];
  List<String> _imageUrls = [];
  final int _maxImages = 6;
  int? planId;
  int? packageId;
  bool isLoading = true;
  void _pickImage() {
    ImagePickerHelper.showImagePickerBottomSheet(
      context: context,
      onImageSelected: (image) {
        setState(() {
          if (_images.length < _maxImages) {
            _images.add(image); // Add the selected image to the list
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
  List<ImageData> _imageDataList = [];
  @override
  void initState() {
    super.initState();
    debugPrint("typee:${widget.editId}");
    titleController.text = widget.SubCatName ?? "";
    context.read<GetListingAdCubit>().getListingAd(widget.subCatId).then((
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
              .map((img) => ImageData(
            id: img.id ?? 0,
            url: img.image ?? "",
          ))
              .toList();
        }
        // if (commonAdData.data?.listing?.images != null) {
        //   _imageUrls = commonAdData.data!.listing!.images!
        //       .map((img) => img.image ?? "")
        //       .where((url) => url.isNotEmpty)
        //       .toList();
        //   // imageId=commonAdData.data.listing.images.
        // }
      }

      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    return Scaffold(
      appBar: CustomAppBar1(
        title: widget.editId !=null
            ? "Edit ${widget.CatName}"
            : widget.CatName,
        actions: [],
      ),
      body:isLoading
          ? const Center(child: CircularProgressIndicator())
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
                child: (_images.isEmpty && _imageUrls.isEmpty)
                    ? InkWell(
                  onTap: _pickImage,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo_camera, color: textColor.withOpacity(0.6), size: 40),
                        const SizedBox(height: 8),
                        Text(
                          '+ Add Photos ($_maxImages)',
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
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: _images.length + _imageUrls.length < _maxImages
                      ? _images.length + _imageUrls.length + 1
                      : _images.length + _imageUrls.length,
                  itemBuilder: (context, index) {
                    if (index < _imageUrls.length) {
                      final image = _imageDataList[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _imageUrls[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          widget.editId != null?
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  context.read<MarkAsListingCubit>().markAsDelete(image.id);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child:  BlocConsumer<MarkAsListingCubit,MarkAsListingState>(listener: (context, state) {
                                    if(state is MarkAsListingSuccess){
                                      _imageUrls.removeAt(index);
                                    }else if(state is MarkAsListingFailure){
                                      return CustomSnackBar1.show(context, state.error);
                                    }
                                  },builder: (context, state) {
                                  return state is MarkAsListingLoading?Center(child:spinkits.getSpinningLinespinkit() ):Icon(Icons.close, color: Colors.white, size: 16);
                                  },
                                  ),
                                ),
                              ),
                            )
                          :Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _imageUrls.removeAt(index));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child:  Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),


                        ],
                      );
                    }
                    final localIndex = index - _imageUrls.length;
                    if (localIndex < _images.length) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _images[localIndex],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(localIndex),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    // Add photo button
                    return InkWell(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, color: textColor.withOpacity(0.6), size: 24),
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
                  },
                ),

                // child: _images.isEmpty
                //     ? InkWell(
                //         onTap: _pickImage,
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Icon(
                //                 Icons.photo_camera,
                //                 color: textColor.withOpacity(0.6),
                //                 size: 40,
                //               ),
                //               SizedBox(height: 8),
                //               Text(
                //                 '+ Add Photos ${_maxImages}',
                //                 style: TextStyle(
                //                   fontFamily: 'Poppins',
                //                   fontSize: 14,
                //                   color: textColor.withOpacity(0.6),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //     : GridView.builder(
                //         shrinkWrap: true,
                //         physics: NeverScrollableScrollPhysics(),
                //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 4,
                //           crossAxisSpacing: 8,
                //           mainAxisSpacing: 8,
                //           childAspectRatio: 1.8,
                //         ),
                //         itemCount: _images.length < _maxImages
                //             ? _images.length + 1
                //             : _images.length,
                //         itemBuilder: (context, index) {
                //           if (index == _images.length &&
                //               _images.length < _maxImages) {
                //             return InkWell(
                //               onTap: _pickImage,
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                   border: Border.all(
                //                     color: const Color(0xFFE5E7EB),
                //                   ),
                //                   borderRadius: BorderRadius.circular(8),
                //                 ),
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     Icon(
                //                       Icons.add_photo_alternate,
                //                       color: textColor.withOpacity(0.6),
                //                       size: 24,
                //                     ),
                //                     const SizedBox(height: 4),
                //                     Text(
                //                       'Add Photo',
                //                       style: TextStyle(
                //                         fontFamily: 'Poppins',
                //                         fontSize: 12,
                //                         color: textColor.withOpacity(0.6),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             );
                //           }
                //           return Stack(
                //             children: [
                //               ClipRRect(
                //                 borderRadius: BorderRadius.circular(8),
                //                 child: Image.file(
                //                   _images[index],
                //                   fit: BoxFit.cover,
                //                   width: double.infinity,
                //                   height: double.infinity,
                //                 ),
                //               ),
                //               Positioned(
                //                 top: 4,
                //                 right: 4,
                //                 child: GestureDetector(
                //                   onTap: () => _removeImage(index),
                //                   child: Container(
                //                     padding: const EdgeInsets.all(2),
                //                     decoration: BoxDecoration(
                //                       color: Colors.red.withOpacity(0.7),
                //                       shape: BoxShape.circle,
                //                     ),
                //                     child: const Icon(
                //                       Icons.close,
                //                       color: Colors.white,
                //                       size: 16,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           );
                //         },
                //       ),
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
          child: FutureBuilder(
            future: AuthService.isEligibleForAd,
            builder: (context, asyncSnapshot) {
              final isEligible = asyncSnapshot.data ?? false;
              return BlocConsumer<CommonAdCubit, CommonAdStates>(
                listener: (context, state) {
                  if (state is CommonAdSuccess) {
                    context.pushReplacement("/successfully");
                  } else if (state is CommonAdFailure) {
                    CustomSnackBar1.show(context, state.error);
                  }
                },
                builder: (context, state) {
                  return CustomAppButton1(
                    isLoading: state is CommonAdLoading,
                    text: 'Submit Ad',
                    onPlusTap: isEligible
                        ? () {
                            if (_formKey.currentState?.validate() ?? false) {
                              bool isValid = true;
                              if (_images.isEmpty) {
                                setState(() => _showimagesError = true);
                                isValid = false;
                              } else {
                                setState(() => _showimagesError = false);
                              }
                              if (selectedStateId == null) {
                                setState(() => _showStateError = true);
                                isValid = false;
                              } else {
                                setState(() => _showStateError = false);
                              }

                              if (selectedCityId == null) {
                                setState(() => _showCityError = true);
                                isValid = false;
                              } else {
                                setState(() => _showCityError = false);
                              }

                              // Validate plan
                              if (planId == null || packageId == null) {
                                setState(() => _showPaymentError = true);
                                isValid = false;
                              } else {
                                setState(() => _showPaymentError = false);
                              }

                              if (isValid) {
                                final Map<String, dynamic> data = {
                                  "title": titleController.text,
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
                                };

                                if (_images.isNotEmpty) {
                                  data["images"] = _images
                                      .map((file) => file.path)
                                      .toList();
                                }

                                context.read<CommonAdCubit>().postCommonAd(
                                  data,
                                );
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

class ImageData {
  final int id;
  final String url;

  ImageData({required this.id, required this.url});
}
