import 'dart:async';

import 'package:book_satsang/configs/components/app_flushbar.dart';
import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:book_satsang/modules/otp/enums/otp_enums.dart';
import 'package:book_satsang/modules/otp/models/data_models/otp_arguments.dart';
import 'package:book_satsang/modules/otp/models/request_models/verify_otp_request_model.dart';
import 'package:book_satsang/services/auth/auth_service.dart';
import 'package:book_satsang/utils/constants/app_constants.dart';
import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/otp/repository/otp_api_repository.dart';
import 'package:book_satsang/network_module/response/api_response.dart';
import 'package:flutter/material.dart';

/// State and business logic for OTP verification and resend flows.
///
/// Handles login and registration verification paths and persists tokens on
/// successful member login.
class OtpProvider extends ChangeNotifier {
  late VerificationType _verificationType;
  final OTPApiRepository _otpRepository = getIt<OTPApiRepository>();
  final AuthService _auth = getIt<AuthService>();

  /// Masked mobile number shown on the OTP screen (for example `+91 XXXXXX1234`).
  String maskedMobile = '';

  String _mobileNumber = '';

  /// Countdown timer that drives OTP expiry and resend UI.
  Timer? otpTimer;

  /// Remaining seconds before the OTP expires or resend is offered.
  int remSec = AppConstants.otpTimerSeconds;

  /// API state for the resend-OTP request.
  ApiResponse<int> resendOtpResponse = ApiResponse.idle();

  /// API state for member login OTP verification.
  ApiResponse<(String, String)> memberLoginResponse = ApiResponse.idle();

  /// API state for registration OTP verification.
  ApiResponse<int> verifyOtpResponse = ApiResponse.idle();

  /// Reads route [OtpArguments] and initializes masked mobile and the timer.
  ///
  /// Clears [maskedMobile] when arguments are missing.
  void assignMobile(BuildContext context) {
    final otpArg = ModalRoute.of(context)?.settings.arguments as OtpArguments?;
    if (otpArg == null) {
      maskedMobile = '';
      return;
    }
    _mobileNumber = otpArg.mobileNo;
    _verificationType = otpArg.verificationType;
    maskedMobile = '+91 XXXXXX${_mobileNumber.substring(6)}';
    notifyListeners();
    startTimer();
  }

  /// Starts or restarts the OTP countdown from [AppConstants.otpTimerSeconds].
  ///
  /// Cancels any existing [otpTimer] before scheduling a new periodic timer.
  void startTimer() {
    otpTimer?.cancel();
    remSec = AppConstants.otpTimerSeconds;
    otpTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _decrementTimer(),
    );
  }

  void _decrementTimer() {
    if (remSec > 0) {
      remSec--;
    } else {
      otpTimer?.cancel();
    }
    notifyListeners();
  }

  // Future<void> resendOtp(BuildContext context) async {
  //   if (_mobileNumber.isEmpty) return;

  //   resendOtpResponse = ApiResponse.loading('Resending OTP...');
  //   notifyListeners();

  //   await _otpRepository
  //       .resendOTP({'mobileNo': _mobileNumber})
  //       .then((value) {
  //         if (value != null && value.isSuccessful == true && value.data == 1) {
  //           resendOtpResponse = ApiResponse.completed(value.data!);
  //           startTimer();
  //           if (context.mounted) {
  //             AppFlushbar.success(
  //               context,
  //               message: value.message ?? 'OTP resent successfully.',
  //             );
  //           }
  //         } else {
  //           final msg = value?.message ?? 'Failed to resend OTP.';
  //           resendOtpResponse = ApiResponse.error(msg);
  //           if (context.mounted) {
  //             AppFlushbar.error(context, message: msg);
  //           }
  //         }
  //       })
  //       .onError((error, _) {
  //         final msg = error.toString();
  //         resendOtpResponse = ApiResponse.error(msg);
  //         if (context.mounted) {
  //           AppFlushbar.error(context, message: msg);
  //         }
  //       });

  //   notifyListeners();
  // }

  /// Verifies OTP for an existing member and stores auth tokens on success.
  ///
  /// Navigates to home when verification succeeds.
  Future<void> memberLogin(BuildContext context, String pin) async {
    if (_mobileNumber.isEmpty) return;

    memberLoginResponse = ApiResponse.loading('Verifying OTP...');
    notifyListeners();

    await _otpRepository
        .memberLogin(
          VerifyOTPRequestModel(mobileNumber: _mobileNumber, otp: pin).toJson(),
        )
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            memberLoginResponse = ApiResponse.completed((
              value.data?.accessToken ?? "",
              value.data?.refreshToken ?? "",
            ));
            await _auth.storeAuthData(
              AuthData(
                authToken: value.data?.accessToken ?? "",
                refreshToken: value.data?.refreshToken ?? "",
              ),
            );
            otpTimer?.cancel();
            if (context.mounted) {
              AppFlushbar.success(
                context,
                message: value.message ?? "OTP verified successfully.",
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.home,
                (route) => false,
              );
            }
          } else {
            final msg = value?.message ?? 'OTP verification failed.';
            memberLoginResponse = ApiResponse.error(msg);
            if (context.mounted) {
              AppFlushbar.error(context, message: msg);
            }
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          memberLoginResponse = ApiResponse.error(msg);
          if (context.mounted) {
            AppFlushbar.error(context, message: msg);
          }
        });

    notifyListeners();
  }

  /// Dispatches OTP verification based on [VerificationType] when [pin] is complete.
  ///
  /// Calls [memberLogin] for login flow or [verifyOtp] for registration.
  Future<void> onCompletedPin(String pin, BuildContext context) async {
    if (pin.length == AppConstants.otpLength) {
      if (_verificationType == VerificationType.login) {
        await memberLogin(context, pin);
      } else {
        await verifyOtp(context, pin);
      }
    }
  }

  /// Verifies OTP for new-user registration and navigates to the register screen.
  ///
  /// Does not persist auth tokens; registration continues on the next route.
  Future<void> verifyOtp(BuildContext context, String pin) async {
    if (_mobileNumber.isEmpty) return;

    verifyOtpResponse = ApiResponse.loading('Verifying OTP...');
    notifyListeners();

    await _otpRepository
        .verifyOTP(
          VerifyOTPRequestModel(mobileNumber: _mobileNumber, otp: pin).toJson(),
        )
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            verifyOtpResponse = ApiResponse.completed(value.data ?? 0);
            otpTimer?.cancel();
            if (context.mounted) {
              AppFlushbar.success(
                context,
                message: value.message ?? "OTP verified successfully.",
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.register,
                (route) => false,
                arguments: _mobileNumber,
              );
            }
          } else {
            final msg = value?.message ?? 'OTP verification failed.';
            verifyOtpResponse = ApiResponse.error(msg);
            if (context.mounted) {
              AppFlushbar.error(context, message: msg);
            }
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          verifyOtpResponse = ApiResponse.error(msg);
          if (context.mounted) {
            AppFlushbar.error(context, message: msg);
          }
        });

    notifyListeners();
  }

  /// Cancels the OTP countdown timer when the provider is disposed.
  ///
  /// Must be called when the provider is removed from the widget tree.
  @override
  void dispose() {
    otpTimer?.cancel();
    super.dispose();
  }
}
