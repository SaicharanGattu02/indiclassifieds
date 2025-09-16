import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/widgets/CommonBackground.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Components/CustomAppButton.dart';
import '../../Components/CustomSnackBar.dart';
import '../../data/cubit/LogInWithMobile/login_with_mobile.dart';
import '../../data/cubit/LogInWithMobile/login_with_mobile_state.dart';
import '../../services/AuthService.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class Otpscreen extends StatefulWidget {
  final String mobile;
  final String email;
  const Otpscreen({super.key, required this.email, required this.mobile});

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
    final isDark = ThemeHelper.isDarkMode(context);
    final textColor = ThemeHelper.textColor(context);
    final cardColor = ThemeHelper.cardColor(context);

    // Brand accents
    final gradStart = isDark
        ? const Color(0xFF111827)
        : const Color(0xFF1677FF);
    final gradEnd = isDark ? const Color(0xFF1F2937) : const Color(0xFF18345B);
    final accent = isDark ? const Color(0xFF8B5CF6) : const Color(0xFF1677FF);
    final accentSoft = isDark
        ? const Color(0xFF60A5FA)
        : const Color(0xFF0EA5E9);

    final pinIdleBorder = isDark ? Colors.white24 : const Color(0xFFE5E7EB);
    final pinActiveBorder = accent;
    final pinSelectedBorder = accentSoft;

    return Scaffold(
      body: Background(
        child: Stack(
          children: [
            // 1) FULL background gradient (guaranteed visible)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gradStart, gradEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Content
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Verify OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              shadows: [
                                Shadow(
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Enter the 6-digit code to continue",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ).copyWith(color: Colors.white.withOpacity(0.9)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          // Glass outer card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                isDark ? 0.06 : 0.12,
                              ),
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
                              children: [
                                const SizedBox(height: 16),
                                // Solid inner card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Sent to ",
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 14,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          Text(
                                            widget.mobile.isNotEmpty
                                                ? "+91 ${widget.mobile}"
                                                : widget.email,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      TextButton.icon(
                                        onPressed: () {
                                          context.pushReplacement("/login");
                                        },
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                          color: isDark
                                              ? Colors.white70
                                              : gradStart,
                                        ),
                                        label: Text(
                                          widget.mobile.isNotEmpty
                                              ? "Change number"
                                              : "Change Email",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : gradStart,
                                            fontSize: 12,
                                            fontFamily: 'Roboto',
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: isDark
                                              ? Colors.white70
                                              : gradStart,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),

                                      const SizedBox(height: 20),
                                      // OTP field wrapper
                                      PinCodeTextField(
                                        autoUnfocus: true,
                                        appContext: context,
                                        controller: _otpController,
                                        focusNode: _otpFocusNode,
                                        backgroundColor: Colors.transparent,
                                        length: 6,
                                        onChanged: _onOtpChanged,
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          fieldHeight: 40,
                                          fieldWidth: 40,
                                          fieldOuterPadding: EdgeInsets.only(
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

                                      const SizedBox(height: 14),

                                      // Resend
                                      Align(
                                        alignment: Alignment.center,
                                        child: _secondsRemaining > 0
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.schedule,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    "Resend in $_secondsRemaining sec",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Roboto',
                                                      color: isDark
                                                          ? Colors.white70
                                                          : Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : BlocBuilder<
                                                LogInwithMobileCubit,
                                                LogInWithMobileState
                                              >(
                                                builder: (context, state) {
                                                  final isLoading =
                                                      state
                                                          is LogInwithMobileLoading;
                                                  return TextButton.icon(
                                                    onPressed: isLoading
                                                        ? null
                                                        : () {
                                                            context
                                                                .read<
                                                                  LogInwithMobileCubit
                                                                >()
                                                                .postLogInWithMobile({
                                                                  "mobile": widget
                                                                      .mobile,
                                                                });
                                                            _startTimer();
                                                          },
                                                    icon: isLoading
                                                        ? const SizedBox(
                                                            height: 18,
                                                            width: 18,
                                                            child:
                                                                CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                          )
                                                        : const Icon(
                                                            Icons.refresh,
                                                          ),
                                                    label: Text(
                                                      isLoading
                                                          ? "Sending..."
                                                          : "Resend OTP",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Roboto',
                                                        color: isDark
                                                            ? Colors.white
                                                            : gradStart,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: isDark
                                                          ? Colors.white
                                                          : gradStart,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),

                                      const SizedBox(height: 18),

                                      BlocConsumer<
                                        LogInwithMobileCubit,
                                        LogInWithMobileState
                                      >(
                                        listener: (context, state) async {
                                          if (state is verifyMobileSuccess) {
                                            final data = state.verifyOtpModel;
                                            if (data.success == true) {
                                              await AuthService.saveTokens(
                                                data.accessToken ?? "",
                                                data.user?.name ?? "",
                                                data.user?.email ?? "",
                                                data.user?.mobile ?? "",
                                                data.user?.id ?? 0,
                                                data.refreshToken ?? "",
                                                data.accessTokenExpiry ?? 0,
                                                data.newUser ?? false,
                                                data.user?.state,
                                                data.user?.city,
                                                data.user?.stateId,
                                                data.user?.cityId,
                                              );
                                              if (data.newUser == true) {
                                                context.pushReplacement(
                                                  '/register?from=otp',
                                                );
                                              } else {
                                                context.pushReplacement(
                                                  '/dashboard',
                                                );
                                              }
                                            } else {
                                              if (data.code ==
                                                  "ACCOUNT_DELETED") {
                                                context.push(
                                                  "/recover_account?user_id=${data.id.toString()}",
                                                );
                                              } else {
                                                context.push(
                                                  "/blocked_account",
                                                );
                                              }
                                            }
                                          } else if (state
                                              is verifyEmailSuccess) {
                                            final data = state.verifyOtpModel;
                                            if (data.success == true) {
                                              await AuthService.saveTokens(
                                                data.accessToken ?? "",
                                                data.user?.name ?? "",
                                                data.user?.email ?? "",
                                                data.user?.mobile ?? "",
                                                data.user?.id ?? 0,
                                                data.refreshToken ?? "",
                                                data.accessTokenExpiry ?? 0,
                                                data.newUser ?? false,
                                                data.user?.state,
                                                data.user?.city,
                                                data.user?.stateId,
                                                data.user?.cityId,
                                              );
                                              if (data.newUser == true) {
                                                context.pushReplacement(
                                                  '/register?from=otp',
                                                );
                                              } else {
                                                context.pushReplacement(
                                                  '/dashboard',
                                                );
                                              }
                                            } else {
                                              if (data.code ==
                                                  "ACCOUNT_DELETED") {
                                                context.push(
                                                  "/recover_account?user_id=${data.id.toString()}",
                                                );
                                              }
                                            }
                                          } else if (state
                                              is OtpVerifyFailure) {
                                            CustomSnackBar1.show(
                                              context,
                                              state.error,
                                            );
                                          }
                                        },
                                        builder: (context, state) {
                                          final loading =
                                              state is verifyWithMobileLoading;
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 52,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Stack(
                                                children: [
                                                  Positioned.fill(
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                              colors: [
                                                                accent,
                                                                gradEnd,
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  // centered content button
                                                  ElevatedButton(
                                                    onPressed: loading
                                                        ? null
                                                        : () async {
                                                            FirebaseMessaging
                                                            messaging =
                                                                FirebaseMessaging
                                                                    .instance;
                                                            String? fcmToken =
                                                                await messaging
                                                                    .getToken();

                                                            final otp =
                                                                _otpController
                                                                    .text
                                                                    .trim();
                                                            final msg =
                                                                _validateOtp(
                                                                  otp,
                                                                );
                                                            if (msg != null) {
                                                              CustomSnackBar.show(
                                                                context,
                                                                msg,
                                                              );
                                                              return;
                                                            }

                                                            // ✅ handle null fcm token gracefully
                                                            if (fcmToken ==
                                                                    null ||
                                                                fcmToken
                                                                    .isEmpty) {
                                                              debugPrint(
                                                                "⚠️ FCM token is null/empty, sending without it",
                                                              );
                                                              CustomSnackBar.show(
                                                                context,
                                                                '⚠️ FCM token is null/empty, sending without it',
                                                              );
                                                            }
                                                            if (widget
                                                                .mobile
                                                                .isNotEmpty) {
                                                              context
                                                                  .read<
                                                                    LogInwithMobileCubit
                                                                  >()
                                                                  .verifyLoginOtp({
                                                                    "mobile": widget
                                                                        .mobile,
                                                                    "otp": otp,
                                                                    "fcm_token":
                                                                        fcmToken ??
                                                                        "",
                                                                    "fcm_type":
                                                                        "app",
                                                                  });
                                                            } else {
                                                              context
                                                                  .read<
                                                                    LogInwithMobileCubit
                                                                  >()
                                                                  .verifyEmailLoginOtp({
                                                                    "email": widget
                                                                        .email,
                                                                    "otp":
                                                                        int.parse(
                                                                          otp,
                                                                        ),
                                                                    "fcm_token":
                                                                        fcmToken ??
                                                                        "",
                                                                    "fcm_type":
                                                                        "app",
                                                                  });
                                                            }
                                                          },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      shadowColor:
                                                          Colors.transparent,
                                                      surfaceTintColor:
                                                          Colors.transparent,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: loading
                                                          ? const SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            )
                                                          : Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Icon(
                                                                  Icons
                                                                      .verified_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  "Verify & Continue",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.lock_outline,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Your code is safe and encrypted",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
