import 'package:book_satsang/modules/login/extensions/login_provider_extension.dart';
import 'package:book_satsang/modules/login/providers/login_provider.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Primary submit button on the login screen.
///
/// Enabled only when the form is valid and no OTP request is in progress.
class SendOtpButton extends StatelessWidget {
  /// Creates the send-OTP submit button.
  const SendOtpButton({super.key});

  /// Builds the submit button with form and loading-state gating.
  ///
  /// Calls [LoginProvider.checkUserExist] when pressed and enabled.
  @override
  Widget build(BuildContext context) {
    final loginProvider = context.loginProvider;

    return StreamBuilder<bool>(
      stream: loginProvider.isValidForSent(),
      builder: (context, snapshot) {
        final canSend = snapshot.hasData && snapshot.data == true;

        return Selector<LoginProvider, (bool, bool)>(
          selector: (_, provider) => (
            provider.existResponse.isLoading,
            provider.sendOtpResponse.isLoading,
          ),
          builder: (context, otpRes, child) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, context.hp(6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: canSend && !(otpRes.$1 || otpRes.$2)
                  ? () => context.loginProvider.checkUserExist(context)
                  : null,
              child: Text(
                !(otpRes.$1 || otpRes.$2) ? 'Submit' : 'Checking...',
                style: TextStyle(
                  fontSize: context.sp(4.5),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
