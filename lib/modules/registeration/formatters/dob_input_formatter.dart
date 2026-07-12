import 'package:flutter/services.dart';

/// Text input formatter that inserts slashes into `dd/MM/yyyy` dates.
///
/// Strips non-digit characters and limits input to eight digits.
class DateInputFormatter extends TextInputFormatter {
  /// Formats [newValue] as a date string while the user types.
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');

    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
