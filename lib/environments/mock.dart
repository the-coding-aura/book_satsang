import 'package:book_satsang/network_module/network/app_config.dart';
import 'package:book_satsang/network_module/network/app_environment.dart';

/// Initializes the mock build flavor and API configuration.
///
/// Configures [AppConfig] to use mock services and a local base URL.
void startMOCK() {
  AppConfig.setup(
    name: 'Book Satsang [MOCK]',
    flavor: 'MOCK',
    baseUrl: 'http://localhost:3000',
    env: AppEnvironmentType.mock,
  );
}
