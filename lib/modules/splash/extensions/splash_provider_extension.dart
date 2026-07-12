import 'package:book_satsang/modules/splash/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Convenience accessors for splash-related providers on [BuildContext].
extension SplashProviderExtension on BuildContext {
  /// The [SplashProvider] registered above this context.
  SplashProvider get splashProvider => read<SplashProvider>();
}
