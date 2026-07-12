import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_screen_provider.dart';

/// Provides convenient access to [ProfileScreenProvider] from a [BuildContext].
extension ProfileScreenProviderExtension on BuildContext {
  /// The [ProfileScreenProvider] registered above this context.
  ProfileScreenProvider get profileScreenProvider =>
      read<ProfileScreenProvider>();
}
