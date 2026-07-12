import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/login/models/response_models/user_exist_response_model.dart';
import 'package:book_satsang/modules/login/repository/login_api_repository.dart';
import 'package:book_satsang/network_module/network/api_path.dart';
import 'package:book_satsang/network_module/network/base_api_services.dart';

/// HTTP implementation of [LoginApiRepository].
///
/// Posts user-existence checks through the shared [BaseApiServices] client.
class LoginHttpApiRepository implements LoginApiRepository {
  /// Creates a repository backed by the injected API service.
  LoginHttpApiRepository() : _apiService = getIt<BaseApiServices>();

  final BaseApiServices _apiService;

  /// Posts [body] to the user-existence endpoint and parses the response.
  ///
  /// Returns `null` when the HTTP layer yields no parseable payload.
  @override
  Future<UserExistResponseModel?> isUserExist(Map<String, dynamic> body) async {
    final json = await _apiService.post(
      ApiPathHelper.getValue(ApiPath.isUserExist),
      body: body,
    );
    return userExistFromJson(json as Map<String, dynamic>);
  }
}
