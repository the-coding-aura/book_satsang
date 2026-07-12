/// Request body for creating a new satsang event.
class AddSatsangRequestModel {
  /// Display name of the satsang event.
  String? satsangName;

  /// Name of the temple hosting the satsang.
  String? templeName;

  /// Full address of the temple.
  String? templeAddress;

  /// Selected taluka master identifier.
  int? talukaMasterId;

  /// Selected village master identifier.
  int? villageMasterId;

  /// Event start date in ISO-8601 format.
  String? fromDate;

  /// Event end date in ISO-8601 format.
  String? toDate;

  /// Creates an [AddSatsangRequestModel] with optional field values.
  AddSatsangRequestModel({
    this.satsangName,
    this.templeName,
    this.templeAddress,
    this.talukaMasterId,
    this.villageMasterId,
    this.fromDate,
    this.toDate,
  });

  /// Serializes this request to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'satsangName': satsangName,
      'templeName': templeName,
      'templeAddress': templeAddress,
      'talukaMasterId': talukaMasterId,
      'villageMasterId': villageMasterId,
      'fromDate': fromDate,
      'toDate': toDate,
    };
  }
}
