import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'AppTextStyles.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.compact,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  scaffoldBackgroundColor: Colors.black,
  dialogBackgroundColor: Colors.white,
  cardColor: Colors.white,
  searchBarTheme: const SearchBarThemeData(),
  tabBarTheme: const TabBarThemeData(),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    errorStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13,
      color: Colors.red,
    ),
  ),
  dialogTheme: const DialogThemeData(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
  ),
  buttonTheme: const ButtonThemeData(),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
    shadowColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    shadowColor: Colors.white,
    foregroundColor: Colors.white,
  ),
  cardTheme: CardThemeData(
    shadowColor: Colors.white,
    surfaceTintColor: Colors.white,
    color: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(style: ButtonStyle()),
  elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle()),
  outlinedButtonTheme: OutlinedButtonThemeData(style: ButtonStyle()),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.white, // 🔴 Add this
    background: Colors.white,
  ).copyWith(background: Colors.white),
  // Optionally, set directly as fallback
  primaryColor: Colors.white,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge(AppColors.darkText),
    displayMedium: AppTextStyles.displayMedium(AppColors.darkText),
    displaySmall: AppTextStyles.displaySmall(AppColors.darkText),
    headlineLarge: AppTextStyles.headlineLarge(AppColors.darkText),
    headlineMedium: AppTextStyles.headlineMedium(AppColors.darkText),
    headlineSmall: AppTextStyles.headlineSmall(AppColors.darkText),
    titleLarge: AppTextStyles.titleLarge(AppColors.darkText),
    titleMedium: AppTextStyles.titleMedium(AppColors.darkText),
    titleSmall: AppTextStyles.titleSmall(AppColors.darkText),
    bodyLarge: AppTextStyles.bodyLarge(AppColors.darkText),
    bodyMedium: AppTextStyles.bodyMedium(AppColors.darkText),
    bodySmall: AppTextStyles.bodySmall(AppColors.darkText),
    labelLarge: AppTextStyles.labelLarge(AppColors.darkText),
    labelMedium: AppTextStyles.labelMedium(AppColors.darkText),
    labelSmall: AppTextStyles.labelSmall(AppColors.darkText),
  ),
);
