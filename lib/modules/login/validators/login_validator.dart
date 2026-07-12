import 'dart:async';

/// Stream validators for login form fields.
///
/// Provides transformers that enforce mobile number and terms acceptance rules.
mixin LoginValidator {
  /// Validates a mobile number stream for non-empty 10-digit input.
  ///
  /// Adds validation errors to the sink when the value is empty or invalid.
  StreamTransformer<String, String> validateMobNum() =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (mobile, sink) {
          if (mobile.isEmpty) {
            sink.addError("Mobile number should not be empty.");
          } else if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
            sink.addError("Enter a valid mobile number.");
          } else {
            sink.add(mobile);
          }
        },
      );

  /// Validates that terms and conditions have been accepted.
  ///
  /// Adds a validation error when [decision] is false.
  StreamTransformer<bool, bool> validateTC() =>
      StreamTransformer<bool, bool>.fromHandlers(
        handleData: (decision, sink) {
          if (decision) {
            sink.add(decision);
          } else {
            sink.addError("Check the Terms & Conditions.");
          }
        },
      );
}


// in case of localization, 
