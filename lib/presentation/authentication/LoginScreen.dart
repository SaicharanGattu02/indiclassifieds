import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/Components/CustomSnackBar.dart';
import 'package:indiclassifieds/data/cubit/LogInWithMobile/login_with_mobile.dart';
import 'package:indiclassifieds/data/cubit/LogInWithMobile/login_with_mobile_state.dart';
import 'package:indiclassifieds/widgets/CommonTextField.dart';
import '../../Components/CustomAppButton.dart';
import '../../theme/ThemeHelper.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDarkMode = ThemeHelper.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF1677FF), Color(0xFF18345B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  "Welcome Back 👋",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Roboto',
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Login to continue your journey",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                decoration: BoxDecoration(
                  color:  isDarkMode ? Colors.black : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // CommonTextField1(
                    //   lable: 'Phone Number',
                    //   hint: 'Enter phone number',
                    //   controller: _phoneController,
                    //   color: textColor,
                    //   keyboardType: TextInputType.phone,
                    //   prefixIcon: Icon(Icons.call, color: textColor, size: 16),
                    //   validator: (v) =>
                    //   (v == null || v.trim().isEmpty) ? 'Phone required' : null,
                    // ),
                    CommonTextField1( validator: (v) =>
                      (v == null || v.trim().isEmpty) ?
                      'Phone required' : null,
                      hint: "Enter Number",
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      color: textColor,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "+91",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ), lable:"Mobile Number",
                    ),
                    const SizedBox(height: 20),

                    BlocConsumer<LogInwithMobileCubit, LogInWithMobileState>(
                      listener: (context, state) {
                        if (state is LogInwithMobileSuccess) {
                          context.pushReplacement(
                            '/otp?mobile=${_phoneController.text ?? ""}',
                          );
                        }else{
                          CustomSnackBar1();
                        }
                      },
                      builder: (context, state) {
                        return CustomAppButton1(
                          isLoading: state is LogInwithMobileLoading,
                          text: "Send OTP",
                          onPlusTap: () {
                            final phone = _phoneController.text.trim();
                            if (phone.isEmpty) {
                              CustomSnackBar.show(
                                context,
                                "Phone number is required",
                              );
                            } else if (!RegExp(
                              r'^[0-9]{10}$',
                            ).hasMatch(phone)) {
                              CustomSnackBar.show(
                                context,
                                "Enter a valid 10-digit phone number",
                              );
                            } else {
                              final Map<String, dynamic> data = {
                                "mobile": _phoneController.text,
                              };
                              context
                                  .read<LogInwithMobileCubit>()
                                  .postLogInWithMobile(data);
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Text.rich(
                TextSpan(
                  text: "By continuing, you agree to our ",
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    color: Color(0xff4B5563),
                  ),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1677FF),
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
    );
  }
}
