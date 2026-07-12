import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:book_satsang/modules/otp/extensions/otp_provider_extension.dart';
import 'package:book_satsang/modules/otp/widgets/otp_change_mobile_link.dart';
import 'package:book_satsang/modules/otp/widgets/otp_logo_header.dart';
import 'package:book_satsang/modules/otp/widgets/otp_masked_mobile_text.dart';
import 'package:book_satsang/modules/otp/widgets/otp_pin_input.dart';
import 'package:book_satsang/modules/otp/widgets/otp_timer_section.dart';
import 'package:book_satsang/modules/otp/widgets/otp_title_section.dart';
import 'package:flutter/material.dart';

/// Screen where users enter the OTP sent to their mobile number.
///
/// Composes pin input, countdown timer, and change-mobile actions.
class OTPPage extends StatefulWidget {
  /// Creates the OTP verification page.
  const OTPPage({super.key});

  /// Creates the mutable state for this OTP page.
  ///
  /// Initializes mobile arguments after the first frame.
  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.otpProvider.assignMobile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.wp(10),
            vertical: context.hp(5),
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const OtpLogoHeader(),
                const OtpTitleSection(),
                const OtpMaskedMobileText(),
                OtpPinInput(
                  onCompleted: (pin) =>
                      context.otpProvider.onCompletedPin(pin, context),
                ),
                const OtpTimerSection(),
                const OtpChangeMobileLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
