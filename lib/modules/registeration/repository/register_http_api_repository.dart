import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/registeration/models/response_models/register_member_response_model.dart';
import 'package:book_satsang/network_module/network/api_path.dart';
import 'package:book_satsang/network_module/network/base_api_services.dart';

import 'register_api_repository.dart';

/// HTTP implementation of [RegisterApiRepository].
///
/// Posts registration payloads through [BaseApiServices].
class RegisterHttpApiRepository implements RegisterApiRepository {
  /// Creates a repository backed by the injected [BaseApiServices].
  RegisterHttpApiRepository() : _apiService = getIt<BaseApiServices>();

  final BaseApiServices _apiService;

  /// Submits member registration data to the remote API.
  @override
  Future<RegisterMemberResponseModel?> registerMember(
    Map<String, dynamic> body,
  ) async {
    final json = await _apiService.post(
      ApiPathHelper.getValue(ApiPath.registerMember),
      body: body,
    );
    return registerMemberResfromJson(json as Map<String, dynamic>);
  }
}
