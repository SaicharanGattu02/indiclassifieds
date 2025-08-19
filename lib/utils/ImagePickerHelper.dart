import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'ImageUtils.dart';
import 'package:flutter/material.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery
  static Future<File?> pickImageFromGallery(BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return _processPickedFile(pickedFile, context);
  }

  // Function to pick an image from camera
  static Future<File?> pickImageFromCamera(BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return _processPickedFile(pickedFile, context);
  }

  // Process the picked file and return it as a compressed file
  static Future<File?> _processPickedFile(XFile? pickedFile, BuildContext context) async {
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(File(pickedFile.path));
      return compressedFile;
    }
    return null;
  }

  // Function to show the modal bottom sheet for picking an image
  static Future<void> showImagePickerBottomSheet({
    required BuildContext context,
    required Function(File) onImageSelected,
    int maxImages = 6,
    required List<File> images,
  }) async {
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
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
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
                  leading: Icon(Icons.photo_library, color: Colors.blue),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final File? selectedImage = await pickImageFromGallery(context);
                    if (selectedImage != null && images.length < maxImages) {
                      onImageSelected(selectedImage);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.blue),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final File? selectedImage = await pickImageFromCamera(context);
                    if (selectedImage != null && images.length < maxImages) {
                      onImageSelected(selectedImage);
                    }
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
}

