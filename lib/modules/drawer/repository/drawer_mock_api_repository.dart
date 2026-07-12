import 'package:book_satsang/modules/drawer/models/response_models/logout_response_model.dart';
import 'drawer_api_repository.dart';

/// Mock implementation of [DrawerApiRepository] for development and testing.
///
/// Returns a delayed success response without making network requests.
class DrawerMockApiRepository implements DrawerApiRepository {
  static const _delay = Duration(milliseconds: 800);

  /// Returns a stub successful logout response.
  @override
  Future<LogoutResponseModel?> logoutUser(Map<String, dynamic> body) async {
    await Future.delayed(_delay);
    return LogoutResponseModel.success(
      data: 1,
      message: 'User logged out successfully.',
    );
  }
}
