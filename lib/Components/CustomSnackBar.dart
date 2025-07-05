import 'package:flutter/material.dart';
import '../theme/AppTextStyles.dart';
import '../theme/ThemeHelper.dart';
import '../theme/app_colors.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message) {
    final textColor = ThemeHelper.textColor(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.titleSmall(Colors.black).copyWith(
            color: textColor ?? AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white,
      ),
    );
  }
}
