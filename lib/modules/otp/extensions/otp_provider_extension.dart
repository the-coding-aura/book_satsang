import 'package:book_satsang/modules/otp/providers/otp_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Convenience accessors for OTP-related providers on [BuildContext].
extension OtpProviderExtension on BuildContext {
  /// The [OtpProvider] registered above this context.
  OtpProvider get otpProvider => read<OtpProvider>();
}
