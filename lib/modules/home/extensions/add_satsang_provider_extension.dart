import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/add_satsang_provider.dart';

/// Provides convenient access to [AddSatsangProvider] from a [BuildContext].
extension AddSatsangProviderExtension on BuildContext {
  /// The [AddSatsangProvider] registered above this context.
  AddSatsangProvider get addSatsangProvider => read<AddSatsangProvider>();
}
