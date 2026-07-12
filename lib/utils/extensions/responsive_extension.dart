import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Responsive layout helpers based on the current screen size.
///
/// Provides device-class detection and percentage-based sizing on
/// [BuildContext].
extension ResponsiveExtension on BuildContext {
  /// The logical size of the screen associated with this context.
  Size get screenSize => MediaQuery.sizeOf(this);

  double get _shortestSide => math.min(screenSize.width, screenSize.height);
  double get _aspectRatio => screenSize.width / screenSize.height;

  /// Whether the shortest screen side indicates a phone layout.
  bool get isPhone => _shortestSide < 600;

  /// Whether the shortest screen side indicates a tablet layout.
  bool get isTablet => _shortestSide >= 600 && _shortestSide < 900;

  /// Whether the shortest screen side indicates a desktop layout.
  bool get isDesktop => _shortestSide >= 900;

  /// Whether the screen aspect ratio indicates landscape orientation.
  bool get isLandscape => _aspectRatio > 1.2;

  /// Whether the screen aspect ratio is unusually narrow.
  bool get isNarrow => _aspectRatio < 0.6;

  /// Returns a width equal to [percent] of the screen width.
  ///
  /// For example, `context.wp(10)` returns 10% of the screen width.
  double wp(double percent) => screenSize.width * (percent / 100);

  /// Returns a height equal to [percent] of the screen height.
  ///
  /// For example, `context.hp(5)` returns 5% of the screen height.
  double hp(double percent) => screenSize.height * (percent / 100);

  /// Returns a responsive font or widget size scaled from [percent] of width.
  ///
  /// Adjusts for device class and orientation, then clamps the result to
  /// `[12, 34]`.
  double sp(double percent) {
    double size = wp(percent);
    if (isTablet) size *= 1.15;
    if (isDesktop) size *= 1.3;
    if (isLandscape && isPhone) size *= 0.85;
    if (isNarrow) size *= 1.1;
    return size.clamp(12.0, 34.0);
  }

  /// Scales [phoneSize] up for tablet and desktop device classes.
  ///
  /// Returns [phoneSize] unchanged when [isPhone] is true.
  double adaptiveSize(double phoneSize) {
    if (isTablet) return phoneSize * 1.2;
    if (isDesktop) return phoneSize * 1.4;
    return phoneSize;
  }
}
