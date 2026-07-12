import 'package:book_satsang/modules/login/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Convenience accessors for login-related providers on [BuildContext].
extension LoginProviderExtension on BuildContext {
  /// The [LoginProvider] registered above this context.
  LoginProvider get loginProvider => read<LoginProvider>();
}
