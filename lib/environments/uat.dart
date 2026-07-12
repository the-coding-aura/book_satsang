import 'package:book_satsang/network_module/network/app_config.dart';
import 'package:book_satsang/network_module/network/app_environment.dart';

/// Initializes the UAT build flavor and API configuration.
///
/// Configures [AppConfig] with the UAT base URL and live environment settings.
void startUAT() {
  AppConfig.setup(
    name: 'Book Satsang [UAT]',
    flavor: 'UAT',
    baseUrl: 'https://api.uat.com',
    env: AppEnvironmentType.live,
  );
}
