import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../model/ProductDetailsModel.dart';

class PhotoViewScreen extends StatelessWidget {
  final List<Images> images; // List of images passed from the main screen
  final int initialIndex; // Index of the tapped image

  PhotoViewScreen({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              images[index].image ?? "",
            ),
            minScale:
                PhotoViewComputedScale.contained, // Allows zoom-in and zoom-out
            maxScale: PhotoViewComputedScale.covered,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        pageController: PageController(
          initialPage: initialIndex,
        ), // Set initial index
      ),
    );
  }
}
