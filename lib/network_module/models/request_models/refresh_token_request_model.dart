/// Request body sent to the refresh-token endpoint.
///
/// Wraps the stored refresh token so the server can issue a new access token.
class RefreshTokenRequestModel {
  /// The refresh token previously issued during login.
  String? refreshToken;

  /// Creates a request with the given [refreshToken].
  RefreshTokenRequestModel({this.refreshToken});

  /// Deserializes a refresh-token request from a JSON map.
  RefreshTokenRequestModel.fromJson(Map<String, dynamic> json) {
    refreshToken = json['refreshToken'];
  }

  /// Serializes this request to a JSON map suitable for the request body.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refreshToken'] = refreshToken;
    return data;
  }
}
