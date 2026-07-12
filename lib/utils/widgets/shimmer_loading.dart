import 'package:flutter/material.dart';

/// Direction in which the shimmer highlight sweeps across the child.
enum ShimmerDirection {
  /// Highlight travels from left to right.
  leftToRight,

  /// Highlight travels from right to left.
  rightToLeft,

  /// Highlight travels from top to bottom.
  topToBottom,

  /// Highlight travels from bottom to top.
  bottomToTop,
}

/// Reusable shimmer loading effect built from scratch (no third-party packages).
///
/// Wrap any placeholder layout — typically a set of opaque [ShimmerBox] shapes —
/// with this widget to animate a moving highlight over it while content loads.
/// The effect is produced with a [ShaderMask] whose gradient is continuously
/// translated by an [AnimationController], so the [child]'s opaque pixels are
/// painted with the animated gradient.
class ShimmerLoading extends StatefulWidget {
  /// Creates a [ShimmerLoading] that animates over [child].
  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1400),
    this.direction = ShimmerDirection.leftToRight,
    this.enabled = true,
  });

  /// The placeholder layout the shimmer is painted over.
  final Widget child;

  /// The dim base color of the placeholder.
  final Color baseColor;

  /// The brighter color of the moving highlight band.
  final Color highlightColor;

  /// Duration of a single sweep of the highlight.
  final Duration duration;

  /// Direction the highlight band travels.
  final ShimmerDirection direction;

  /// When `false`, the [child] is shown without any animation.
  final bool enabled;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _updateAnimationState();
  }

  @override
  void didUpdateWidget(covariant ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.duration != widget.duration) {
      _updateAnimationState();
    }
  }

  void _updateAnimationState() {
    if (widget.enabled) {
      _controller.repeat(min: -0.5, max: 1.5, period: widget.duration);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isHorizontal =>
      widget.direction == ShimmerDirection.leftToRight ||
      widget.direction == ShimmerDirection.rightToLeft;

  Alignment get _begin {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return Alignment.centerLeft;
      case ShimmerDirection.rightToLeft:
        return Alignment.centerRight;
      case ShimmerDirection.topToBottom:
        return Alignment.topCenter;
      case ShimmerDirection.bottomToTop:
        return Alignment.bottomCenter;
    }
  }

  Alignment get _end {
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        return Alignment.centerRight;
      case ShimmerDirection.rightToLeft:
        return Alignment.centerLeft;
      case ShimmerDirection.topToBottom:
        return Alignment.bottomCenter;
      case ShimmerDirection.bottomToTop:
        return Alignment.topCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: _begin,
              end: _end,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
                horizontal: _isHorizontal,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Translates a gradient along one axis based on [slidePercent].
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
    required this.horizontal,
  });

  /// Normalized offset of the highlight band relative to the bounds.
  final double slidePercent;

  /// Whether the gradient slides horizontally (otherwise vertically).
  final bool horizontal;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return horizontal
        ? Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0)
        : Matrix4.translationValues(0.0, bounds.height * slidePercent, 0.0);
  }
}

/// An opaque placeholder shape intended to be wrapped by [ShimmerLoading].
///
/// Its solid fill provides the alpha mask that the shimmer gradient paints
/// over, so it also renders as a plain grey block when used on its own.
class ShimmerBox extends StatelessWidget {
  /// Creates a rectangular (or circular) shimmer placeholder box.
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius = 8,
    this.color = const Color(0xFFE0E0E0),
  });

  /// Fixed width of the box; expands to fit when `null`.
  final double? width;

  /// Fixed height of the box.
  final double? height;

  /// Whether the box is a rectangle or a circle.
  final BoxShape shape;

  /// Corner radius applied when [shape] is [BoxShape.rectangle].
  final double borderRadius;

  /// The opaque fill color that acts as the shimmer mask.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
      ),
    );
  }
}
