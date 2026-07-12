/// Shared application constants for validation and mock behavior.
///
/// Holds fixed values used across OTP flows and related features.
class AppConstants {
  AppConstants._();

  /// Required number of digits in an OTP input field.
  static const int otpLength = 4;

  /// Countdown duration in seconds before OTP can be resent.
  static const int otpTimerSeconds = 30;

  /// OTP value accepted by mock authentication in development builds.
  static const String mockOtp = '123456';
}
