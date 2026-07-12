import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/login/models/response_models/send_otp_response_model.dart';
import 'package:book_satsang/modules/otp/models/response_models/verify_otp_response_model.dart';
import 'package:book_satsang/modules/otp/repository/otp_api_repository.dart';
import 'package:book_satsang/network_module/network/api_path.dart';
import 'package:book_satsang/network_module/network/base_api_services.dart';

/// HTTP implementation of [OTPApiRepository].
///
/// Posts OTP send, verify, and member-login requests through [BaseApiServices].
class OTPHttpApiRepository implements OTPApiRepository {
  /// Creates a repository backed by the injected API service.
  OTPHttpApiRepository() : _apiService = getIt<BaseApiServices>();

  final BaseApiServices _apiService;

  // @override
  // Future<OTPResponseModel?> sendOTP(Map<String, String> body) async {
  //   final json = await _apiService.post(
  //     ApiPathHelper.getValue(ApiPath.sendOtp),
  //     body: body,
  //   );
  //   return otpResponseFromJson(json as Map<String, dynamic>);
  // }

  // @override
  // Future<OTPResponseModel?> resendOTP(Map<String, String> body) async {
  //   final json = await _apiService.post(
  //     ApiPathHelper.getValue(ApiPath.resendOtp),
  //     body: body,
  //   );
  //   return otpResponseFromJson(json as Map<String, dynamic>);
  // }

  /// Posts [body] to the member-login endpoint and parses auth tokens.
  ///
  /// Returns `null` when the HTTP layer yields no parseable payload.
  @override
  Future<VerifyOTPResponseModel?> memberLogin(Map<String, dynamic> body) async {
    final json = await _apiService.post(
      ApiPathHelper.getValue(ApiPath.memberLogin),
      body: body,
    );
    return verifyOtpResponseFromJson(json as Map<String, dynamic>);
  }

  /// Posts [body] to the send-OTP endpoint and parses the integer status.
  ///
  /// Returns `null` when the HTTP layer yields no parseable payload.
  @override
  Future<SendOTPResponseModel?> sendOTP(Map<String, dynamic> body) async {
    final json = await _apiService.post(
      ApiPathHelper.getValue(ApiPath.sendOtp),
      body: body,
    );
    return sendOTPResfromJson(json as Map<String, dynamic>);
  }

  /// Posts [body] to the verify-OTP endpoint for registration flow.
  ///
  /// Returns `null` when the HTTP layer yields no parseable payload.
  @override
  Future<SendOTPResponseModel?> verifyOTP(Map<String, dynamic> body) async {
    final json = await _apiService.post(
      ApiPathHelper.getValue(ApiPath.verifyOtp),
      body: body,
    );
    return sendOTPResfromJson(json as Map<String, dynamic>);
  }
}
