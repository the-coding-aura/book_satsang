import 'package:flutter/foundation.dart';

import 'app_environment.dart';

/// Holds runtime configuration set once at app startup.
///
/// Values are assigned via [setup] from the active flavor entry point and
/// read globally by the network layer.
class AppConfig {
  AppConfig._();

  /// Display name of the running app build.
  static late String appName;

  /// Name of the active flavor (e.g. dev, staging, prod).
  static late String flavorName;

  /// Base URL prepended to every API path.
  static late String apiBaseUrl;

  /// The environment type associated with this flavor.
  static late AppEnvironmentType environment;

  /// Initializes all static configuration values for the current flavor.
  ///
  /// Must be called before any network requests are made.
  static void setup({
    required String name,
    required String flavor,
    required String baseUrl,
    required AppEnvironmentType env,
  }) {
    appName = name;
    flavorName = flavor;
    apiBaseUrl = baseUrl;
    environment = env;
    AppEnvironment.current = env;

    if (kDebugMode) {
      debugPrint('APP CONFIGURED | FLAVOR: $flavor | BASE URL: $baseUrl');
    }
  }
}
