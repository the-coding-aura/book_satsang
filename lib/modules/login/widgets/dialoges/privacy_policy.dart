import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Modal dialog that displays the app's privacy policy.
///
/// Use [show] to present the dialog from any [BuildContext].
class PrivacyPolicyDialog extends StatelessWidget {
  /// Creates the privacy policy dialog content.
  const PrivacyPolicyDialog({super.key});

  /// Presents the privacy policy dialog above [context].
  ///
  /// Returns when the dialog is dismissed.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const PrivacyPolicyDialog(),
    );
  }

  /// Builds the scrollable privacy policy content and close button.
  ///
  /// Presented inside a rounded [Dialog].
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(context.wp(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: context.sp(5),
                fontWeight: FontWeight.w700,
                color: const Color(0xFFA05D19),
              ),
            ),
            SizedBox(height: context.hp(2)),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: context.hp(45)),
              child: SingleChildScrollView(
                child: Text(
                  'Your privacy is important to us. This policy explains how '
                  'Book Satsang collects, uses, and protects your information.\n\n'
                  'Information We Collect\n'
                  'We collect your mobile number solely for the purpose of '
                  'authentication and satsang booking. We do not share your '
                  'personal data with third parties without your consent.\n\n'
                  'How We Use Your Information\n'
                  'Your mobile number is used to send OTPs for login and '
                  'to manage your satsang bookings. We may use anonymised '
                  'data to improve our services.\n\n'
                  'Data Security\n'
                  'We implement industry-standard security measures to protect '
                  'your information from unauthorised access or disclosure.\n\n'
                  'Contact Us\n'
                  'If you have any questions about this policy, please contact '
                  'us through the app\'s support section.',
                  style: TextStyle(
                    fontSize: context.sp(3.8),
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.hp(2)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: context.sp(4),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
