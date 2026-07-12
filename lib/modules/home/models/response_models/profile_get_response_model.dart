import '../../../../network_module/response/base_api_response.dart';

/// API response type for the profile details endpoint.
typedef ProfileGetResponseModel = BaseApiResponse<ProfileData>;

/// Parses the profile GET API response from raw JSON.
///
/// The [json] map is the full API payload deserialized from the network.
ProfileGetResponseModel profileGetResfromJson(Map<String, dynamic> json) =>
    ProfileGetResponseModel.fromJson(
      json,
      (d) => ProfileData.fromJson(d as Map<String, dynamic>),
    );

/// Member profile fields returned by the profile details API.
class ProfileData {
  /// Member first name.
  String? firstName;

  /// Member last name.
  String? lastName;

  /// Registered mobile number.
  String? mobileNumber;

  /// Date of birth in API string format.
  String? dateOfBirth;

  /// Associated village display name.
  String? villageName;

  /// Associated taluka display name.
  String? talukaName;

  /// Associated designation display name.
  String? designationName;

  /// Creates a [ProfileData] with optional field values.
  ProfileData({
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.dateOfBirth,
    this.villageName,
    this.talukaName,
    this.designationName,
  });

  /// Creates a [ProfileData] from JSON map keys.
  ProfileData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    dateOfBirth = json['dateOfBirth'];
    villageName = json['villageName'];
    talukaName = json['talukaName'];
    designationName = json['designationName'];
  }
}
