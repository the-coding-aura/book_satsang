import 'status.dart';

/// UI-facing wrapper that tracks the lifecycle of an API call.
///
/// Use the factory constructors to represent idle, loading, completed, and
/// error states consumed by view models and widgets.
class ApiResponse<T> {
  const ApiResponse._(this.status, this.data, this.message);

  /// The current phase of the API operation.
  final Status status;

  /// Parsed payload returned on success, or `null` otherwise.
  final T? data;

  /// Optional human-readable message (e.g. error text or loading hint).
  final String? message;

  /// Initial state — no API call has been made yet.
  factory ApiResponse.idle([T? data]) {
    return ApiResponse._(Status.idle, data, null);
  }

  /// Indicates an in-flight request with an optional [message].
  factory ApiResponse.loading([String? message]) {
    return ApiResponse._(Status.loading, null, message);
  }

  /// Indicates a successful response carrying [data].
  factory ApiResponse.completed(T data) {
    return ApiResponse._(Status.completed, data, null);
  }

  /// Indicates a failed request with an [message] describing the error.
  factory ApiResponse.error(String message) {
    return ApiResponse._(Status.error, null, message);
  }

  /// Whether no request has started yet.
  bool get isIdle => status == Status.idle;

  /// Whether a request is currently in progress.
  bool get isLoading => status == Status.loading;

  /// Whether the request finished successfully.
  bool get isCompleted => status == Status.completed;

  /// Whether the request failed with an error.
  bool get isError => status == Status.error;

  /// Returns a debug string with [status], [message], and [data].
  @override
  String toString() => 'Status: $status | Message: $message | Data: $data';
}
