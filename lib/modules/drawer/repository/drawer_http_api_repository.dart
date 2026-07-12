import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/drawer/models/response_models/logout_response_model.dart';
import 'package:book_satsang/network_module/network/api_path.dart';
import 'package:book_satsang/network_module/network/base_api_services.dart';

import 'drawer_api_repository.dart';

/// HTTP implementation of [DrawerApiRepository].
///
/// Posts logout payloads through [BaseApiServices].
class DrawerHttpApiRepository implements DrawerApiRepository {
  /// Creates a repository backed by the injected [BaseApiServices].
  DrawerHttpApiRepository() : _apiService = getIt<BaseApiServices>();

  final BaseApiServices _apiService;

  /// Submits the logout request to the remote API.
  @override
  Future<LogoutResponseModel?> logoutUser(Map<String, dynamic> body) async {
    final json = await _apiService.post(
      ApiPathHelper.getValue(ApiPath.logout),
      body: body,
    );
    return logoutResfromJson(json as Map<String, dynamic>);
  }
}
