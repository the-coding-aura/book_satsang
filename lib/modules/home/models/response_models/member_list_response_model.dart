import '../../../../network_module/response/base_api_response.dart';

/// API response type for the all members endpoint.
typedef MemberListResponseModel = BaseApiResponse<List<MemberData>>;

/// Parses the member list API response from raw JSON.
MemberListResponseModel memberListResponseFromJson(Map<String, dynamic> json) {
  return MemberListResponseModel.fromJson(
    json,
    (data) => (data as List<dynamic>)
        .map((e) => MemberData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// A single member entry returned by the members list API.
class MemberData {
  /// Member first name.
  final String? firstName;

  /// Member last name.
  final String? lastName;

  /// Member mobile number.
  final String? mobileNumber;

  /// Date of birth in API string format.
  final String? dateOfBirth;

  /// Display name of the village.
  final String? villageName;

  /// Display name of the taluka.
  final String? talukaName;

  /// Display name of the designation.
  final String? designationName;

  /// Creates a [MemberData] with optional field values.
  const MemberData({
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.dateOfBirth,
    this.villageName,
    this.talukaName,
    this.designationName,
  });

  /// Creates a [MemberData] from JSON map keys.
  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      villageName: json['villageName'] as String?,
      talukaName: json['talukaName'] as String?,
      designationName: json['designationName'] as String?,
    );
  }

  /// Converts this member entry to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'dateOfBirth': dateOfBirth,
      'villageName': villageName,
      'talukaName': talukaName,
      'designationName': designationName,
    };
  }
}
