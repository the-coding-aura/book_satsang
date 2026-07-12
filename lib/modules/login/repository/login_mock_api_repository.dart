import 'package:book_satsang/modules/login/models/response_models/user_exist_response_model.dart';
import 'package:book_satsang/modules/login/repository/login_api_repository.dart';

/// Mock implementation of [LoginApiRepository] for development and testing.
///
/// Simulates network delay and treats all valid requests as existing users.
class LoginMockApiRepository implements LoginApiRepository {
  static const _delay = Duration(milliseconds: 600);

  /// Simulates a successful user-existence check after a short delay.
  ///
  /// Any 10-digit number is treated as a registered user in mock mode.
  @override
  Future<UserExistResponseModel?> isUserExist(Map<String, dynamic> body) async {
    await Future.delayed(_delay);
    return UserExistResponseModel.success(
      data: UserExistModel(status: 1),
      message: 'User exists.',
    );
  }
}
