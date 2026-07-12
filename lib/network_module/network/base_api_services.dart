/// Contract for HTTP operations used throughout the app.
///
/// Implemented by [NetworkApiServices] for live calls and [MockApiServices]
/// for offline or test scenarios.
abstract class BaseApiServices {
  /// Sends an HTTP GET request to [url] and returns the decoded response body.
  ///
  /// Optional [headers] and [queryParams] are merged with defaults by the
  /// implementation.
  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  });

  /// Sends an HTTP POST request to [url] with an optional JSON [body].
  ///
  /// Returns the decoded response body on success.
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  });

  /// Uploads a local file to [url] as a multipart POST request.
  ///
  /// [fieldName] and [serverFileName] identify the file on the server.
  /// [onProgress] reports upload bytes sent versus total file size.
  Future<dynamic> uploadFile(
    String url, {
    required String filePath,
    required String fieldName,
    required String serverFileName,
    Map<String, String>? headers,
    Map<String, String>? additionalFields,
    void Function(int sent, int total)? onProgress,
  });
}
