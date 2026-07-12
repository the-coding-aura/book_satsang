import 'dart:async';

import 'package:book_satsang/modules/registeration/models/response_models/taluka_list_response_model.dart';
import 'package:book_satsang/modules/registeration/models/response_models/village_list_response_model.dart';

/// Stream validation transformers for the add satsang form.
mixin AddSatsangValidator {
  static final RegExp _dateRegex = RegExp(
    r'^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$',
  );

  /// Validates satsang name length and non-empty input.
  StreamTransformer<String, String> validateSatsangName() =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (name, sink) {
          if (name.isEmpty) {
            sink.addError('Satsang name should not be empty.');
          } else if (name.length < 3) {
            sink.addError('Enter a valid satsang name.');
          } else {
            sink.add(name);
          }
        },
      );

  /// Validates temple name length and non-empty input.
  StreamTransformer<String, String> validateTempleName() =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (name, sink) {
          if (name.isEmpty) {
            sink.addError('Temple name should not be empty.');
          } else if (name.length < 3) {
            sink.addError('Enter a valid temple name.');
          } else {
            sink.add(name);
          }
        },
      );

  /// Validates that temple address is not empty.
  StreamTransformer<String, String> validateTempleAddress() =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (address, sink) {
          if (address.trim().isEmpty) {
            sink.addError('Temple address should not be empty.');
          } else if (address.trim().length < 3) {
            sink.addError('Enter a valid temple address.');
          } else {
            sink.add(address);
          }
        },
      );

  /// Validates that a taluka has been selected.
  StreamTransformer<TalukaData?, TalukaData?> validateTaluka() =>
      StreamTransformer<TalukaData?, TalukaData?>.fromHandlers(
        handleData: (taluka, sink) {
          if (taluka == null) {
            sink.addError('Select taluka.');
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
            sink.addError('Select village.');
          } else {
            sink.add(village);
          }
        },
      );

  /// Validates event date format as `dd/MM/yyyy`.
  StreamTransformer<String, String> validateEventDate({
    required String emptyMessage,
  }) =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (date, sink) {
          if (date.isEmpty) {
            sink.addError(emptyMessage);
          } else if (!_dateRegex.hasMatch(date)) {
            sink.addError('Enter date in dd/MM/yyyy format');
          } else {
            sink.add(date);
          }
        },
      );

  /// Ensures [toDate] is on or after [fromDate].
  ///
  /// Throws when [fromDate] is empty or [toDate] precedes [fromDate].
  String validateToDateAgainstFromDate({
    required String toDate,
    required String fromDate,
    required DateTime Function(String value) parseDate,
  }) {
    if (fromDate.isEmpty) {
      throw 'Select from date first.';
    }

    final from = parseDate(fromDate);
    final to = parseDate(toDate);
    if (to.isBefore(from)) {
      throw 'To date cannot be before from date.';
    }
    return toDate;
  }
}
