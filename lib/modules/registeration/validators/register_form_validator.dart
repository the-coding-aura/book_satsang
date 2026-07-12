import 'dart:async';
import 'package:book_satsang/modules/registeration/models/response_models/designation_list_response_model.dart';
import 'package:book_satsang/modules/registeration/models/response_models/taluka_list_response_model.dart';
import 'package:book_satsang/modules/registeration/models/response_models/village_list_response_model.dart';

/// Stream validation transformers for registration and profile forms.
///
/// Provides reusable validators for text fields and dropdown selections.
mixin RegisterFormValidator {
  /// Validates first name length and non-empty input.
  StreamTransformer<String, String> validateFirstName() =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (firstName, sink) {
          if (firstName.isEmpty) {
            sink.addError("First name should not be empty.");
          } else if (firstName.length < 3) {
            sink.addError("Enter a valid name.");
          } else {
            sink.add(firstName);
          }
        },
      );

  /// Validates date-of-birth format as `dd/MM/yyyy`.
  StreamTransformer<String, String> validateDOB() =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (dob, sink) {
          final regex = RegExp(
            r'^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$',
          );

          if (dob.isEmpty) {
            sink.addError("Date of birth should not be empty.");
          } else if (!regex.hasMatch(dob)) {
            sink.addError('Enter date in dd/MM/yyyy format');
          } else {
            sink.add(dob);
          }
        },
      );

  /// Validates last name length and non-empty input.
  StreamTransformer<String, String> validateLastName() =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (firstName, sink) {
          if (firstName.isEmpty) {
            sink.addError("Last name should not be empty.");
          } else if (firstName.length < 3) {
            sink.addError("Enter a valid name.");
          } else {
            sink.add(firstName);
          }
        },
      );

  /// Validates that a taluka has been selected.
  StreamTransformer<TalukaData?, TalukaData?> validateTaluka() =>
      StreamTransformer<TalukaData?, TalukaData?>.fromHandlers(
        handleData: (taluka, sink) {
          if (taluka == null) {
            sink.addError("Select taluka.");
          } else {
            sink.add(taluka);
          }
        },
      );

  /// Validates that a village has been selected.
  StreamTransformer<VillageData?, VillageData?> validateVillage() =>
      StreamTransformer<VillageData?, VillageData?>.fromHandlers(
        handleData: (village, sink) {
          if (village == null) {
            sink.addError("Select village.");
          } else {
            sink.add(village);
          }
        },
      );

  /// Validates that a designation has been selected.
  StreamTransformer<DesignationData?, DesignationData?> validateDesignation() =>
      StreamTransformer<DesignationData?, DesignationData?>.fromHandlers(
        handleData: (designation, sink) {
          if (designation == null) {
            sink.addError("Select designation.");
          } else {
            sink.add(designation);
          }
        },
      );

  /// Validates that a profile image file has been uploaded.
  StreamTransformer<String?, String?> validateFile() =>
      StreamTransformer<String?, String?>.fromHandlers(
        handleData: (fileUrl, sink) {
          if (fileUrl == null || fileUrl.isEmpty) {
            sink.addError("Select File.");
          } else {
            sink.add(fileUrl);
          }
        },
      );
}
