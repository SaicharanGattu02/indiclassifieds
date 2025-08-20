import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/data/cubit/Ad/CommunityAd/community_ad_cubit.dart';
import 'package:indiclassifieds/data/cubit/Ad/CommunityAd/community_ad_states.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../Components/CutomAppBar.dart';
import '../../Components/ShakeWidget.dart';
import '../../data/cubit/States/states_cubit.dart';
import '../../data/cubit/States/states_repository.dart';
import '../../data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import '../../data/remote_data_source.dart';
import '../../services/AuthService.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/ImagePickerHelper.dart';
import '../../utils/planhelper.dart';
import '../../widgets/CommonTextField.dart';
import '../../widgets/SelectCityBottomSheet.dart';
import '../../widgets/SelectStateBottomSheet.dart';

class CommunityAdScreen extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;

  const CommunityAdScreen({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
  });

  @override
  State<CommunityAdScreen> createState() => _CommunityAdScreenState();
}

class _CommunityAdScreenState extends State<CommunityAdScreen> {
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
  final nameController = TextEditingController();
  final _availablePlayerSlots = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final planController = TextEditingController();


  List<File> _images = [];
  final int _maxImages = 6;
  int? planId;
  int? packageId;

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
                lable: 'Available Player slots ',
                hint: 'Enter Number',
                controller: _availablePlayerSlots,
                color: textColor,
                prefixIcon: Icon(Icons.person, color: textColor, size: 16),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Slots required' : null,
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

              _sectionTitle('Upload Product Images', textColor),
              _imagePickerSection(textColor),

              if (_showimagesError && _images.isEmpty) _imageErrorWidget(),

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
              CommonTextField1(
                lable: 'Email (Optional)',
                hint: 'Enter email',
                controller: emailController,
                color: textColor,
                prefixIcon: Icon(Icons.mail, color: textColor, size: 16),
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
                    prefixIcon: Icon(Icons.location_city_outlined,
                        color: textColor, size: 16),
                    // validator: (v) =>
                    // (v == null || v.trim().isEmpty) ? 'State required' : null,
                  ),
                ),
              ),
              if (_showStateError) _stateErrorWidget(),

              // CITY FIELD
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
                    prefixIcon: Icon(Icons.location_city_outlined,
                        color: textColor, size: 16),
                    // validator: (v) =>
                    // (v == null || v.trim().isEmpty) ? 'City required' : null,
                  ),
                ),
              ),
              if (_showCityError) _cityErrorWidget(),
              CommonTextField1(
                lable: 'Address',
                hint: 'Enter Location',
                controller: locationController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required location' : null,
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
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: FutureBuilder(
            future: AuthService.isEligibleForAd,
            builder: (context, asyncSnapshot) {
              final isEligible = asyncSnapshot.data ?? false;
              return BlocConsumer<CommunityAdCubit, CommunityAdStates>(
                listener: (context, state) {
                  if (state is CommunityAdSuccess) {
                    context.pushReplacement("/successfully");
                  } else if (state is CommunityAdFailure) {
                    CustomSnackBar1.show(context, state.error);
                  }
                },
                builder: (context, state) {
                  return CustomAppButton1(
                    isLoading: state is CommunityAdLoading,
                    text: 'Submit Ad',
                    onPlusTap: isEligible
                        ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        bool hasError = false;

                        if (_images.isEmpty) {
                          setState(() => _showimagesError = true);
                          hasError = true;
                        } else {
                          setState(() => _showimagesError = false);
                        }

                        if (selectedStateId == null) {
                          setState(() => _showStateError = true);
                          hasError = true;
                        } else {
                          setState(() => _showStateError = false);
                        }

                        if (selectedCityId == null) {
                          setState(() => _showCityError = true);
                          hasError = true;
                        } else {
                          setState(() => _showCityError = false);
                        }

                        if (hasError) return;

                        final Map<String, dynamic> data = {
                          "title": titleController.text,
                          "description": descriptionController.text,
                          "sub_category_id": widget.subCatId,
                          "category_id": widget.catId,
                          "location": locationController.text,
                          "mobile_number": phoneController.text,
                          "email": emailController.text,
                          "plan_id": planId,
                          "package_id": packageId,
                          "player_slots": _availablePlayerSlots.text,
                          "price": priceController.text,
                          "full_name": nameController.text,
                          "state_id": selectedStateId,
                          "city_id": selectedCityId,
                        };

                        if (_images.isNotEmpty) {
                          data["images"] =
                              _images.map((file) => file.path).toList();
                        }

                        context
                            .read<CommunityAdCubit>()
                            .postAstrologyAd(data);
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
        style: AppTextStyles.titleMedium(color)
            .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _imagePickerSection(Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              Icon(Icons.photo_camera,
                  color: textColor.withOpacity(0.6), size: 40),
              SizedBox(height: 8),
              Text(
                '+ Add Photos $_maxImages',
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
          if (index == _images.length && _images.length < _maxImages) {
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
                    Icon(Icons.add_photo_alternate,
                        color: textColor.withOpacity(0.6), size: 24),
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
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _imageErrorWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ShakeWidget(
        key: Key("images_error_${DateTime.now().millisecondsSinceEpoch}"),
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
    );
  }

  Widget _stateErrorWidget() {
    return Padding(
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
    );
  }

  Widget _cityErrorWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ShakeWidget(
        key: Key("dropdown_city_error_${DateTime.now().millisecondsSinceEpoch}"),
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
    );
  }
}
