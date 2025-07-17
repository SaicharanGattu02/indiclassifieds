import 'package:flutter/material.dart';
import 'package:indiclassifieds/theme/AppTextStyles.dart';

import '../../Components/CustomAppButton.dart';
import '../../theme/ThemeHelper.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final backgroundColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Phone Number", style: AppTextStyles.headlineLarge(textColor)),
            Center(
              child: Text(
                "Please enter your phone number to verify your account",
                style: AppTextStyles.bodyLarge(textColor),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Enter Mobile Number"),
            ),
            CustomAppButton1(text: 'Continue', onPlusTap: () {}),
          ],
        ),
      ),
    );
  }
}
