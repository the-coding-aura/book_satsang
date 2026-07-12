import 'package:flutter/material.dart';

/// Application-wide color palette for branding and UI components.
///
/// Provides shared [Color] values for themes, inputs, errors, and flushbars.
class AppColors {
  AppColors._();

  /// Primary brand color used for accents and key actions.
  static const Color primary = Color(0xFFFF6B35);

  /// Lighter variant of the primary brand color.
  static const Color primaryLight = Color(0xFFFF8C00);

  /// Background fill color for text input fields.
  static const Color inputFill = Color(0xFFF5F5F5);

  /// Default border color for text input fields.
  static const Color inputBorder = Color(0xFFE0E0E0);

  /// Default color for form field labels.
  static const Color labelColor = Color(0xFF373636);

  /// Color used for validation and error states.
  static const Color errorColor = Colors.red;

  /// Background color for success flushbar notifications.
  static const Color flushbarSuccess = Color(0xFF2E7D32);

  /// Background color for warning flushbar notifications.
  static const Color flushbarWarning = Color(0xFFF57C00);

  /// Background color for error flushbar notifications.
  static const Color flushbarError = Color(0xFFB71C1C);
}
