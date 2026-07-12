import 'package:book_satsang/utils/constants/app_constants.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

/// Pin-style input for entering the OTP digits.
///
/// Invokes [onCompleted] when all [AppConstants.otpLength] digits are entered.
class OtpPinInput extends StatelessWidget {
  /// Creates the OTP pin input field.
  const OtpPinInput({
    super.key,
    required this.onCompleted,
  });

  /// Called with the full pin when the user finishes entering all digits.
  final ValueChanged<String> onCompleted;

  /// Builds the themed [Pinput] widget for OTP entry.
  ///
  /// Uses [AppConstants.otpLength] boxes and invokes [onCompleted] when full.
  @override
  Widget build(BuildContext context) {
    final boxSize = context.wp(17);

    final defaultTheme = PinTheme(
      width: boxSize,
      height: boxSize,
      margin: EdgeInsets.symmetric(horizontal: context.wp(2)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFA05D19)),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(
        color: const Color(0xFFA05D19),
        fontSize: context.sp(6),
        fontWeight: FontWeight.w600,
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(
        color: const Color(0xFFA05D19),
        fontSize: context.sp(6),
        fontWeight: FontWeight.w700,
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.hp(2)),
      child: Pinput(
        length: AppConstants.otpLength,
        keyboardType: TextInputType.number,
        defaultPinTheme: defaultTheme,
        focusedPinTheme: focusedTheme,
        cursor: SizedBox(
          height: context.wp(6),
          child: const VerticalDivider(
            color: Color(0xFFA05D19),
            thickness: 2,
          ),
        ),
        onCompleted: onCompleted,
      ),
    );
  }
}

