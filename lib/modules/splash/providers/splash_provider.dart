import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:flutter/material.dart';
import '../../../dependency_injection/locator.dart';
import '../../../services/auth/auth_service.dart';

/// Manages splash-screen session checks and initial navigation.
///
/// Routes authenticated users to home and others to the login flow.
class SplashProvider extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();

  /// Reads stored auth data and navigates to home or login accordingly.
  ///
  /// No-op navigation when [context] is no longer mounted after the async read.
  Future<void> checkSessionExists(BuildContext context) async {
    var data = await _authService.readAuthData();
    if (context.mounted) {
      if (data != null) {
        Navigator.pushReplacementNamed(context, RoutesName.home);
      } else {
        // User is not logged in, navigate to the login screen
        Navigator.pushReplacementNamed(context, RoutesName.login);
      }
    }
  }
}
