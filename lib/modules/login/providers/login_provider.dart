import 'package:book_satsang/configs/components/app_flushbar.dart';
import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/login/models/request_models/send_otp_request_model.dart';
import 'package:book_satsang/modules/login/models/request_models/user_exist_request_model.dart';
import 'package:book_satsang/modules/login/repository/login_api_repository.dart';
import 'package:book_satsang/modules/login/validators/login_validator.dart';
import 'package:book_satsang/modules/otp/enums/otp_enums.dart';
import 'package:book_satsang/modules/otp/models/data_models/otp_arguments.dart';
// import 'package:book_satsang/modules/otp/repository/otp_api_repository.dart';
import 'package:book_satsang/network_module/response/api_response.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../otp/repository/otp_api_repository.dart';

/// State and business logic for the login screen.
///
/// Validates input, checks user registration, sends OTP, and navigates to
/// the OTP flow.
class LoginProvider extends ChangeNotifier with LoginValidator {
  final LoginApiRepository _loginRepository = getIt<LoginApiRepository>();
  final OTPApiRepository _otpRepository = getIt<OTPApiRepository>();

  /// Stream source for the entered mobile number.
  final BehaviorSubject<String> mobileNumberSubject = BehaviorSubject<String>();

  /// Stream source for terms-and-conditions acceptance.
  final BehaviorSubject<bool> termAcceptCheck = BehaviorSubject<bool>();

  /// Text controller bound to the mobile number input field.
  final TextEditingController mobileNumberCon = TextEditingController();

  /// API state for the send-OTP request.
  ApiResponse<int> sendOtpResponse = ApiResponse.idle();

  /// API state for the user-existence check request.
  ApiResponse<int> existResponse = ApiResponse.idle();

  /// Validated stream of mobile numbers from [mobileNumberSubject].
  Stream<String> mobileStream() =>
      mobileNumberSubject.stream.transform(validateMobNum());

  /// Validated stream of terms acceptance from [termAcceptCheck].
  Stream<bool> termStream() => termAcceptCheck.stream.transform(validateTC());

  /// Updates [mobileNumberSubject] when the user types a mobile number.
  Function(String) get changeMobileNum => mobileNumberSubject.sink.add;

  /// Updates [termAcceptCheck] when the user toggles terms acceptance.
  Function(bool) get changeTC => termAcceptCheck.sink.add;

  /// Emits whether the form is valid for submitting an OTP request.
  ///
  /// Requires a 10-digit mobile number and accepted terms.
  Stream<bool> isValidForSent() => Rx.combineLatest2(
    mobileNumberSubject,
    termAcceptCheck.startWith(false),
    (mobile, terms) => RegExp(r'^\d{10}$').hasMatch(mobile) && terms,
  );

  /// Checks whether the mobile number is registered and routes accordingly.
  ///
  /// Existing users go to login OTP verification; new users trigger [sendOTP].
  Future<void> checkUserExist(BuildContext context) async {
    final mobile = mobileNumberSubject.valueOrNull;
    if (mobile == null) {
      AppFlushbar.warning(context, message: 'Mobile is empty.');
      return;
    }

    // Step 1 — verify the user is registered
    existResponse = ApiResponse.loading('Checking user...');
    notifyListeners();

    // bool userExists = false;
    await _loginRepository
        .isUserExist(UserExistRequestModel(mobileNumber: mobile).toJson())
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null &&
              value.data?.status == 1) {
            // userExists = true;
            existResponse = ApiResponse.completed(value.data?.status ?? 0);
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                RoutesName.otp,
                arguments: OtpArguments(
                  mobileNo: mobile,
                  verificationType: VerificationType.login,
                ),
              );
              AppFlushbar.success(
                context,
                message: value.message ?? "OTP sent successfully.",
              );
            }
          } else {
            existResponse = ApiResponse.idle();
            notifyListeners();
            if (context.mounted) {
              await sendOTP(context);
            }
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          existResponse = ApiResponse.error(msg);
          if (context.mounted) {
            AppFlushbar.error(context, message: msg);
          }
        });
    notifyListeners();
  }

  /// Sends an OTP to the entered mobile number for new-user registration.
  ///
  /// On success, navigates to the OTP screen with [VerificationType.otp].
  Future<void> sendOTP(BuildContext context) async {
    final mobile = mobileNumberSubject.valueOrNull;
    if (mobile == null) {
      AppFlushbar.warning(context, message: 'Mobile is empty.');
      return;
    }

    // Step 1 — verify the user is registered
    sendOtpResponse = ApiResponse.loading('Checking user...');
    notifyListeners();

    // bool userExists = false;
    await _otpRepository
        .sendOTP(SendOTPRequestModel(mobileNumber: mobile).toJson())
        .then((value) {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null &&
              value.data == 1) {
            existResponse = ApiResponse.completed(value.data ?? 0);
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                RoutesName.otp,
                arguments: OtpArguments(
                  mobileNo: mobile,
                  verificationType: VerificationType.otp,
                ),
              );
              AppFlushbar.success(
                context,
                message: value.message ?? "OTP sent successfully.",
              );
            }
          } else {
            final msg =
                value?.message ?? 'Oops something went wrong, Try again.';
            sendOtpResponse = ApiResponse.error(msg);
            if (context.mounted) {
              AppFlushbar.error(context, message: msg);
            }
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          existResponse = ApiResponse.error(msg);
          if (context.mounted) {
            AppFlushbar.error(context, message: msg);
          }
        });

    notifyListeners();
  }

  /// Releases stream subjects, the text controller, and related resources.
  ///
  /// Must be called when the provider is removed from the widget tree.
  @override
  void dispose() {
    mobileNumberSubject.close();
    termAcceptCheck.close();
    mobileNumberCon.dispose();
    super.dispose();
  }
}
