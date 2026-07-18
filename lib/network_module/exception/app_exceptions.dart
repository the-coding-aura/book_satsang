/// Base exception type for network-layer failures.
///
/// Carries a human-readable [message] that can be shown to the user or logged.
class AppException implements Exception {
  const AppException(this.message);

  /// A short description of what went wrong.
  final String message;

  /// Returns [message] as the string representation of this exception.
  @override
  String toString() => message;
}

/// Thrown when a network request fails due to connectivity or server errors.
///
/// Used for timeouts, unexpected status codes, and general communication issues.
class FetchDataException extends AppException {
  const FetchDataException([super.message = 'Error during communication.']);
}

/// Thrown when the server rejects a request as invalid.
///
/// Typically maps to HTTP 400, 404, or 500 responses.
class BadRequestException extends AppException {
  const BadRequestException([super.message = 'Invalid request.']);
}

/// Thrown when the caller is not authorized to access the requested resource.
///
/// Typically maps to HTTP 401 responses after token refresh has failed.
class UnauthorisedException extends AppException {
  const UnauthorisedException([super.message = 'Unauthorised request.']);
}

/// Thrown when the caller is authenticated but not allowed to access a resource.
///
/// Typically maps to HTTP 403 responses. The default message is shown via
/// flushbar from the network layer.
class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Access Restricted.']);
}

/// Thrown when the HTTP method used is not supported by the endpoint.
///
/// Typically maps to HTTP 405 responses.
class MethodNotAllowedException extends AppException {
  const MethodNotAllowedException([
    super.message = 'Method not allowed.',
  ]);
}

/// Thrown when the device has no active internet connection.
///
/// Raised by the pre-request connectivity check, or when a socket failure is
/// caught during a network call.
class NoInternetException extends AppException {
  const NoInternetException([super.message = 'No internet connection.']);
}
