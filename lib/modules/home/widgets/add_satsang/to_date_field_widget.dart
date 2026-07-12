import 'package:book_satsang/modules/home/extensions/add_satsang_provider_extension.dart';
import 'package:book_satsang/modules/registeration/formatters/dob_input_formatter.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Date input field for the satsang end date.
class ToDateFieldWidget extends StatelessWidget {
  const ToDateFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(5),
        vertical: context.wp(2.5),
      ),
      child: StreamBuilder<String>(
        stream: context.addSatsangProvider.toDateStream(),
        builder: (context, snapshot) {
          return TextField(
            controller: context.addSatsangProvider.toDateController,
            decoration: InputDecoration(
              labelText: 'To Date',
              suffixIcon: IconButton(
                onPressed: () async =>
                    await context.addSatsangProvider.selectToDate(context),
                icon: const Icon(Icons.calendar_month_outlined),
              ),
              border: const OutlineInputBorder(),
              hintText: 'Enter To Date (dd/MM/yyyy)',
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            onChanged: context.addSatsangProvider.changeToDate,
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
