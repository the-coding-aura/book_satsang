import 'package:book_satsang/modules/home/extensions/profile_screen_rpovider_extension.dart';
import 'package:book_satsang/modules/registeration/formatters/dob_input_formatter.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Date-of-birth input field for the profile screen.
///
/// Supports manual entry and date picker selection via the provider.
class DOBFieldWidget extends StatelessWidget {
  /// Creates a [DOBFieldWidget].
  const DOBFieldWidget({super.key});

  /// Builds the DOB text field with calendar picker action.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(5),
        vertical: context.wp(2.5),
      ),
      child: StreamBuilder<String>(
        stream: context.profileScreenProvider.dobStream(),
        builder: (context, snapshot) {
          return TextField(
            controller: context.profileScreenProvider.dobFieldController,
            decoration: InputDecoration(
              labelText: "DOB",
              suffixIcon: IconButton(
                onPressed: () async =>
                    await context.profileScreenProvider.selectDate(context),
                icon: Icon(Icons.calendar_month_outlined),
              ),
              border: OutlineInputBorder(),
              hintText: "Enter DOB (dd/MM/yyyy)",
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: context.profileScreenProvider.changeDob,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              DateInputFormatter(),
            ],
          );
        },
      ),
    );
  }
}
