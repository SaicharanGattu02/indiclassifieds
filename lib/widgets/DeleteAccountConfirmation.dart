import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../Components/CustomSnackBar.dart';
import '../data/cubit/DeleteAccount/DeleteAccountCubit.dart';
import '../data/cubit/DeleteAccount/DeleteAccountStates.dart';
import '../services/AuthService.dart';
import '../theme/AppTextStyles.dart';
import '../theme/ThemeHelper.dart';
import '../utils/color_constants.dart';

class DeleteAccountConfirmation {
  static void showDeleteConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: ThemeHelper.cardColor(context), // ✅ theme handled
      elevation: 8,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BlocConsumer<DeleteAccountCubit, DeleteAccountStates>(
              listener: (context, state) async {
                if (state is DeleteAccountLoaded) {
                  await AuthService.logout();
                  context.go('/login');
                  CustomSnackBar1.show(
                    context,
                    state.successModel.message ?? '',
                  );
                } else if (state is DeleteAccountFailure) {
                  CustomSnackBar1.show(context, state.error ?? '');
                }
              },
              builder: (context, state) {
                final bool isLoading = state is DeleteAccountLoading;
                final textColor = ThemeHelper.textColor(context);
                final bgColor = ThemeHelper.backgroundColor(context);
                final cardColor = ThemeHelper.cardColor(context);

                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor, // ✅ dynamic
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        'Are you sure you want to delete your account?',
                        style: AppTextStyles.titleLarge(textColor).copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'All your data, including history and preferences, will be permanently removed.',
                        style: AppTextStyles.bodyMedium(textColor.withOpacity(0.7)).copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: isLoading ? null : () => context.pop(),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: textColor.withOpacity(0.4),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.titleMedium(textColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => context.read<DeleteAccountCubit>().deleteAccount(),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  backgroundColor: primarycolor,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

