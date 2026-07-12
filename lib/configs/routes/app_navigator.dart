import 'package:flutter/material.dart';

/// Global navigation helper for imperative routing outside the widget tree.
///
/// Exposes a shared [NavigatorState] so services such as the network layer can
/// show dialogs or navigate without a widget [BuildContext].
class AppNavigator {
  AppNavigator._();

  /// Global key attached to the root [MaterialApp] navigator.
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  /// The [BuildContext] of the root navigator, if mounted.
  static BuildContext? get context => key.currentContext;

  /// The root [NavigatorState], if the navigator is mounted.
  static NavigatorState? get state => key.currentState;
}
