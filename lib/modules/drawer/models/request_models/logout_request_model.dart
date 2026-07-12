/// Request body for invalidating a user session on the server.
class LogoutRequestModel {
  /// Refresh token to revoke during logout.
  String? refreshToken;

  /// Creates a [LogoutRequestModel] with an optional [refreshToken].
  LogoutRequestModel({this.refreshToken});

  /// Creates a [LogoutRequestModel] from JSON map keys.
  LogoutRequestModel.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refreshToken'];
  }

  /// Serializes this logout request to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refreshToken'] = refreshToken;
    return data;
  }
}
