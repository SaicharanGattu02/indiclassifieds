import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Components/CustomSnackBar.dart';
import '../../data/cubit/LogInWithMobile/login_with_mobile.dart';
import '../../data/cubit/LogInWithMobile/login_with_mobile_state.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';

class EmailLoginscreen extends StatefulWidget {
  const EmailLoginscreen({super.key});

  @override
  State<EmailLoginscreen> createState() => _EmailLoginscreenState();
}

class _EmailLoginscreenState extends State<EmailLoginscreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final textColor = ThemeHelper.textColor(context);
    final bgColor = ThemeHelper.backgroundColor(context);
    final cardColor = ThemeHelper.cardColor(context);

    final gradStart = isDark
        ? const Color(0xFF111827)
        : const Color(0xFF1677FF);
    final gradEnd = isDark ? const Color(0xFF1F2937) : const Color(0xFF18345B);
    final accent = isDark ? const Color(0xFF8B5CF6) : const Color(0xFF1677FF);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradStart, gradEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                24,
                kToolbarHeight + 48,
                24,
                48,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Headline with gradient shader
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [accent, Colors.white.withOpacity(0.85)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineMedium(
                          Colors.white,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to continue your journey",
                      style: AppTextStyles.titleMedium(
                        Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Glass outer card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isDark ? 0.06 : 0.12),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Inner solid card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Email field
                                CommonTextField1(
                                  lable: "Email",
                                  hint: "Enter your Email",
                                  controller: _emailController,
                                  color: textColor,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Email required';
                                    } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                                    ).hasMatch(v.trim())) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                BlocConsumer<
                                  LogInwithMobileCubit,
                                  LogInWithMobileState
                                >(
                                  listener: (context, state) {
                                    if (state is LogInwithEmailSuccess) {
                                      context.pushReplacement(
                                        '/otp?email=${_emailController.text}',
                                      );
                                    } else if (state
                                        is LogInwithMobileFailure) {
                                      // CustomSnackBar.show(
                                      //   context,
                                      //   state.error ??
                                      //       "Failed to send OTP. Try again.",
                                      // );
                                      showNotRegisteredDialog(context);
                                    }
                                  },
                                  builder: (context, state) {
                                    final bool loading =
                                        state is LogInwithMobileLoading;
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [accent, gradEnd],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: loading
                                              ? null
                                              : () {
                                                  final email = _emailController
                                                      .text
                                                      .trim();
                                                  if (email.isEmpty) {
                                                    CustomSnackBar.show(
                                                      context,
                                                      "Email is required",
                                                    );
                                                  } else if (!RegExp(
                                                    r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                                                  ).hasMatch(email)) {
                                                    CustomSnackBar.show(
                                                      context,
                                                      "Enter a valid email",
                                                    );
                                                  } else {
                                                    context
                                                        .read<
                                                          LogInwithMobileCubit
                                                        >()
                                                        .postLogInWithEmail({
                                                          "email": email,
                                                        });
                                                  }
                                                },
                                          icon: loading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : const Icon(
                                                  Icons.email_outlined,
                                                ),
                                          label: Text(
                                            loading
                                                ? "Sending OTP..."
                                                : "Send OTP",
                                            style:
                                                AppTextStyles.titleMedium(
                                                  Colors.white,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    "OR",
                                    style: AppTextStyles.bodyLarge(textColor),
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      context.pushReplacement("/login");
                                    },
                                    child: Text(
                                      "Login With Mobile Number",
                                      style: AppTextStyles.titleSmall(textColor)
                                          .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: textColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Terms
                    Text.rich(
                      TextSpan(
                        text: "By continuing, you agree to our ",
                        style: AppTextStyles.bodySmall(
                          Colors.white.withOpacity(0.9),
                        ),
                        children: [
                          TextSpan(
                            text: "Terms & Conditions",
                            style: AppTextStyles.bodySmall(Colors.white)
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showNotRegisteredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  "Email Not Registered",
                  style: AppTextStyles.titleLarge(
                    Colors.black,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  "We couldn’t find an account with this email.\n"
                  "But don’t worry! You can log in easily using your mobile number.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(Colors.grey[700]!),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pushReplacement("/login");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Login with Mobile",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
