import 'package:book_satsang/modules/home/extensions/add_satsang_provider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text field for entering the satsang name.
class SatsangNameFieldWidget extends StatelessWidget {
  const SatsangNameFieldWidget({super.key});

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
        stream: context.addSatsangProvider.satsangNameStream(),
        builder: (context, snapshot) {
          return TextField(
            decoration: InputDecoration(
              labelText: 'Satsang Name',
              border: const OutlineInputBorder(),
              hintText: 'Enter Satsang Name',
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: context.addSatsangProvider.changeSatsangName,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
          );
        },
      ),
    );
  }
}
