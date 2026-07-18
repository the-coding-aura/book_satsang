import 'dart:async';
import 'dart:io';

/// Checks whether the device can reach the public internet.
///
/// Uses a DNS lookup against a well-known host so connectivity is verified
/// without third-party packages. A successful lookup with a non-empty address
/// means the device has network access suitable for API calls.
class ConnectivityService {
  /// Host used for the DNS reachability probe.
  static const String _lookupHost = 'one.one.one.one';

  /// Maximum time to wait for the connectivity probe.
  static const Duration _lookupTimeout = Duration(seconds: 5);

  /// Returns `true` when a DNS lookup succeeds and yields a usable address.
  ///
  /// Returns `false` on [SocketException], [TimeoutException], or any other
  /// failure during the probe.
  Future<bool> hasInternetConnection() async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup(
        _lookupHost,
      ).timeout(_lookupTimeout);
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
