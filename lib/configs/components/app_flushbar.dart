import 'dart:async';

import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Visual category for an [AppFlushbar] notification.
///
/// Each value maps to a distinct background color and icon.
enum FlushbarType { success, warning, error }

/// Animated top-slide notification bar for transient user feedback.
///
/// Displays success, warning, and error messages above the current screen
/// content and auto-dismisses after a configurable duration.
class AppFlushbar {
  AppFlushbar._();

  static String? _lastMessage;
  static DateTime? _lastShownAt;
  static const Duration _dedupeWindow = Duration(seconds: 3);

  /// Shows a success-styled flushbar with the given [message].
  ///
  /// The bar remains visible for [duration] unless the user dismisses it early.
  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      type: FlushbarType.success,
      duration: duration,
    );
  }

  /// Shows a warning-styled flushbar with the given [message].
  ///
  /// The bar remains visible for [duration] unless the user dismisses it early.
  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      type: FlushbarType.warning,
      duration: duration,
    );
  }

  /// Shows an error-styled flushbar with the given [message].
  ///
  /// The bar remains visible for [duration] unless the user dismisses it early.
  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      type: FlushbarType.error,
      duration: duration,
    );
  }

  static bool _shouldSkipDuplicate(String message) {
    final DateTime now = DateTime.now();
    if (_lastMessage == message &&
        _lastShownAt != null &&
        now.difference(_lastShownAt!) < _dedupeWindow) {
      return true;
    }
    return false;
  }

  static void _markShown(String message) {
    _lastMessage = message;
    _lastShownAt = DateTime.now();
  }

  static void _show(
    BuildContext context, {
    required String message,
    required FlushbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (_shouldSkipDuplicate(message)) return;

    // Prefer the root overlay so calls from AppNavigator / network layer work.
    final OverlayState? overlayState =
        Overlay.maybeOf(context, rootOverlay: true) ?? Overlay.maybeOf(context);
    if (overlayState == null) return;

    late OverlayEntry overlayEntry;
    bool isRemoved = false;

    void removeEntry() {
      if (isRemoved) return;
      isRemoved = true;
      if (overlayEntry.mounted) overlayEntry.remove();
    }

    overlayEntry = OverlayEntry(
      builder: (_) => _AnimatedFlushbar(
        message: message,
        type: type,
        duration: duration,
        onFullyDismissed: removeEntry,
      ),
    );

    overlayState.insert(overlayEntry);
    _markShown(message);
  }
}

class _AnimatedFlushbar extends StatefulWidget {
  const _AnimatedFlushbar({
    required this.message,
    required this.type,
    required this.duration,
    required this.onFullyDismissed,
  });

  final String message;
  final FlushbarType type;
  final Duration duration;
  final VoidCallback onFullyDismissed;

  @override
  State<_AnimatedFlushbar> createState() => _AnimatedFlushbarState();
}

class _AnimatedFlushbarState extends State<_AnimatedFlushbar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  Timer? _autoDismissTimer;
  bool _isDismissing = false;

  Color get _backgroundColor => switch (widget.type) {
        FlushbarType.success => AppColors.flushbarSuccess,
        FlushbarType.warning => AppColors.flushbarWarning,
        FlushbarType.error => AppColors.flushbarError,
      };

  IconData get _icon => switch (widget.type) {
        FlushbarType.success => Icons.check_circle_outline,
        FlushbarType.warning => Icons.warning_amber_rounded,
        FlushbarType.error => Icons.error_outline,
      };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _controller.forward();
    _autoDismissTimer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;
    _autoDismissTimer?.cancel();
    if (mounted) await _controller.reverse();
    widget.onFullyDismissed();
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SlideTransition(
            position: _slideAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(_icon, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _dismiss,
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: 'Dismiss',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
