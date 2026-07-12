import 'package:book_satsang/modules/login/extensions/login_provider_extension.dart';
import 'package:flutter/material.dart';

/// Checkbox bound to [LoginProvider.termAcceptCheck] for terms acceptance.
///
/// Reflects validation state from [LoginProvider.termStream].
class TermsCheckbox extends StatelessWidget {
  /// Creates the terms-and-conditions acceptance checkbox.
  const TermsCheckbox({super.key});

  /// Builds a [Checkbox] synced to [LoginProvider.termStream].
  ///
  /// Updates terms acceptance via [LoginProvider.changeTC].
  @override
  Widget build(BuildContext context) {
    final loginProvider = context.loginProvider;

    return StreamBuilder<bool>(
      stream: loginProvider.termStream(),
      builder: (context, snapshot) {
        return Checkbox(
          value: snapshot.data ?? false,
          onChanged: (value) => loginProvider.changeTC(value ?? false),
        );
      },
    );
  }
}
