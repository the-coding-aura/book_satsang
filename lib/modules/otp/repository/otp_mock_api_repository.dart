import 'package:book_satsang/modules/login/models/response_models/send_otp_response_model.dart';
import 'package:book_satsang/utils/constants/app_constants.dart';
import 'package:book_satsang/modules/otp/models/response_models/verify_otp_response_model.dart';
import 'package:book_satsang/modules/otp/repository/otp_api_repository.dart';

/// Mock implementation of [OTPApiRepository] for development and testing.
///
/// Accepts [AppConstants.mockOtp] for successful member login verification.
class OTPMockApiRepository implements OTPApiRepository {
  static const _delay = Duration(milliseconds: 800);

  // @override
  // Future<OTPResponseModel?> sendOTP(Map<String, String> body) async {
  //   await Future.delayed(_delay);
  //   if (kDebugMode) {
  //     print('MOCK sendOTP for ${body['mobileNo']}: ${AppConstants.mockOtp}');
  //   }
  //   return OTPResponseModel.success(
  //     data: 1,
  //     message: 'OTP sent successfully.',
  //   );
  // }

  // @override
  // Future<OTPResponseModel?> resendOTP(Map<String, String> body) async {
  //   await Future.delayed(_delay);
  //   if (kDebugMode) {
  //     print('MOCK resendOTP for ${body['mobileNo']}: ${AppConstants.mockOtp}');
  //   }
  //   return OTPResponseModel.success(
  //     data: 1,
  //     message: 'OTP resent successfully.',
  //   );
  // }

  /// Simulates member-login OTP verification against [AppConstants.mockOtp].
  ///
  /// Returns demo tokens when the entered OTP matches the mock constant.
  @override
  Future<VerifyOTPResponseModel?> memberLogin(Map<String, dynamic> body) async {
    await Future.delayed(_delay);
    final enteredOtp = body['otp'] ?? '';
    if (enteredOtp == AppConstants.mockOtp) {
      return VerifyOTPResponseModel.success(
        data: VerifyOTPModel(
          accessToken: 'demo token',
          refreshToken: 'demo refresh token',
        ),
        message: 'OTP verified successfully.',
      );
    }
    return VerifyOTPResponseModel.failure(
      message: 'Invalid OTP. Use ${AppConstants.mockOtp} for mock.',
    );
  }

  /// Simulates a successful send-OTP response after a short delay.
  ///
  /// Always returns status `1` with a success message.
  @override
  Future<SendOTPResponseModel?> sendOTP(Map<String, dynamic> body) async {
    await Future.delayed(_delay);
    return SendOTPResponseModel.success(
      data: 1,
      message: 'OTP sent successfully.',
    );
  }

  /// Simulates successful registration OTP verification after a short delay.
  ///
  /// Always returns status `1` with a success message.
  @override
  Future<SendOTPResponseModel?> verifyOTP(Map<String, dynamic> body) async {
    await Future.delayed(_delay);
    return SendOTPResponseModel.success(
      data: 1,
      message: 'OTP verified successfully.',
    );
  }
}
