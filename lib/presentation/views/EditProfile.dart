import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../data/cubit/Profile/profile_cubit.dart';
import '../../data/cubit/UpdateProfile/update_profile_cubit.dart';
import '../../data/cubit/UpdateProfile/update_profile_states.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/color_constants.dart';
import '../../widgets/CommonTextField.dart';

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

  File? _image;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileDetails().then((userData) {
      if (userData != null) {
        debugPrint("userData:${userData.data?.email??""}");
        final data = userData.data;
        setState(() {
          _nameController.text = data?.name ?? "";
          _emailController.text = data?.email ?? "";
          _phoneController.text = data?.mobile?.toString() ?? "";
          imagePath = data?.image??"";
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
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: primarycolor),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: primarycolor),
                title: const Text("Take a Photo"),
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
      backgroundColor: Color(0xFFF2F4FD),
      appBar: CustomAppBar1(
        title: "Edit Profile",
        actions: [],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                lable:  "Name",
                hint: 'Enter Name',
                controller: _nameController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? "Name required" : null,
              ),
              CommonTextField1(
                lable:"Email",
                hint: 'Enter Email',
                controller: _emailController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? "Email required" : null,
              ), CommonTextField1(
                lable:"Phone",
                hint: 'Enter Phone',
                controller:  _phoneController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? "Email required" : null,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child:
          BlocConsumer<UpdateProfileCubit, UpdateProfileStates>(
            listener: (context, state) {
              if (state is UpdateProfileSuccess) {
                context.read<ProfileCubit>().getProfileDetails();
                CustomSnackBar1.show(
                  context,
                  state.successModel.message ?? "",
                );
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
                  onPlusTap: () {
                    if (_formKey.currentState!.validate() && !isLoading) {
                      final data = {
                        "name": _nameController.text.trim(),
                        "email": _emailController.text.trim(),
                        "phone": _phoneController.text.trim(),
                        "image": _image?.path ?? imagePath,

                      };
                      context.read<UpdateProfileCubit>().updateProfileDetails(data);
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
