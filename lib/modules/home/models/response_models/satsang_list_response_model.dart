import '../../../../network_module/response/base_api_response.dart';

/// API response type for the satsang list endpoint.
typedef SatsangListResponseModel = BaseApiResponse<List<SatsangData>>;

/// Parses the satsang list API response from raw JSON.
///
/// Returns a typed [SatsangListResponseModel] with deserialized items.
SatsangListResponseModel fetchSatsangListResponse(Map<String, dynamic> json) {
  return SatsangListResponseModel.fromJson(
    json,
    (data) => (data as List<dynamic>)
        .map((e) => SatsangData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// A single satsang event with temple and location details.
class SatsangData {
  /// Display name of the satsang event.
  final String? satsangName;

  /// Name of the hosting temple.
  final String? templeName;

  /// Postal or street address of the temple.
  final String? templeAddress;

  /// Identifier of the associated taluka master record.
  final int? talukaMasterId;

  /// Display name of the taluka.
  final String? talukaName;

  /// Identifier of the associated village master record.
  final int? villageMasterId;

  /// Display name of the village.
  final String? villageName;

  /// Event start date in API string format.
  final String? fromDate;

  /// Event end date in API string format.
  final String? toDate;

  /// Creates a [SatsangData] with optional field values.
  const SatsangData({
    this.satsangName,
    this.templeName,
    this.templeAddress,
    this.talukaMasterId,
    this.talukaName,
    this.villageMasterId,
    this.villageName,
    this.fromDate,
    this.toDate,
  });

  /// Creates a [SatsangData] from JSON map keys.
  factory SatsangData.fromJson(Map<String, dynamic> json) {
    return SatsangData(
      satsangName: json['satsangName'] as String?,
      templeName: json['templeName'] as String?,
      templeAddress: json['templeAddress'] as String?,
      talukaMasterId: json['talukaMasterId'] as int?,
      talukaName: json['talukaName'] as String?,
      villageMasterId: json['villageMasterId'] as int?,
      villageName: json['villageName'] as String?,
      fromDate: json['fromDate'] as String?,
      toDate: json['toDate'] as String?,
    );
  }

  /// Converts this satsang entry to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'satsangName': satsangName,
      'templeName': templeName,
      'templeAddress': templeAddress,
      'talukaMasterId': talukaMasterId,
      'talukaName': talukaName,
      'villageMasterId': villageMasterId,
      'villageName': villageName,
      'fromDate': fromDate,
      'toDate': toDate,
    };
  }
}
