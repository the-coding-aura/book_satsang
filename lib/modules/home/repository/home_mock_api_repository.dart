import 'package:book_satsang/modules/home/models/response_models/add_satsang_response_model.dart';
import 'package:book_satsang/modules/home/models/response_models/member_list_response_model.dart';
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

  /// Creates a new satsang event.
  @override
  Future<AddSatsangResponseModel?> addSatsang(Map<String, dynamic> body) async {
    await Future.delayed(_delay);
    return AddSatsangResponseModel.success(
      data: 1,
      message: 'Satsang added successfully.',
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

  /// Fetches all members for the members directory.
  @override
  Future<MemberListResponseModel?> fetchAllMembers() async {
    await Future.delayed(_delay);
    return MemberListResponseModel.success(
      data: const [
        MemberData(
          firstName: 'Vijay',
          lastName: 'Deshmukh',
          mobileNumber: '9846028033',
          dateOfBirth: '1993-02-12T07:34:00',
          villageName: 'Kannamangala',
          talukaName: 'Mokhada',
          designationName: 'Help Desk',
        ),
        MemberData(
          firstName: 'Naresh',
          lastName: 'Shinde',
          mobileNumber: '9541074272',
          dateOfBirth: '1992-12-06T04:55:00',
          villageName: 'Hosanagalapura',
          talukaName: 'Derapur',
          designationName: 'Help Desk',
        ),
      ],
      message: 'Members fetched successfully.',
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
