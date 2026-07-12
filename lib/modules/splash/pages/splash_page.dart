import 'package:book_satsang/modules/splash/extensions/splash_provider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Initial screen shown while the app checks for an existing session.
///
/// Displays the app logo and delegates navigation to [SplashProvider].
class SplashScreen extends StatefulWidget {
  /// Creates the splash screen.
  const SplashScreen({super.key});

  /// Creates the mutable state for this splash screen.
  ///
  /// Triggers session check on initialization.
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    context.splashProvider.checkSessionExists(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/logo.png',
          width: context.wp(40),
          height: context.wp(20),
        ),
      ),
    );
  }
}
