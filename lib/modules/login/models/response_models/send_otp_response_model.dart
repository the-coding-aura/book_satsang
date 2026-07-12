import 'package:book_satsang/network_module/response/base_api_response.dart';

/// API envelope for Send OTP responses with an integer status payload.
typedef SendOTPResponseModel = BaseApiResponse<int>;

/// Parses the Send OTP API response into a [SendOTPResponseModel].
///
/// The [d] callback receives `json['data']` already cast as an integer.
SendOTPResponseModel sendOTPResfromJson(Map<String, dynamic> json) =>
    SendOTPResponseModel.fromJson(json, (d) => d as int);
