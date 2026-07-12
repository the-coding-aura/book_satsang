import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/satsang_screen_provider.dart';

/// Provides convenient access to [SatsangScreenProvider] from a [BuildContext].
extension SatsangScreenProviderExtension on BuildContext {
  /// The [SatsangScreenProvider] registered above this context.
  SatsangScreenProvider get satsangScreenProvider =>
      read<SatsangScreenProvider>();
}
