import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/home_drawer_provider.dart';

/// Provides convenient access to [HomeDrawerProvider] from a [BuildContext].
extension HomeDrawerProviderExtension on BuildContext {
  /// The [HomeDrawerProvider] registered above this context.
  HomeDrawerProvider get homeDrawerProvider => read<HomeDrawerProvider>();
}
