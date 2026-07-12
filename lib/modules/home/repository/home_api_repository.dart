import 'package:book_satsang/modules/home/models/response_models/profile_get_response_model.dart';
import 'package:book_satsang/modules/home/models/response_models/satsang_list_response_model.dart';

/// Abstract contract for home module API operations.
///
/// Defines endpoints for satsang listing and profile retrieval.
abstract class HomeApiRepository {
  /// Fetches a paginated list of satsang events.
  Future<SatsangListResponseModel?> fetchSansangList(Map<String, dynamic> body);

  /// Fetches the authenticated member's profile details.
  Future<ProfileGetResponseModel?> fetchProfileDetails();
}
