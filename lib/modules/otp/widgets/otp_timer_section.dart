import 'package:book_satsang/modules/otp/providers/otp_provider.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays the OTP countdown or a resend action when the timer expires.
///
/// Listens to [OtpProvider.remSec] for live updates.
class OtpTimerSection extends StatelessWidget {
  /// Creates the OTP timer and resend section.
  const OtpTimerSection({super.key});

  /// Builds the countdown label or resend prompt based on [OtpProvider.remSec].
  ///
  /// Updates every second while the OTP timer is active.
  @override
  Widget build(BuildContext context) {
    return Selector<OtpProvider, int>(
      selector: (context, provider) => provider.remSec,
      builder: (context, remSec, child) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.hp(1.5)),
        child: Text.rich(
          remSec > 0
              ? TextSpan(
                  children: [
                    TextSpan(
                      text: 'OTP expires in ',
                      style: TextStyle(
                        fontSize: context.sp(4),
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: '$remSec seconds',
                      style: TextStyle(
                        fontSize: context.sp(4),
                        color: const Color(0xFFA05D19),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : TextSpan(
                  children: [
                    TextSpan(
                      text: "Didn't receive the code? ",
                      style: TextStyle(
                        fontSize: context.sp(4),
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: TextButton(
                        onPressed:
                            () {}, //context.otpProvider.resendOtp(context),
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: context.sp(4),
                            color: const Color.fromARGB(255, 18, 100, 194),
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
