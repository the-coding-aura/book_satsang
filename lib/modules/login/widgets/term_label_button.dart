import 'package:book_satsang/modules/login/widgets/dialoges/terms_con.dart';
import 'package:book_satsang/modules/login/widgets/terms_checkbox.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Row combining the terms checkbox with tappable terms-and-conditions text.
///
/// Opens [TermCondialog] when the linked label is tapped.
class TermLabelButton extends StatelessWidget {
  /// Creates the terms acceptance label and checkbox row.
  const TermLabelButton({super.key});

  /// Builds the rich text row with checkbox and tappable terms link.
  ///
  /// Opens [TermCondialog] when the underlined label is tapped.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.wp(2)),
      child: Text.rich(
        TextSpan(
          children: [
            const WidgetSpan(
              child: TermsCheckbox(),
              alignment: PlaceholderAlignment.middle,
            ),
            TextSpan(
              text: 'I agree to ',
              style: TextStyle(
                color: Colors.black,
                fontSize: context.sp(3.5),
              ),
            ),
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: context.sp(3.5),
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => TermCondialog.show(context),
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
