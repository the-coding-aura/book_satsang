import 'package:book_satsang/modules/registeration/extensions/registeration_provider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text field for entering the member's first name during registration.
///
/// Validates input in real time via [RegisterationProvider].
class FirstNameWidget extends StatelessWidget {
  /// Creates a [FirstNameWidget].
  const FirstNameWidget({super.key});

  /// Builds the first name text field with live validation feedback.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: context.wp(5),
        left: context.wp(5),
        top: context.wp(5),
        bottom: context.wp(2.5),
      ),
      child: StreamBuilder<String>(
        stream: context.registerationProvider.firstNameStream(),
        builder: (context, snapshot) {
          return TextField(
            decoration: InputDecoration(
              labelText: "First Name",
              border: OutlineInputBorder(),
              hintText: "Enter First Name",
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: context.registerationProvider.changeFirstName,
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
              FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
            ],
          );
        },
      ),
    );
  }
}
