import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// App logo shown at the top of the OTP verification screen.
class OtpLogoHeader extends StatelessWidget {
  /// Creates the OTP screen logo header.
  const OtpLogoHeader({super.key});

  /// Builds the centered app logo image for the OTP screen.
  ///
  /// Sized responsively using width and height percentage helpers.
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/logo.png',
      height: context.hp(15),
      width: context.wp(55),
      fit: BoxFit.cover,
    );
  }
}
