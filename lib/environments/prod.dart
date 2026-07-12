import 'package:book_satsang/network_module/network/app_config.dart';
import 'package:book_satsang/network_module/network/app_environment.dart';

/// Initializes the production build flavor and API configuration.
///
/// Configures [AppConfig] with the production base URL and live environment
/// settings.
void startPROD() {
  AppConfig.setup(
    name: 'Book Satsang',
    flavor: 'PROD',
    baseUrl: 'https://api.production.com',
    env: AppEnvironmentType.live,
  );
}
