import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../model/ProductDetailsModel.dart';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewScreen extends StatelessWidget {
  final List<Images> images; // List of images passed from the main screen
  final int initialIndex; // Index of the tapped image

  PhotoViewScreen({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main image gallery
          PhotoViewGallery.builder(
            itemCount: images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index].image ?? ""),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(color: Colors.black),
            pageController: PageController(
              initialPage: initialIndex,
            ), // Set initial index
          ),
          // Watermark (bottom-right)
          Positioned(
            right: 20,
            bottom: 20,
            child: IgnorePointer(
              ignoring: true,
              child: Image.asset(
                'assets/images/watermark.png', // Same watermark as in the main widget
                width: 150, // Consistent size with the main widget
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ],
      ),
    );
  }
}