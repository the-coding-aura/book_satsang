import 'dart:async';

import 'base_api_services.dart';

/// Simulates network responses with a small delay for use in MOCK flavor.
///
/// Returns stub JSON payloads so UI and repositories can be tested without
/// a live backend.
class MockApiServices implements BaseApiServices {
  /// Simulates a GET request and returns a stub response after a short delay.
  ///
  /// The returned map includes the requested [url] and method name.
  @override
  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return <String, dynamic>{'url': url, 'method': 'GET'};
  }

  /// Simulates a POST request and echoes the [body] in the stub response.
  ///
  /// Returns after a 500 ms delay to mimic network latency.
  @override
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return <String, dynamic>{'url': url, 'method': 'POST', 'body': body};
  }

  /// Simulates a multipart file upload with optional progress callbacks.
  ///
  /// Reports incremental progress when [onProgress] is provided, then returns
  /// a success payload with a mock file URL.
  @override
  Future<dynamic> uploadFile(
    String url, {
    required String filePath,
    required String fieldName,
    required String serverFileName,
    Map<String, String>? headers,
    Map<String, String>? additionalFields,
    void Function(int sent, int total)? onProgress,
  }) async {
    // Simulate file size (random between 1-9 MB)
    final int simulatedFileSize =
        1024 * 1024 * (3 + (DateTime.now().millisecondsSinceEpoch % 5));

    // Simulate upload progress
    if (onProgress != null) {
      const int totalChunks = 10;
      for (int i = 0; i <= totalChunks; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        final int bytesSent = (simulatedFileSize * i) ~/ totalChunks;
        onProgress(bytesSent, simulatedFileSize);
      }
    } else {
      // If no progress callback, just simulate upload delay
      await Future<void>.delayed(const Duration(seconds: 2));
    }

    // Simulate successful upload response
    return <String, dynamic>{
      'success': true,
      'statusCode': 200,
      'message': 'File uploaded successfully (MOCK)',
      'fileName': serverFileName,
      'fileUrl': 'https://mock-server.com/uploads/$serverFileName',
      'response':
          '{"id": "${DateTime.now().millisecondsSinceEpoch}", "status": "uploaded"}',
    };
  }
}
