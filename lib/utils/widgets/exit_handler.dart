import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exit_handler_provider.dart';

/// Intercepts back navigation on root screens and requires a double back to exit.
///
/// Creates its own [ExitHandlerProvider] scope. Wrap screens opened via
/// `pushNamedAndRemoveUntil` with this widget.
class ExitHandler extends StatelessWidget {
  /// Creates an [ExitHandler].
  const ExitHandler({
    super.key,
    required this.child,
    this.warningMessage = 'Press back again to exit',
  });

  /// Screen content protected by the double-back exit flow.
  final Widget child;

  /// Warning shown on the first back press or gesture.
  final String warningMessage;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExitHandlerProvider>(
      create: (_) => ExitHandlerProvider(),
      child: _ExitHandlerScope(
        warningMessage: warningMessage,
        child: child,
      ),
    );
  }
}

class _ExitHandlerScope extends StatelessWidget {
  const _ExitHandlerScope({
    required this.child,
    required this.warningMessage,
  });

  final Widget child;
  final String warningMessage;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<ExitHandlerProvider>().onBackPressed(
          context,
          message: warningMessage,
        );
      },
      child: child,
    );
  }
}
