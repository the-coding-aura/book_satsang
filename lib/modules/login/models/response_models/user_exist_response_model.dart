import 'package:book_satsang/network_module/response/base_api_response.dart';

/// API envelope for user-existence responses with a [UserExistModel] payload.
typedef UserExistResponseModel = BaseApiResponse<UserExistModel>;

/// Parses the user-existence API response into a [UserExistResponseModel].
///
/// The [d] callback receives `json['data']` as a map for [UserExistModel].
UserExistResponseModel userExistFromJson(Map<String, dynamic> json) =>
    UserExistResponseModel.fromJson(
      json,
      (d) => UserExistModel.fromJson(d as Map<String, dynamic>),
    );

/// User-existence status returned in the `data` field of the API response.
class UserExistModel {
  /// Registration status (`1` typically means the user exists).
  int? status;

  /// Creates a user-existence model with the given [status].
  UserExistModel({this.status});

  /// Creates a model from the `data` object in a user-existence response.
  UserExistModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  /// Serializes this model to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}

