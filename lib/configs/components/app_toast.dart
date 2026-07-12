import 'package:fluttertoast/fluttertoast.dart';

/// Lightweight toast notifications for brief, non-blocking user feedback.
class AppToast {
  AppToast._();

  /// Shows a short toast message at the bottom of the screen.
  static void show(
    String message, {
    Toast length = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
    );
  }

  /// Shows a warning-style toast for the double-back exit prompt.
  static void warning(String message) => show(message);
}
