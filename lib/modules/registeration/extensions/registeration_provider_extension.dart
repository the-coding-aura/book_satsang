import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registeration_provider.dart';

/// Provides convenient access to [RegisterationProvider] from a [BuildContext].
extension RegisterationProviderExtension on BuildContext {
  /// The [RegisterationProvider] registered above this context.
  RegisterationProvider get registerationProvider =>
      read<RegisterationProvider>();
}
