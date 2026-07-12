import 'package:book_satsang/modules/login/models/response_models/send_otp_response_model.dart';
import 'package:book_satsang/modules/otp/models/response_models/verify_otp_response_model.dart';

/// Abstract contract for all OTP-related API operations.
abstract class OTPApiRepository {
  /// Sends an OTP to the mobile number in [body].
  Future<SendOTPResponseModel?> sendOTP(Map<String, dynamic> body);

  // Future<OTPResponseModel?> resendOTP(Map<String, String> body);

  /// Verifies OTP for an existing member and returns auth tokens.
  Future<VerifyOTPResponseModel?> memberLogin(Map<String, dynamic> body);

  /// Verifies OTP during new-user registration.
  Future<SendOTPResponseModel?> verifyOTP(Map<String, dynamic> body);
}
