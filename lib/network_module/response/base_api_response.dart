/// Generic envelope that the server wraps every API response in.
///
/// [T] is the type of the [data] field (e.g. [int], [String], or a custom
/// model). Pass a [dataFromJson] converter when calling [fromJson] so the
/// generic data field is parsed correctly.
class BaseApiResponse<T> {
  /// The primary payload returned by the API, typed as [T].
  T? data;

  /// Current page index for paginated responses.
  int? currentPage;

  /// Total number of records across all pages.
  int? totalCount;

  /// Number of items returned per page.
  int? pageSize;

  /// Total number of available pages.
  int? totalPages;

  /// Whether a previous page of results exists.
  bool? previousPage;

  /// Whether a next page of results exists.
  bool? nextPage;

  /// General status or informational message from the server.
  String? message;

  /// Field-level validation errors returned by the server.
  List<String>? validationMessages;

  /// Whether the API call completed successfully.
  bool? isSuccessful;

  /// Whether the failure was a business-rule violation.
  bool? isBusinessError;

  /// Whether the failure was a system or server error.
  bool? isSystemError;

  /// Detailed message when [isSystemError] is true.
  String? systemErrorMessage;

  /// Detailed message when [isBusinessError] is true.
  String? businessErrorMessage;

  /// Creates a response envelope with optional metadata and payload fields.
  BaseApiResponse({
    this.data,
    this.currentPage,
    this.totalCount,
    this.pageSize,
    this.totalPages,
    this.previousPage,
    this.nextPage,
    this.message,
    this.validationMessages,
    this.isSuccessful,
    this.isBusinessError,
    this.isSystemError,
    this.systemErrorMessage,
    this.businessErrorMessage,
  });

  /// Returns [true] when the call succeeded and [data] was set.
  bool get isOk => isSuccessful == true && data != null;

  /// Deserialize from JSON. [dataFromJson] converts the raw `json['data']`
  /// value into [T].
  ///
  /// ```dart
  /// BaseApiResponse<int>.fromJson(json, (d) => d as int)
  /// BaseApiResponse<UserModel>.fromJson(json, (d) => UserModel.fromJson(d))
  /// ```
  BaseApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataFromJson,
  ) {
    data = json['data'] != null && dataFromJson != null
        ? dataFromJson(json['data'])
        : null;
    currentPage = json['currentPage'];
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPages = json['totalPages'];
    previousPage = json['previousPage'];
    nextPage = json['nextPage'];
    message = json['message'];
    validationMessages = json['validationMessages'] != null
        ? List<String>.from(json['validationMessages'])
        : [];
    isSuccessful = json['isSuccessful'];
    isBusinessError = json['isBusinessError'];
    isSystemError = json['isSystemError'];
    systemErrorMessage = json['systemErrorMessage'];
    businessErrorMessage = json['businessErrorMessage'];
  }

  /// Serializes this response envelope to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'currentPage': currentPage,
      'totalCount': totalCount,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'previousPage': previousPage,
      'nextPage': nextPage,
      'message': message,
      'validationMessages': validationMessages,
      'isSuccessful': isSuccessful,
      'isBusinessError': isBusinessError,
      'isSystemError': isSystemError,
      'systemErrorMessage': systemErrorMessage,
      'businessErrorMessage': businessErrorMessage,
    };
  }

  // --- Convenience factory constructors ---

  /// Creates a successful response with optional [data] and [message].
  factory BaseApiResponse.success({T? data, String? message}) =>
      BaseApiResponse(
        data: data,
        message: message,
        isSuccessful: true,
        isBusinessError: false,
        isSystemError: false,
      );

  /// Creates a failed business-error response with an optional [message].
  factory BaseApiResponse.failure({String? message}) => BaseApiResponse(
    message: message,
    isSuccessful: false,
    isBusinessError: true,
    isSystemError: false,
  );
}
