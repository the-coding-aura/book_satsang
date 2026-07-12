import 'package:book_satsang/modules/login/models/response_models/user_exist_response_model.dart';

/// Abstract contract for login-specific API operations.
abstract class LoginApiRepository {
  /// Checks whether a user with the given mobile number is registered.
  Future<UserExistResponseModel?> isUserExist(Map<String, dynamic> body);
}
