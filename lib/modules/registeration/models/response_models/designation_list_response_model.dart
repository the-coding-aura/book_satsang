import '../../../../network_module/response/base_api_response.dart';

/// API response type for the designation master list endpoint.
typedef DesignationListResponseModel = BaseApiResponse<List<DesignationData>>;

/// Parses the designation list API response from raw JSON.
///
/// Returns a typed list of [DesignationData] items.
DesignationListResponseModel fetchDesignationListResponse(
  Map<String, dynamic> json,
) {
  return DesignationListResponseModel.fromJson(
    json,
    (data) => (data as List<dynamic>)
        .map((e) => DesignationData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// A designation master record used in dropdown selections.
class DesignationData {
  /// Unique designation master identifier.
  int? idDesignation;

  /// Display name of the designation.
  String? designationName;

  /// Creates a [DesignationData] with optional field values.
  DesignationData({this.idDesignation, this.designationName});

  /// Creates a [DesignationData] from JSON map keys.
  DesignationData.fromJson(Map<String, dynamic> json) {
    idDesignation = json['idDesignation'];
    designationName = json['designationName'];
  }
}
