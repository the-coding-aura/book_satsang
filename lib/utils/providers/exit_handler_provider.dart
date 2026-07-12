import 'dart:io' show Platform, exit;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/components/app_toast.dart';

/// Tracks double-back-to-exit state for root screens wrapped by [ExitHandler].
class ExitHandlerProvider extends ChangeNotifier {
  /// Time window in which a second back press exits the app.
  static const Duration exitWindow = Duration(seconds: 2);

  DateTime? _lastBackPressAt;

  /// Handles a system back action.
  ///
  /// Shows a warning on the first press within [exitWindow]. Exits the app when
  /// back is pressed again before the window expires.
  void onBackPressed(
    BuildContext context, {
    String message = 'Press back again to exit',
  }) {
    final now = DateTime.now();

    if (_lastBackPressAt != null &&
        now.difference(_lastBackPressAt!) <= exitWindow) {
      _lastBackPressAt = null;
      _exitApplication();
      return;
    }

    _lastBackPressAt = now;
    AppToast.warning(message);
  }

  void _exitApplication() {
    if (kIsWeb) {
      SystemNavigator.pop();
      return;
    }

    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }
}
