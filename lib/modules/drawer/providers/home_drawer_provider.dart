import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:book_satsang/network_module/response/api_response.dart';
import 'package:flutter/material.dart';

import '../../../dependency_injection/locator.dart';
import '../../../services/auth/auth_service.dart';
import '../models/request_models/logout_request_model.dart';
import '../repository/drawer_api_repository.dart';

/// Manages logout flow for the home navigation drawer.
///
/// Coordinates local session clearing with server-side token invalidation.
class HomeDrawerProvider extends ChangeNotifier {
  final _authService = getIt<AuthService>();
  final _drawerApiRepository = getIt<DrawerApiRepository>();

  /// API response for the logout request.
  ApiResponse<int> logoutResponse = ApiResponse.idle();

  /// Logs the user out locally and on the server when possible.
  ///
  /// Navigates to the login screen after a successful logout.
  Future<void> logoutUser(BuildContext context) async {
    var authData = await _authService.readAuthData();
    if (authData?.refreshToken == null ||
        authData?.refreshToken.isEmpty == true) {
      await _authService.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.login,
          (route) => false,
        );
      }
      return;
    }
    var response = await logoutUserFromServer(authData?.refreshToken);
    if (response && context.mounted) {
      await _authService.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.login,
          (route) => false,
        );
      }
    }
  }

  /// Calls the logout API with [refreshToken] and updates [logoutResponse].
  ///
  /// Returns `true` when the server reports a successful logout.
  Future<bool> logoutUserFromServer(String? refreshToken) async {
    logoutResponse = ApiResponse.loading("Logging out...");
    notifyListeners();
    await _drawerApiRepository
        .logoutUser(LogoutRequestModel(refreshToken: refreshToken).toJson())
        .then((value) async {
          if (value != null && value.isSuccessful == true) {
            logoutResponse = ApiResponse.completed(value.data ?? 0);
          } else {
            final msg = value?.message ?? 'Logout failed.';
            logoutResponse = ApiResponse.error(msg);
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          logoutResponse = ApiResponse.error(msg);
        });
    notifyListeners();
    if ((logoutResponse.data ?? 0) == 1) {
      return true;
    } else {
      return false;
    }
  }
}
