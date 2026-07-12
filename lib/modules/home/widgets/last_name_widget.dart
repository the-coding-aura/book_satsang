import 'package:book_satsang/modules/home/extensions/profile_screen_rpovider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text field for entering the member's last name on the profile screen.
///
/// Validates input in real time via [ProfileScreenProvider].
class LastNameWidget extends StatelessWidget {
  /// Creates a [LastNameWidget].
  const LastNameWidget({super.key});

  /// Builds the last name text field with live validation feedback.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(5),
        vertical: context.wp(2.5),
      ),
      child: StreamBuilder<String>(
        stream: context.profileScreenProvider.lastNameStream(),
        builder: (context, snapshot) {
          return TextField(
            controller: context.profileScreenProvider.lastNameController,
            decoration: InputDecoration(
              labelText: "Last Name",
              border: OutlineInputBorder(),
              hintText: "Enter Last Name",
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: context.profileScreenProvider.changeLastName,
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
