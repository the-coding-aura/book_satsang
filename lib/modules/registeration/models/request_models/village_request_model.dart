/// Request body for fetching village master records.
class VillageMasterRequestModel {
  /// Taluka master identifier used to scope village results.
  int? idTalukaMaster;

  /// Partial or full village name used for search filtering.
  String? villageName;

  /// Creates a [VillageMasterRequestModel] with optional filter values.
  VillageMasterRequestModel({this.idTalukaMaster, this.villageName});

  /// Serializes this request to a JSON map for query parameters.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTalukaMaster'] = idTalukaMaster;
    data['villageName'] = villageName;
    return data;
  }
}
