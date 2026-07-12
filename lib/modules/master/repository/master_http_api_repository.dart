import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/master/models/response_models/upload_file_response_model.dart';
import 'package:book_satsang/modules/registeration/models/response_models/designation_list_response_model.dart';
import 'package:book_satsang/network_module/network/api_path.dart';
import 'package:book_satsang/network_module/network/base_api_services.dart';

import '../../registeration/models/response_models/taluka_list_response_model.dart';
import '../../registeration/models/response_models/village_list_response_model.dart';
import 'master_api_repository.dart';

/// HTTP implementation of [MasterApiRepository].
///
/// Delegates master data and upload calls to [BaseApiServices].
class MasterHttpApiRepository implements MasterApiRepository {
  /// Creates a repository backed by the injected [BaseApiServices].
  MasterHttpApiRepository() : _apiService = getIt<BaseApiServices>();

  final BaseApiServices _apiService;

  static const String _fileFieldName = 'files';

  /// Uploads a file to the configured upload endpoint.
  @override
  Future<UploadFileResponseModel> uploadFile(
    String filePath,
    String pathName,
    String serverFileName,
    void Function(int sent, int total)? onProgress,
  ) async {
    final json = await _apiService.uploadFile(
      ApiPathHelper.getValue(ApiPath.uploadFile),
      filePath: filePath,
      fieldName: _fileFieldName,
      serverFileName: serverFileName,
      additionalFields: {'pathName': pathName},
      onProgress: onProgress,
    );
    return uplaodFileBindResponse(json as Map<String, dynamic>);
  }

  /// Fetches the designation master list from the remote API.
  @override
  Future<DesignationListResponseModel?> fetchDesignation() async {
    final json = await _apiService.get(
      ApiPathHelper.getValue(ApiPath.fetchDesignation),
    );
    return fetchDesignationListResponse(json as Map<String, dynamic>);
  }

  /// Fetches taluka master records filtered by [body].
  @override
  Future<TalukaListResponseModel?> fetchTaluka(
    Map<String, dynamic> body,
  ) async {
    final json = await _apiService.get(
      ApiPathHelper.getValue(ApiPath.fetchTaluka),
      queryParams: body,
    );
    return fetchTalukaListResponse(json as Map<String, dynamic>);
  }

  /// Fetches village master records filtered by [body].
  @override
  Future<VillageListResponseModel?> fetchVillage(
    Map<String, dynamic> body,
  ) async {
    final json = await _apiService.get(
      ApiPathHelper.getValue(ApiPath.fetchVillage),
      queryParams: body,
    );
    return fetchVillageDataResponse(json as Map<String, dynamic>);
  }
}
