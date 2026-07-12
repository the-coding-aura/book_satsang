import '../../../../network_module/response/base_api_response.dart';

/// API response type for the file upload endpoint.
typedef UploadFileResponseModel = BaseApiResponse<List<String>>;

/// Parses the file upload API response from raw JSON.
///
/// Returns a list of uploaded server file names or URLs.
UploadFileResponseModel uplaodFileBindResponse(Map<String, dynamic> json) {
  return UploadFileResponseModel.fromJson(
    json,
    (data) => (data as List<dynamic>).map((e) => e.toString()).toList(),
  );
}
