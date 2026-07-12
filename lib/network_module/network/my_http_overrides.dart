import 'dart:io';

/// Bypasses SSL certificate validation during development.
///
/// Do NOT use in production builds.
class MyHttpOverrides extends HttpOverrides {
  /// Creates an [HttpClient] that accepts all server certificates.
  ///
  /// Intended for local or staging servers with self-signed certificates.
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
