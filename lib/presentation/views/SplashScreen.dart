import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:classifieds/widgets/CommonBackground.dart';

import '../../services/AuthService.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
    requestTrackingPermission();
  }

  Future<void> requestTrackingPermission() async {
    if (Platform.isIOS) {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        // Show a pre-permission message (optional)
        await Future.delayed(const Duration(milliseconds: 200));
        final result = await AppTrackingTransparency.requestTrackingAuthorization();
        print("ATT Permission result: $result");
      } else {
        print("ATT already determined: $status");
      }
    }
  }

  Future<void> _initialize() async {
    final token = await AuthService.getAccessToken();
    Future.delayed(Duration(seconds: 2), () {
      context.pushReplacement("/dashboard");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F5),
      body: Background(
        child: Center(
          child: Image.asset(
            "assets/images/appLogo.png",
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
