import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/Components/CustomAppButton.dart';
import 'package:indiclassifieds/Components/CustomSnackBar.dart';
import 'package:indiclassifieds/data/cubit/Register/register_cubit.dart';
import 'package:indiclassifieds/data/cubit/Register/register_states.dart';
import 'package:indiclassifieds/services/AuthService.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../data/cubit/EmailVerification/EmailVerificationCubit.dart';
import '../../data/cubit/EmailVerification/EmailVerificationStates.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class RegisterUserDetailsScreen extends StatefulWidget {
  final String from;
  const RegisterUserDetailsScreen({super.key, required this.from});
  @override
  State<RegisterUserDetailsScreen> createState() =>
      _RegisterUserDetailsScreenState();
}

class _RegisterUserDetailsScreenState extends State<RegisterUserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: '');
  final _emailCtrl = TextEditingController(text: '');
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final TextEditingController _otpController = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    Map<String, dynamic> data = {
      "name": _nameCtrl.text,
      "email": _emailCtrl.text,
    };
    context.read<RegisterCubit>().register(data);
  }

  String? _validateName(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Please enter your name';
    if (t.length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? _validateEmail(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w\.\-+%]+@[\w\.\-]+\.[A-Za-z]{2,}$');
    if (!emailRegex.hasMatch(t)) return 'Enter a valid email address';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // THEME-DRIVEN COLORS
    final isDark = ThemeHelper.isDarkMode(context);
    final bgColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);
    final cardColor = ThemeHelper.cardColor(context);

    // Accent/brand hues for gradients & focus states
    final gradStart = isDark
        ? const Color(0xFF111827)
        : const Color(0xFF3B82F6); // slate-900 vs blue-500
    final gradEnd = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFF8B5CF6); // slate-800 vs violet-500
    final accent = isDark ? const Color(0xFF8B5CF6) : const Color(0xFF3B82F6);

    final accentSoft = isDark
        ? const Color(0xFF60A5FA)
        : const Color(0xFF0EA5E9);
    final pinIdleBorder = isDark ? Colors.white24 : const Color(0xFFE5E7EB);
    final pinActiveBorder = accent;
    final pinSelectedBorder = accentSoft;

    // Borders for inputs
    OutlineInputBorder _outline(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: 1),
    );

    final idleBorder = _outline(isDark ? Colors.white24 : Colors.black12);
    final focusedBorder = _outline(accent);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Register User Details',
          style: AppTextStyles.titleLarge(
            textColor,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Stack(
        children: [
          // THEMED GRADIENT BACKDROP
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradStart, gradEnd],
              ),
            ),
          ),

          // CONTENT
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                kToolbarHeight + 40,
                20,
                20,
              ),
              child: Column(
                children: [
                  // HEADLINE
                  Text(
                    'Let’s get you set up',
                    style: AppTextStyles.headlineMedium(
                      Colors.white,
                    ).copyWith(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Provide your name and email to continue',
                    style: AppTextStyles.bodyMedium(
                      Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // GLASS CARD (outer)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 30,
                          offset: const Offset(0, 18),
                        ),
                      ],
                      backgroundBlendMode: BlendMode.overlay,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // INNER CARD (form)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _LabeledField(
                                  label: 'Full Name',
                                  labelStyle: AppTextStyles.labelLarge(
                                    textColor,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                  child: TextFormField(
                                    controller: _nameCtrl,
                                    focusNode: _nameFocus,
                                    style: AppTextStyles.bodyMedium(
                                      ThemeHelper.textColor(context),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.name],
                                    validator: _validateName,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.badge_outlined,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                      hintText: 'Enter your full name',
                                      hintStyle: AppTextStyles.bodyMedium(
                                        isDark
                                            ? Colors.white60
                                            : Colors.black45,
                                      ),
                                      border: idleBorder,
                                      enabledBorder: idleBorder,
                                      focusedBorder: focusedBorder,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _LabeledField(
                                  label: 'Email Address',
                                  labelStyle: AppTextStyles.labelLarge(
                                    textColor,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                  child: TextFormField(
                                    controller: _emailCtrl,
                                    focusNode: _emailFocus,
                                    style: AppTextStyles.bodyMedium(
                                      ThemeHelper.textColor(context),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [AutofillHints.email],
                                    validator: _validateEmail,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.alternate_email,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                      hintText: 'name@example.com',
                                      hintStyle: AppTextStyles.bodyMedium(
                                        isDark
                                            ? Colors.white60
                                            : Colors.black45,
                                      ),
                                      border: idleBorder,
                                      enabledBorder: idleBorder,
                                      focusedBorder: focusedBorder,
                                    ),
                                    onFieldSubmitted: (_) => _submit(),
                                  ),
                                ),
                                BlocConsumer<
                                  EmailVerificationCubit,
                                  EmailVerificationStates
                                >(
                                  listener: (context, state) {
                                    if (state is SendOTPSuccess) {
                                      // OTP sent successfully
                                      CustomSnackBar1.show(
                                        context,
                                        "OTP sent to ${_emailCtrl.text}",
                                      );
                                    } else if (state is SendOTPFailure) {
                                      // Failed to send OTP
                                      CustomSnackBar1.show(
                                        context,
                                        "${state.error}",
                                      );
                                    } else if (state is VerifyOTPSuccess) {
                                      // OTP verified successfully
                                      CustomSnackBar1.show(
                                        context,
                                        "OTP Verified Successfully!",
                                      );
                                      // Navigate to next screen if needed
                                    } else if (state is VerifyOTPFailure) {
                                      // Failed to verify OTP
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(state.error)),
                                      );
                                      CustomSnackBar1.show(
                                        context,
                                        "${state.error}",
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    final isSending = state is SendOTPLoading;
                                    final isVerifying =
                                        state is VerifyOTPLoading;

                                    // Determine if OTP has been sent
                                    final otpSent =
                                        state is SendOTPSuccess ||
                                        state is VerifyOTPLoading ||
                                        state is VerifyOTPFailure;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Send OTP button (hide after OTP is sent)
                                        // if (!otpSent)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: TextButton(
                                            onPressed: isSending
                                                ? null
                                                : () {
                                                    context
                                                        .read<
                                                          EmailVerificationCubit
                                                        >()
                                                        .sendOTP({
                                                          "email":
                                                              _emailCtrl.text,
                                                        });
                                                  },
                                            child: isSending
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : Text(
                                                    "Send OTP",
                                                    style:
                                                        AppTextStyles.titleMedium(
                                                          textColor,
                                                        ),
                                                  ),
                                          ),
                                        ),

                                        // OTP input field (show only after OTP is sent)
                                        if (otpSent) ...[
                                          SizedBox(height: 25),
                                          PinCodeTextField(
                                            autoUnfocus: true,
                                            appContext: context,
                                            controller: _otpController,
                                            backgroundColor: Colors.transparent,
                                            length: 6,
                                            animationType: AnimationType.fade,
                                            hapticFeedbackTypes:
                                                HapticFeedbackTypes.heavy,
                                            cursorColor: isDark
                                                ? Colors.white70
                                                : Colors.grey[700],
                                            keyboardType: TextInputType.number,
                                            enableActiveFill: true,
                                            useExternalAutoFillGroup: true,
                                            beforeTextPaste: (text) => true,
                                            autoFocus: true,
                                            autoDismissKeyboard: false,
                                            showCursor: true,
                                            pastedTextStyle: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                            ),
                                            pinTheme: PinTheme(
                                              shape: PinCodeFieldShape.box,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              fieldHeight: 40,
                                              fieldWidth: 40,
                                              fieldOuterPadding:
                                                  const EdgeInsets.only(
                                                    right: 2,
                                                  ),
                                              activeFillColor: isDark
                                                  ? const Color(0xFF131A22)
                                                  : Colors.white,
                                              selectedFillColor: isDark
                                                  ? const Color(0xFF131A22)
                                                  : Colors.white,
                                              inactiveFillColor: isDark
                                                  ? const Color(0xFF0D141B)
                                                  : Colors.white,
                                              activeColor: pinActiveBorder,
                                              selectedColor: pinSelectedBorder,
                                              inactiveColor: pinIdleBorder,
                                              activeBorderWidth: 1.6,
                                              selectedBorderWidth: 1.6,
                                              inactiveBorderWidth: 1.1,
                                            ),
                                            textStyle: TextStyle(
                                              color: textColor,
                                              fontSize: 17,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            textInputAction: Platform.isAndroid
                                                ? TextInputAction.none
                                                : TextInputAction.done,
                                          ),
                                        ],
                                        // Verify OTP button (show only after OTP is sent)
                                        if (otpSent)
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: TextButton(
                                              onPressed: isVerifying
                                                  ? null
                                                  : () {
                                                      context
                                                          .read<
                                                            EmailVerificationCubit
                                                          >()
                                                          .verifyOTP({
                                                            "email":
                                                                _emailCtrl.text,
                                                            "otp": int.parse(
                                                              _otpController
                                                                  .text,
                                                            ),
                                                          });
                                                    },
                                              child: isVerifying
                                                  ? const SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    )
                                                  : Text(
                                                      "Verify OTP",
                                                      style:
                                                          AppTextStyles.titleMedium(
                                                            textColor,
                                                          ),
                                                    ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                BlocConsumer<RegisterCubit, RegisterStates>(
                                  listener: (context, state) {
                                    if (state is RegisterLoaded) {
                                      if (widget.from == "ad") {
                                        context.pop();
                                      } else {
                                        context.pushReplacement("/dashboard");
                                      }
                                      AuthService.setUserStatus("false");
                                    } else if (state is RegisterFailure) {
                                      CustomSnackBar1.show(
                                        context,
                                        state.error,
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    final isLoading = state is RegisterLoading;
                                    return CustomAppButton1(
                                      text: "Submit",
                                      isLoading: isLoading,
                                      onPlusTap: () {
                                        _submit();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
    this.labelStyle,
  });

  final String label;
  final Widget child;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
