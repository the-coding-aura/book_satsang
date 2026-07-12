/// Request body for OTP verification and member-login API endpoints.
class VerifyOTPRequestModel {
  /// Mobile number that received the OTP.
  String? mobileNumber;

  /// One-time password entered by the user.
  String? otp;

  /// Creates a verify-OTP request with [mobileNumber] and [otp].
  VerifyOTPRequestModel({this.mobileNumber, this.otp});

  /// Creates a request model from a JSON map returned by the API.
  VerifyOTPRequestModel.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    otp = json['otp'];
  }

  /// Serializes this request to a JSON map for the API.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    data['otp'] = otp;
    return data;
  }
}
