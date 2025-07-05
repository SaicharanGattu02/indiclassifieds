import 'package:flutter/material.dart';
import '../theme/AppTextStyles.dart';
import '../Components/ShakeWidget.dart';
import '../theme/ThemeHelper.dart';

class CommonTextField extends StatelessWidget {
  final String hint;
  final Color color;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showError;
  final String errorKey;
  final String errorMsg;

  const CommonTextField({
    super.key,
    required this.hint,
    required this.color,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.showError = false,
    this.errorKey = '',
    this.errorMsg = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          style: AppTextStyles.bodyMedium(color),
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium(color.withOpacity(0.6)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ShakeWidget(
              key: Key(errorKey),
              duration: const Duration(milliseconds: 700),
              child: Text(
                errorMsg,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}


class CommonTextField1 extends StatelessWidget {
  final String hint;
  final String lable;
  final Color color;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool showError;
  final String errorKey;
  final String errorMsg;

  const CommonTextField1({
    super.key,
    required this.hint,
    required this.color,
    required this.lable,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.showError = false,
    this.errorKey = '',
    this.errorMsg = '',
  });

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          lable,
          style: AppTextStyles.bodyLarge(textColor).copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: showError ? Colors.red : const Color(0xFFE5E7EB),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextFormField(
            style: AppTextStyles.bodyMedium(color),
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppTextStyles.bodyMedium(color.withOpacity(0.6)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ShakeWidget(
              key: Key(errorKey),
              duration: const Duration(milliseconds: 700),
              child: Text(
                errorMsg,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

