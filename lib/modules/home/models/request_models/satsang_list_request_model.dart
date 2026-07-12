/// Request body for fetching a paginated satsang list.
class SatsangListRequestModel {
  /// One-based page index for pagination.
  int? pageNumber;

  /// Number of records to return per page.
  int? pageSize;

  /// Creates a [SatsangListRequestModel] with optional pagination values.
  SatsangListRequestModel({this.pageNumber, this.pageSize});

  /// Serializes this request to a JSON map for query parameters.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}
