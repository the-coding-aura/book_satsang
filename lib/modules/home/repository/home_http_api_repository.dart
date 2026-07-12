import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/home/models/response_models/profile_get_response_model.dart';
import 'package:book_satsang/modules/home/models/response_models/satsang_list_response_model.dart';
import 'package:book_satsang/modules/home/repository/home_api_repository.dart';
import 'package:book_satsang/network_module/network/api_path.dart';
import 'package:book_satsang/network_module/network/base_api_services.dart';

/// HTTP implementation of [HomeApiRepository].
///
/// Delegates network calls to [BaseApiServices] using configured API paths.
class HomeHttpApiRepository implements HomeApiRepository {
  /// Creates a repository backed by the injected [BaseApiServices].
  HomeHttpApiRepository() : _apiService = getIt<BaseApiServices>();

  final BaseApiServices _apiService;

  /// Fetches a paginated list of satsang events.
  @override
  Future<SatsangListResponseModel?> fetchSansangList(
    Map<String, dynamic> body,
  ) async {
    final json = await _apiService.get(
      ApiPathHelper.getValue(ApiPath.fetchSatsang),
      queryParams: body,
    );
    return fetchSatsangListResponse(json);
  }

  /// Fetches the authenticated member's profile details.
  @override
  Future<ProfileGetResponseModel?> fetchProfileDetails() async {
    final json = await _apiService.get(
      ApiPathHelper.getValue(ApiPath.fetchMemberProfile),
    );
    return profileGetResfromJson(json);
  }
}
