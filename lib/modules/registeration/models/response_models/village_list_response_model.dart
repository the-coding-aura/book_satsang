import '../../../../network_module/response/base_api_response.dart';

/// API response type for the village master list endpoint.
typedef VillageListResponseModel = BaseApiResponse<List<VillageData>>;

/// Parses the village list API response from raw JSON.
///
/// Returns a typed list of [VillageData] items.
VillageListResponseModel fetchVillageDataResponse(Map<String, dynamic> json) {
  return VillageListResponseModel.fromJson(
    json,
    (data) => (data as List<dynamic>)
        .map((e) => VillageData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// A village master record used in searchable dropdown selections.
class VillageData {
  /// Unique village master identifier.
  int? idVillageMaster;

  /// Display name of the village.
  String? villageName;

  /// Creates a [VillageData] with optional field values.
  VillageData({this.idVillageMaster, this.villageName});

  /// Creates a [VillageData] from JSON map keys.
  VillageData.fromJson(Map<String, dynamic> json) {
    idVillageMaster = json['idVillageMaster'];
    villageName = json['villageName'];
  }
}
