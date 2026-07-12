import 'dart:io';

import 'package:book_satsang/app.dart';
import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/environments/dev.dart';
import 'package:book_satsang/environments/mock.dart';
import 'package:book_satsang/environments/prod.dart';
import 'package:book_satsang/environments/uat.dart';
import 'package:book_satsang/network_module/network/app_config.dart';
import 'package:book_satsang/network_module/network/my_http_overrides.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Application entry point.
///
/// Initializes Flutter bindings, resolves the build flavor from native code,
/// configures the matching environment, registers dependencies, and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  String flavor = 'MOCK';
  try {
    flavor =
        (await const MethodChannel('flavor').invokeMethod<String>('getFlavor'))
            ?? 'MOCK';
  } catch (_) {
    if (kDebugMode) {
      debugPrint('Failed to load native flavor. Falling back to MOCK.');
    }
  }

  switch (flavor.toUpperCase()) {
    case 'PROD':
      startPROD();
      break;
    case 'UAT':
      startUAT();
      break;
    case 'DEV':
      startDEV();
      break;
    case 'MOCK':
    default:
      startMOCK();
      break;
  }

  if (kDebugMode) {
    debugPrint(
      'APP STARTED | FLAVOR: ${AppConfig.flavorName} | BASE URL: ${AppConfig.apiBaseUrl}',
    );
  }

  setupLocator();
  runApp(const BookSatsangApp());
}
