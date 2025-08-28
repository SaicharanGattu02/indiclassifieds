import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';
import 'package:indiclassifieds/widgets/CommonLoader.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../Components/ShakeWidget.dart';
import '../../data/cubit/Profile/profile_cubit.dart';
import '../../data/cubit/States/states_cubit.dart';
import '../../data/cubit/States/states_repository.dart';
import '../../data/cubit/UpdateProfile/update_profile_cubit.dart';
import '../../data/cubit/UpdateProfile/update_profile_states.dart';
import '../../data/remote_data_source.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/color_constants.dart';
import '../../widgets/CommonTextField.dart';
import '../../widgets/SelectCityBottomSheet.dart';
import '../../widgets/SelectStateBottomSheet.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  int? selectedStateId;
  int? selectedCityId;

  File? _image;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileDetails().then((userData) {
      if (userData != null) {
        debugPrint("userData:${userData.data?.email ?? ""}");
        final data = userData.data;
        setState(() {
          _nameController.text = data?.name ?? "";
          _emailController.text = data?.email ?? "";
          _phoneController.text = data?.mobile?.toString() ?? "";
          stateController.text = data?.state_name?.toString() ?? "";
          selectedStateId = data?.state_id ?? 0;
          selectedCityId = data?.city_id ?? 0;
          cityController.text = data?.city_name?.toString() ?? "";
          _phoneController.text = data?.mobile?.toString() ?? "";
          imagePath = data?.image ?? "";
        });
      }
      setState(() => isLoading = false);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      backgroundColor: ThemeHelper.backgroundColor(context),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: primarycolor),
                title: Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: primarycolor),
                title: Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
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
        setState(() => _image = compressedFile);
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
        setState(() => _image = compressedFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: "Edit Profile", actions: []),
      body: isLoading
          ? const Center(child: DottedProgressWithLogo())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Pic
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : (imagePath?.startsWith('http') ?? false)
                              ? CachedNetworkImageProvider(imagePath!)
                              : const AssetImage('assets/images/profile.png')
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primarycolor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CommonTextField1(
                      lable: "Name",
                      hint: 'Enter Name',
                      controller: _nameController,
                      color: textColor,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? "Name required"
                          : null,
                    ),
                    CommonTextField1(
                      lable: "Email",
                      hint: 'Enter Email',
                      controller: _emailController,
                      color: textColor,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? "Email required"
                          : null,
                    ),
                    CommonTextField1(
                      lable: "Phone",
                      hint: 'Enter Phone',
                      controller: _phoneController,
                      color: textColor,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? "Phone Number required"
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
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: BlocConsumer<UpdateProfileCubit, UpdateProfileStates>(
            listener: (context, state) {
              if (state is UpdateProfileSuccess) {
                context.read<ProfileCubit>().getProfileDetails();
                CustomSnackBar1.show(context, state.successModel.message ?? "");
                context.pop();
              } else if (state is UpdateProfileFailure) {
                CustomSnackBar1.show(context, state.error ?? "");
              }
            },
            builder: (context, state) {
              final isLoading = state is UpdateProfileLoading;
              return SizedBox(
                width: double.infinity,
                child: CustomAppButton1(
                  text: isLoading ? "Updating..." : "Submit",
                  onPlusTap: isLoading
                      ? null
                      : () {
                          // Form validation
                          if (_formKey.currentState?.validate() ?? false) {
                            print("Form is valid");

                            // Ensure name and email are not empty
                            if (_nameController.text.trim().isEmpty) {
                              CustomSnackBar1.show(
                                context,
                                "Name is required.",
                              );
                              return;
                            }

                            if (_emailController.text.trim().isEmpty) {
                              CustomSnackBar1.show(
                                context,
                                "Email is required.",
                              );
                              return;
                            }

                            // Ensure state and city IDs are not null or invalid
                            if (selectedStateId == null ||
                                selectedStateId == 0) {
                              CustomSnackBar1.show(
                                context,
                                "Please select a valid state.",
                              );
                              return;
                            }
                            if (selectedCityId == null || selectedCityId == 0) {
                              CustomSnackBar1.show(
                                context,
                                "Please select a valid city.",
                              );
                              return;
                            }
                            // Collect data and make the API call
                            String? imageToSend;
                            if (_image != null && _image!.path.isNotEmpty) {
                              imageToSend = _image!.path;
                            } else if (imagePath != null) {
                              imageToSend = imagePath;
                            } else {
                              imageToSend =
                                  ""; // or leave null if no image is selected
                            }

                            final data = {
                              "name": _nameController.text.trim(),
                              "email": _emailController.text.trim(),
                              "mobile": _phoneController.text.trim(),
                              "image": imageToSend,
                              "state_id": selectedStateId, // Optional or null
                              "city_id": selectedCityId, // Optional or null
                            };

                            // Call the update profile API
                            context
                                .read<UpdateProfileCubit>()
                                .updateProfileDetails(data);
                          } else {
                            // If form validation fails, show an error message
                            print("Form is invalid");
                            CustomSnackBar1.show(
                              context,
                              "Please fill all the required fields correctly.",
                            );
                          }
                        },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
