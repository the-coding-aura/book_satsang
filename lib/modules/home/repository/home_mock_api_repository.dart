import 'package:book_satsang/modules/home/models/response_models/profile_get_response_model.dart';
import 'package:book_satsang/modules/home/models/response_models/satsang_list_response_model.dart';
import 'package:book_satsang/modules/home/repository/home_api_repository.dart';

/// Mock implementation of [HomeApiRepository] for development and testing.
///
/// Returns delayed stub responses without making network requests.
class HomeMockApiRepository implements HomeApiRepository {
  static const _delay = Duration(milliseconds: 800);

  /// Fetches a paginated list of satsang events.
  @override
  Future<SatsangListResponseModel?> fetchSansangList(
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(_delay);
    return SatsangListResponseModel.success(
      data: [],
      message: 'Satsang list retrived successfully.',
    );
  }

  /// Fetches the authenticated member's profile details.
  @override
  Future<ProfileGetResponseModel?> fetchProfileDetails() async {
    await Future.delayed(_delay);
    return ProfileGetResponseModel.success(
      data: ProfileData(
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: '01/01/1990',
      ),
      message: 'Profile details retrieved successfully.',
    );
  }

  // @override
  // Future<VerifyOTPResponseModel?> verifyOTP(Map<String, dynamic> body) async {
  //   await Future.delayed(_delay);
  //   final enteredOtp = body['otp'] ?? '';
  //   if (enteredOtp == AppConstants.mockOtp) {
  //     return VerifyOTPResponseModel.success(
  //       data: VerifyOTPModel(
  //         accessToken: 'demo token',
  //         refreshToken: 'demo refresh token',
  //       ),
  //       message: 'OTP verified successfully.',
  //     );
  //   }
  //   return VerifyOTPResponseModel.failure(
  //     message: 'Invalid OTP. Use ${AppConstants.mockOtp} for mock.',
  //   );
  // }
}
