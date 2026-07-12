import 'package:book_satsang/network_module/response/base_api_response.dart';

/// API envelope for member-login OTP responses with a [VerifyOTPModel] payload.
typedef VerifyOTPResponseModel = BaseApiResponse<VerifyOTPModel>;

/// Parses a raw JSON map into a [VerifyOTPResponseModel].
///
/// The [d] callback receives `json['data']` as a map for [VerifyOTPModel].
VerifyOTPResponseModel verifyOtpResponseFromJson(Map<String, dynamic> json) =>
    VerifyOTPResponseModel.fromJson(
      json,
      (d) => VerifyOTPModel.fromJson(d as Map<String, dynamic>),
    );

/// Auth tokens returned after successful OTP verification for member login.
class VerifyOTPModel {
  /// Access token used for authenticated API requests.
  String? accessToken;

  /// Refresh token used to obtain a new access token.
  String? refreshToken;

  /// Creates a verify-OTP model with optional [accessToken] and [refreshToken].
  VerifyOTPModel({this.accessToken, this.refreshToken});

  /// Creates a model from the `data` object in a verify-OTP response.
  VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}
