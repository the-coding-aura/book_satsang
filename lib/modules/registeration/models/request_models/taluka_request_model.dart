/// Request body for fetching taluka master records.
class TalukaRequestModel {
  /// Partial or full taluka name used for search filtering.
  String? talukaName;

  /// Creates a [TalukaRequestModel] with an optional search term.
  TalukaRequestModel({this.talukaName});

  /// Serializes this request to a JSON map for query parameters.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['talukaName'] = talukaName;
    return data;
  }
}
