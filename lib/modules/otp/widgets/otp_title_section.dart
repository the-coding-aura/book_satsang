import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Title and subtitle for the OTP verification screen.
///
/// Explains that a multi-digit OTP was sent to the user's mobile number.
class OtpTitleSection extends StatelessWidget {
  /// Creates the OTP screen title section.
  const OtpTitleSection({super.key});

  /// Builds the OTP verification heading and instructional subtitle.
  ///
  /// Copy prompts the user to enter the digits sent to their phone.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.hp(4)),
          child: Text(
            'OTP Verification',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.sp(7),
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          'Enter the 4-digit OTP sent to your mobile number.',
          style: TextStyle(
            fontSize: context.sp(4),
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
