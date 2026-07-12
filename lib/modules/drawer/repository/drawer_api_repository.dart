import '../models/response_models/logout_response_model.dart';

/// Abstract contract for drawer-related API operations.
///
/// Defines the endpoint used to invalidate the user session on the server.
abstract class DrawerApiRepository {
  /// Logs out the user by invalidating the refresh token on the server.
  Future<LogoutResponseModel?> logoutUser(Map<String, dynamic> body);
}
