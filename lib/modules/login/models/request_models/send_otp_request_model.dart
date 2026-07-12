/// Request body for the Send OTP API endpoint.
class SendOTPRequestModel {
  /// Mobile number that should receive the OTP.
  String? mobileNumber;

  /// Creates a send-OTP request for the given [mobileNumber].
  SendOTPRequestModel({this.mobileNumber});

  /// Serializes this request to a JSON map for the API.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
