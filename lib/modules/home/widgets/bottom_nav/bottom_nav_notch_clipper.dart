import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Clips a rectangular bar with a smooth inward circular notch at the center.
///
/// Used when a custom-painted bottom navigation surface needs the same geometry
/// as [CircularNotchedRectangle] without relying on [BottomAppBar].
class BottomNavNotchClipper extends CustomClipper<Path> {
  /// Creates a notch clipper sized for [notchRadius] plus [notchMargin].
  BottomNavNotchClipper({
    required this.notchRadius,
    required this.notchMargin,
  });

  /// Radius of the floating button the notch should clear.
  final double notchRadius;

  /// Extra gap between the button edge and the bar path.
  final double notchMargin;

  @override
  Path getClip(Size size) {
    final double centerX = size.width / 2;
    final double radius = notchRadius + notchMargin;
    final double lead = math.min(notchMargin * 1.5, radius);

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(centerX - radius - lead, 0)
      ..quadraticBezierTo(
        centerX - radius,
        0,
        centerX - radius,
        lead,
      )
      ..arcToPoint(
        Offset(centerX + radius, lead),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..quadraticBezierTo(
        centerX + radius,
        0,
        centerX + radius + lead,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant BottomNavNotchClipper oldClipper) {
    return oldClipper.notchRadius != notchRadius ||
        oldClipper.notchMargin != notchMargin;
  }
}
