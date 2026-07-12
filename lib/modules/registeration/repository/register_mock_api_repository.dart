import 'package:book_satsang/modules/registeration/models/response_models/register_member_response_model.dart';
import 'register_api_repository.dart';

/// Mock implementation of [RegisterApiRepository] for development and testing.
///
/// Returns a delayed success response without making network requests.
class RegisterMockApiRepository implements RegisterApiRepository {
  static const _delay = Duration(milliseconds: 800);

  /// Returns a stub successful registration response.
  @override
  Future<RegisterMemberResponseModel?> registerMember(
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(_delay);
    return RegisterMemberResponseModel.success(
      data: 1,
      message: 'Member registered successfully.',
    );
  }
}
