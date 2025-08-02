import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/widgets/CommonBackground.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../data/cubit/LogInWithMobileCubit/login_with_mobile.dart';
import '../../data/cubit/LogInWithMobileCubit/login_with_mobile_state.dart';
import '../../services/AuthService.dart';
import '../../theme/ThemeHelper.dart';

class Otpscreen extends StatefulWidget {
  final String mobile;
  const Otpscreen({super.key, required this.mobile});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  Timer? _timer;
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpFocusNode.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _validateOtp(String otp) {
    if (otp.length < 6) {
      return 'Please enter a 6-digit OTP';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  void _onOtpChanged(String otp) {
    if (_validateOtp(otp) == null && mounted) {
      _otpFocusNode.unfocus();
    }
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDark = ThemeHelper.isDarkMode(context);

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/appLogo.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Sent to ",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      color: isDark ? Colors.white : const Color(0xff4B5563),
                    ),
                    children: [
                      TextSpan(
                        text: "+91 ${widget.mobile}",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xff1F2937),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // OTP Input
                PinCodeTextField(
                  autoUnfocus: true,
                  appContext: context,
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  length: 6,
                  onChanged: _onOtpChanged,
                  animationType: AnimationType.fade,
                  hapticFeedbackTypes: HapticFeedbackTypes.heavy,
                  cursorColor: Colors.grey[300],
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  useExternalAutoFillGroup: true,
                  beforeTextPaste: (text) => true,
                  autoFocus: true,
                  autoDismissKeyboard: false,
                  showCursor: true,
                  pastedTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 48,
                    fieldWidth: 48,
                    fieldOuterPadding: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    activeFillColor: Colors.white,
                    activeColor: const Color(0xFF636363),
                    selectedColor: Colors.grey,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    inactiveColor: Color(0xFFD2D2D2),
                    inactiveBorderWidth: 1,
                    selectedBorderWidth: 1.5,
                    activeBorderWidth: 1.5,
                  ),
                  textStyle: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: Platform.isAndroid
                      ? TextInputAction.none
                      : TextInputAction.done,
                ),

                const SizedBox(height: 20),

                // Resend OTP section
                Align(
                  alignment: Alignment.center,
                  child: _secondsRemaining > 0
                      ? Text(
                          "Resend OTP in $_secondsRemaining sec",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: isDark
                                ? Colors.white
                                : const Color(0xff4B5563),
                          ),
                        )
                      : BlocBuilder<LogInwithMobileCubit, LogInWithMobileState>(
                          builder: (context, state) {
                            final isLoading = state is LogInwithMobileLoading;
                            return TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      final data = {"mobile": widget.mobile};
                                      context
                                          .read<LogInwithMobileCubit>()
                                          .postLogInWithMobile(data);
                                      _startTimer();
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "Resend OTP",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xff4B5563),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 20),

                BlocConsumer<LogInwithMobileCubit, LogInWithMobileState>(
                  listener: (context, state) async {
                    if (state is verifyMobileSuccess) {
                      final tokens = state.verifyOtpModel;
                      await AuthService.saveTokens(tokens.token ?? "", "", 0);
                      context.pushReplacement('/dashboard');
                    } else if (state is OtpVerifyFailure) {
                      CustomSnackBar1.show(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return CustomAppButton1(
                      isLoading: state is verifyWithMobileLoading,
                      text: "Verify & Continue",
                      onPlusTap: () {
                        final otp = _otpController.text.trim();
                        final validationMsg = _validateOtp(otp);
                        if (validationMsg != null) {
                          CustomSnackBar.show(context, validationMsg);
                          return;
                        }
                        final data = {"mobile": widget.mobile, "otp": otp};
                        context.read<LogInwithMobileCubit>().verifyLoginOtp(
                          data,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
