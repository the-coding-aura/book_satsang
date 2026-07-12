import 'package:book_satsang/modules/home/extensions/add_satsang_provider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Multiline text field for entering the temple address.
class TempleAddressFieldWidget extends StatelessWidget {
  const TempleAddressFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(5),
        vertical: context.wp(2.5),
      ),
      child: StreamBuilder<String>(
        stream: context.addSatsangProvider.templeAddressStream(),
        builder: (context, snapshot) {
          return TextField(
            decoration: InputDecoration(
              labelText: 'Temple Address',
              border: const OutlineInputBorder(),
              hintText: 'Enter Temple Address',
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              alignLabelWithHint: true,
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            minLines: 3,
            onChanged: context.addSatsangProvider.changeTempleAddress,
            inputFormatters: [LengthLimitingTextInputFormatter(200)],
          );
        },
      ),
    );
  }
}
