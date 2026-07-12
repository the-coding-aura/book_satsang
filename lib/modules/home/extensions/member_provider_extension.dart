import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/member_screen_provider.dart';

/// Provides convenient access to [MemberScreenProvider] from a [BuildContext].
extension MemberScreenProviderExtension on BuildContext {
  /// The [MemberScreenProvider] registered above this context.
  MemberScreenProvider get memberScreenProvider => read<MemberScreenProvider>();
}
