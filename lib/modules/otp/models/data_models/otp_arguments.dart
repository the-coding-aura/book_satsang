import 'package:book_satsang/modules/otp/enums/otp_enums.dart';

/// Route arguments passed to the OTP screen.
///
/// Carries the target mobile number and which verification flow to run.
class OtpArguments {
  /// Full mobile number that received the OTP.
  final String mobileNo;

  /// Whether this OTP is for login or registration.
  final VerificationType verificationType;

  /// Creates OTP route arguments for [mobileNo] and [verificationType].
  OtpArguments({required this.mobileNo, required this.verificationType});
}
