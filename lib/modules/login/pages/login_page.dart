import 'package:book_satsang/modules/login/widgets/dialoges/privacy_policy.dart';
import 'package:book_satsang/modules/login/widgets/login_header.dart';
import 'package:book_satsang/modules/login/widgets/login_mobile_field.dart';
import 'package:book_satsang/modules/login/widgets/send_otp_button.dart';
import 'package:book_satsang/modules/login/widgets/term_label_button.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Screen where users enter a mobile number and request an OTP.
///
/// Composes the login header, input fields, terms checkbox, and submit action.
class LoginPage extends StatelessWidget {
  /// Creates the login page.
  const LoginPage({super.key});

  /// Builds the scrollable login layout over the background image.
  ///
  /// Composes header, inputs, terms, submit button, and privacy link.
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
          child: Column(
            children: [
              const LoginHeader(),
              const LoginMobileField(),
              const TermLabelButton(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.hp(3)),
                child: const SendOtpButton(),
              ),
              SizedBox(height: context.hp(4)),
              _PrivacyPolicyLink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyPolicyLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PrivacyPolicyDialog.show(context),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'View our ',
              style: TextStyle(
                fontSize: context.sp(3.5),
                color: Colors.black54,
              ),
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                fontSize: context.sp(3.5),
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
