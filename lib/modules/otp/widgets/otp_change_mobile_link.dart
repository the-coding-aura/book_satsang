import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Tappable link that pops the OTP screen to change the mobile number.
///
/// Returns the user to the previous route (typically login).
class OtpChangeMobileLink extends StatelessWidget {
  /// Creates the change-mobile-number link.
  const OtpChangeMobileLink({super.key});

  /// Builds the underlined link that pops back to the login screen.
  ///
  /// Uses [Navigator.pop] to return to the previous route.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.hp(1)),
        child: Text(
          'Change Mobile Number',
          style: TextStyle(
            fontSize: context.sp(3.5),
            color: const Color.fromARGB(255, 18, 100, 194),
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
