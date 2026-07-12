import '../models/response_models/register_member_response_model.dart';

/// Abstract contract for member registration API operations.
///
/// Defines the endpoint used to submit a new member profile.
abstract class RegisterApiRepository {
  /// Submits member registration data and returns the new member identifier.
  Future<RegisterMemberResponseModel?> registerMember(
    Map<String, dynamic> body,
  );
}
