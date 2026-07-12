import 'package:book_satsang/modules/master/models/response_models/upload_file_response_model.dart';
import 'package:book_satsang/modules/registeration/models/response_models/designation_list_response_model.dart';

import '../../registeration/models/response_models/taluka_list_response_model.dart';
import '../../registeration/models/response_models/village_list_response_model.dart';

/// Abstract contract for shared master data and file upload APIs.
///
/// Covers designation, taluka, village lookups, and profile file uploads.
abstract class MasterApiRepository {
  /// Uploads a file and reports byte progress through [onProgress].
  Future<UploadFileResponseModel?> uploadFile(
    String filePath,
    String pathName,
    String serverFileName,
    void Function(int sent, int total)? onProgress,
  );

  /// Fetches the designation master list.
  Future<DesignationListResponseModel?> fetchDesignation();

  /// Fetches taluka master records matching the request [body].
  Future<TalukaListResponseModel?> fetchTaluka(Map<String, dynamic> body);

  /// Fetches village master records matching the request [body].
  Future<VillageListResponseModel?> fetchVillage(Map<String, dynamic> body);
}
