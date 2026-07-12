import 'package:book_satsang/modules/otp/providers/otp_provider.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows the masked mobile number the OTP was sent to.
///
/// Reads [OtpProvider.maskedMobile] via a [Selector].
class OtpMaskedMobileText extends StatelessWidget {
  /// Creates the masked mobile number display.
  const OtpMaskedMobileText({super.key});

  /// Builds the icon and masked mobile number column.
  ///
  /// Rebuilds when [OtpProvider.maskedMobile] changes.
  @override
  Widget build(BuildContext context) {
    return Selector<OtpProvider, String>(
      selector: (context, provider) => provider.maskedMobile,
      builder: (context, mobile, child) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.hp(2)),
        child: Row(
            children: [
              Icon(
                Icons.phone_android_outlined,
                color: Colors.orange,
                size: context.wp(7),
              ),
              SizedBox(width: context.wp(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP sent to',
                      style: TextStyle(
                        fontSize: context.sp(3.5),
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      mobile,
                      style: TextStyle(
                        fontSize: context.sp(4.2),
                        color: const Color(0xFFA05D19),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
