import 'package:book_satsang/modules/home/models/response_models/add_satsang_response_model.dart';
import 'package:book_satsang/modules/home/models/response_models/member_list_response_model.dart';
import 'package:book_satsang/modules/home/models/response_models/profile_get_response_model.dart';
import 'package:book_satsang/modules/home/models/response_models/satsang_list_response_model.dart';

/// Abstract contract for home module API operations.
///
/// Defines endpoints for satsang listing and profile retrieval.
abstract class HomeApiRepository {
  /// Fetches a paginated list of satsang events.
  Future<SatsangListResponseModel?> fetchSansangList(Map<String, dynamic> body);

  /// Creates a new satsang event.
  Future<AddSatsangResponseModel?> addSatsang(Map<String, dynamic> body);

  /// Fetches the authenticated member's profile details.
  Future<ProfileGetResponseModel?> fetchProfileDetails();

  /// Fetches all members for the members directory.
  Future<MemberListResponseModel?> fetchAllMembers();
}
