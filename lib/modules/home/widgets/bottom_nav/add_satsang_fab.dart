import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/modules/home/providers/home_page_provider.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Centered circular floating action button for opening Add Satsang.
///
/// Sized to sit inside [HomeBottomNavBar]'s inward circular notch.
class AddSatsangFab extends StatefulWidget {
  /// Creates the Add Satsang floating action button.
  const AddSatsangFab({
    super.key,
    required this.size,
    required this.onPressed,
  });

  /// Diameter of the circular button.
  final double size;

  /// Called when the button is pressed.
  final VoidCallback onPressed;

  @override
  State<AddSatsangFab> createState() => _AddSatsangFabState();
}

class _AddSatsangFabState extends State<AddSatsangFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 160),
      lowerBound: 0.92,
      upperBound: 1,
      value: 1,
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    await _controller.reverse();
    await _controller.forward();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.adaptiveSize(widget.size * 0.45);

    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: AppColors.primary,
        elevation: 8,
        shadowColor: AppColors.primary.withValues(alpha: 0.45),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _onTap,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

/// Descriptive model for a home bottom-navigation destination.
class HomeNavDestination {
  /// Creates a tab destination with [icon] and [label].
  const HomeNavDestination({required this.icon, required this.label});

  /// Icon shown for the tab.
  final IconData icon;

  /// Short label under the icon.
  final String label;
}

/// Builds a single bottom-nav destination with selected-state styling.
class HomeNavItem extends StatelessWidget {
  /// Creates a tappable nav item for [destination].
  const HomeNavItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  /// Tab metadata.
  final HomeNavDestination destination;

  /// Whether this item matches [HomePageProvider.currentIndex].
  final bool selected;

  /// Called when the item is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color =
        selected ? Colors.white : Colors.white.withValues(alpha: 0.72);
    final FontWeight weight = selected ? FontWeight.w700 : FontWeight.w500;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(vertical: context.hp(0.6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: selected ? 1.08 : 1,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: Icon(
                destination.icon,
                color: color,
                size: context.sp(5.2),
              ),
            ),
            SizedBox(height: context.hp(0.4)),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: context.sp(2.8),
                fontWeight: weight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
