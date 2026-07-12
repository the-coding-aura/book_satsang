import 'package:book_satsang/network_module/response/base_api_response.dart';

/// API response type for the member registration endpoint.
typedef RegisterMemberResponseModel = BaseApiResponse<int>;
/// Parses the register member API response from raw JSON.
///
/// The response data is expected to be the new member identifier.
RegisterMemberResponseModel registerMemberResfromJson(
  Map<String, dynamic> json,
) => RegisterMemberResponseModel.fromJson(json, (d) => d as int);
