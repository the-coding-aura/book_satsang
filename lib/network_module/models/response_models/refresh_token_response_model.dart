import '../../response/base_api_response.dart';

/// Parses a raw JSON map into a [RefreshTokenResponseModel].
typedef RefreshTokenResponseModel = BaseApiResponse<RefreshTokenData>;

/// Deserializes a refresh-token API response from a JSON map.
///
/// Uses [RefreshTokenData.fromJson] to parse the nested `data` payload.
RefreshTokenResponseModel refreshTokenResponseFromJson(
  Map<String, dynamic> json,
) => RefreshTokenResponseModel.fromJson(
  json,
  (d) => RefreshTokenData.fromJson(d as Map<String, dynamic>),
);

/// Token pair returned by a successful refresh-token call.
///
/// Contains the new access and refresh tokens to persist for future requests.
class RefreshTokenData {
  /// The newly issued bearer access token.
  String? accessToken;

  /// The newly issued refresh token, replacing the previous one.
  String? refreshToken;

  /// Creates a token pair with optional [accessToken] and [refreshToken].
  RefreshTokenData({this.accessToken, this.refreshToken});

  /// Deserializes token fields from a JSON map.
  RefreshTokenData.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  /// Serializes this token pair to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}
