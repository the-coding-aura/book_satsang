import 'package:book_satsang/network_module/response/base_api_response.dart';

/// API response type for the logout endpoint.
typedef LogoutResponseModel = BaseApiResponse<int>;
/// Parses the logout API response from raw JSON.
///
/// The response data is expected to be a success indicator integer.
LogoutResponseModel logoutResfromJson(Map<String, dynamic> json) =>
    LogoutResponseModel.fromJson(json, (d) => d as int);
