import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Modal dialog that displays the app's terms and conditions.
///
/// Use [show] to present the dialog from any [BuildContext].
class TermCondialog extends StatelessWidget {
  /// Creates the terms and conditions dialog content.
  const TermCondialog({super.key});

  /// Presents the terms and conditions dialog above [context].
  ///
  /// Returns when the dialog is dismissed.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const TermCondialog(),
    );
  }

  /// Builds the scrollable terms content and close button.
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
              'Terms & Conditions',
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
                  'By using Book Satsang, you agree to provide accurate '
                  'information during registration and OTP verification.\n\n'
                  'You are responsible for keeping your mobile number secure '
                  'and for all activity conducted through your account.\n\n'
                  'Satsang bookings are subject to availability and the '
                  'policies of the organizing institution.\n\n'
                  'We may update these terms from time to time. Continued use '
                  'of the app constitutes acceptance of the updated terms.',
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
