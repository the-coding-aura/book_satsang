import 'package:book_satsang/network_module/response/base_api_response.dart';

/// API response type for the add satsang endpoint.
typedef AddSatsangResponseModel = BaseApiResponse<int>;

/// Parses the add satsang API response from raw JSON.
AddSatsangResponseModel addSatsangResponseFromJson(Map<String, dynamic> json) =>
    AddSatsangResponseModel.fromJson(json, (d) => d as int);
