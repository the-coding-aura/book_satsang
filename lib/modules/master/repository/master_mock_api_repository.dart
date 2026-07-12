import 'package:book_satsang/modules/master/models/response_models/upload_file_response_model.dart';
import 'package:book_satsang/modules/registeration/models/response_models/designation_list_response_model.dart';

import '../../registeration/models/response_models/taluka_list_response_model.dart';
import '../../registeration/models/response_models/village_list_response_model.dart';
import 'master_api_repository.dart';

/// Mock implementation of [MasterApiRepository] for development and testing.
///
/// Returns delayed stub responses without making network requests.
class MasterMockApiRepository implements MasterApiRepository {
  static const _delay = Duration(milliseconds: 800);

  /// Returns an empty successful upload response.
  @override
  Future<UploadFileResponseModel?> uploadFile(
    String filePath,
    String pathName,
    String serverFileName,
    void Function(int sent, int total)? onProgress,
  ) async {
    await Future.delayed(_delay);
    return UploadFileResponseModel(data: []);
  }

  /// Returns an empty successful designation list response.
  @override
  Future<DesignationListResponseModel?> fetchDesignation() async {
    await Future.delayed(_delay);
    return DesignationListResponseModel.success(
      data: List.empty(),
      message: 'Designation fetched successfuly.',
    );
  }

  /// Returns an empty successful taluka list response.
  @override
  Future<TalukaListResponseModel?> fetchTaluka(
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(_delay);
    return TalukaListResponseModel.success(
      data: List.empty(),
      message: 'Taluka fetched successfuly.',
    );
  }

  /// Returns an empty successful village list response.
  @override
  Future<VillageListResponseModel?> fetchVillage(
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(_delay);
    return VillageListResponseModel.success(
      data: List.empty(),
      message: 'Village fetched successfuly.',
    );
  }
}
