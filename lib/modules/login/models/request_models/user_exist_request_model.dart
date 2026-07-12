/// Request body for the user-existence check API endpoint.
class UserExistRequestModel {
  /// Mobile number to look up on the server.
  String? mobileNumber;

  /// Creates a user-existence request for the given [mobileNumber].
  UserExistRequestModel({this.mobileNumber});

  /// Creates a request model from a JSON map returned by the API.
  UserExistRequestModel.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
  }

  /// Serializes this request to a JSON map for the API.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
