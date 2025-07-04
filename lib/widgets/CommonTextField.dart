import 'package:flutter/material.dart';

import '../theme/AppTextStyles.dart';

class CommonTextField extends StatelessWidget {
  final String hint;
  final Color color;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;

  const CommonTextField({
    super.key,
    required this.hint,
    required this.color,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppTextStyles.bodyMedium(color),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium(color.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
