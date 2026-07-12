import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Factory for application [ThemeData] configurations.
///
/// Centralizes Material 3 styling for scaffold, navigation, inputs, and buttons.
class AppTheme {
  AppTheme._();

  /// Light theme applied to the root [MaterialApp].
  ///
  /// Uses [AppColors] for seed, input decoration, and elevated button styling.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: AppColors.primary),
        unselectedIconTheme: IconThemeData(color: AppColors.primaryLight),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primaryLight,
        // selectedLabelStyle: TextStyle(
        //   color: AppColors.labelColor,
        //   fontWeight: FontWeight.w700,
        // ),
        // unselectedLabelStyle: TextStyle(
        //   color: AppColors.labelColor.withAlpha(100),
        //   fontWeight: FontWeight.w400,
        // ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        labelStyle: const TextStyle(color: AppColors.labelColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
