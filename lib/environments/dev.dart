import 'package:book_satsang/network_module/network/app_config.dart';
import 'package:book_satsang/network_module/network/app_environment.dart';

/// Initializes the development build flavor and API configuration.
///
/// Configures [AppConfig] with the DEV base URL and live environment settings.
void startDEV() {
  AppConfig.setup(
    name: 'Book Satsang [DEV]',
    flavor: 'DEV',
    baseUrl: 'https://vhp-karwar-api.ifelsesolutions.in/api',
    env: AppEnvironmentType.live,
  );
}
