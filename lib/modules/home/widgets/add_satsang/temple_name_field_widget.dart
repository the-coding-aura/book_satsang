import 'package:book_satsang/modules/home/extensions/add_satsang_provider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Text field for entering the temple name.
class TempleNameFieldWidget extends StatelessWidget {
  const TempleNameFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(5),
        vertical: context.wp(2.5),
      ),
      child: StreamBuilder<String>(
        stream: context.addSatsangProvider.templeNameStream(),
        builder: (context, snapshot) {
          return TextField(
            decoration: InputDecoration(
              labelText: 'Temple Name',
              border: const OutlineInputBorder(),
              hintText: 'Enter Temple Name',
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: context.addSatsangProvider.changeTempleName,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
          );
        },
      ),
    );
  }
}
