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

class CommonTextField1 extends StatefulWidget {
  final String hint;
  final String lable;
  final Color color;
  final double? lableFontSize;
  final FontWeight? lableFontWeight;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CommonTextField1({
    super.key,
    required this.hint,
    required this.color,
    required this.lable,
    this.maxLines = 1,
    this.controller,
    this.lableFontSize,
    this.lableFontWeight,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  @override
  State<CommonTextField1> createState() => _CommonTextField1State();
}

class _CommonTextField1State extends State<CommonTextField1> {
  bool showError = false;
  String errorKey = '';
  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          widget.lable,
          style: AppTextStyles.bodyLarge(textColor).copyWith(
            color: textColor,
            fontWeight: widget.lableFontWeight ?? FontWeight.w600,
            fontSize: widget.lableFontSize,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          style: AppTextStyles.bodyMedium(widget.color),
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (val) {
            if (widget.onChanged != null) widget.onChanged!(val);
          },
          validator: (value) {
            final validationMsg = widget.validator?.call(value);
            if (validationMsg != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  showError = true;
                  errorKey = DateTime.now().millisecondsSinceEpoch.toString();
                  errorMsg = validationMsg;
                });
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  showError = false;
                  errorMsg = '';
                });
              });
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
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

