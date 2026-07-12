/// Request body for submitting a new member registration.
class RegisterMemberRequestModel {
  /// Applicant first name.
  String? firstName;

  /// Applicant last name.
  String? lastName;

  /// Verified mobile number from the OTP flow.
  String? mobileNumber;

  /// Date of birth in ISO-8601 string format.
  String? dateOfBirth;

  /// Admin flag; `0` for regular members.
  int? isAdmin;

  /// Selected village master identifier.
  int? villageId;

  /// Selected taluka master identifier.
  int? talukaId;

  /// Selected designation master identifier.
  int? designationId;

  /// Creates a [RegisterMemberRequestModel] with optional field values.
  RegisterMemberRequestModel({
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.dateOfBirth,
    this.isAdmin,
    this.villageId,
    this.talukaId,
    this.designationId,
  });

  /// Serializes this registration request to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['isAdmin'] = isAdmin;
    data['villageId'] = villageId;
    data['talukaId'] = talukaId;
    data['designationId'] = designationId;
    return data;
  }
}
