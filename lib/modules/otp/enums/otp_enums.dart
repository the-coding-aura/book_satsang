/// Distinguishes login OTP verification from registration OTP verification.
enum VerificationType {
  /// OTP sent during new-user registration.
  otp,

  /// OTP sent for an existing member login.
  login,
}
