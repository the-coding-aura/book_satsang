import '../../../../network_module/response/base_api_response.dart';

/// API response type for the taluka master list endpoint.
typedef TalukaListResponseModel = BaseApiResponse<List<TalukaData>>;

/// Parses the taluka list API response from raw JSON.
///
/// Returns a typed list of [TalukaData] items.
TalukaListResponseModel fetchTalukaListResponse(Map<String, dynamic> json) {
  return TalukaListResponseModel.fromJson(
    json,
    (data) => (data as List<dynamic>)
        .map((e) => TalukaData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// A taluka master record used in searchable dropdown selections.
class TalukaData {
  /// Unique taluka master identifier.
  int? idTalukaMaster;

  /// Display name of the taluka.
  String? talukaName;

  /// Creates a [TalukaData] with optional field values.
  TalukaData({this.idTalukaMaster, this.talukaName});

  /// Creates a [TalukaData] from JSON map keys.
  TalukaData.fromJson(Map<String, dynamic> json) {
    idTalukaMaster = json['idTalukaMaster'];
    talukaName = json['talukaName'];
  }
}
