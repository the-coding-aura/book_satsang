import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/modules/home/widgets/bottom_nav/add_satsang_fab.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Custom home bottom navigation with a centered inward circular notch.
///
/// Uses [BottomAppBar] with [CircularNotchedRectangle] so the floating Add
/// Satsang button (center-docked) sits flush inside the curve. Two tabs sit on
/// each side of the notch.
class HomeBottomNavBar extends StatelessWidget {
  /// Creates the notched home bottom navigation bar.
  const HomeBottomNavBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onTap,
    required this.fabSize,
    this.notchMargin = 8,
  });

  /// Ordered tab destinations (exactly four for the current home shell).
  final List<HomeNavDestination> destinations;

  /// Currently selected tab index.
  final int currentIndex;

  /// Invoked with the tapped destination index.
  final ValueChanged<int> onTap;

  /// Diameter of the floating action button that sits in the notch.
  final double fabSize;

  /// Gap between the FAB edge and the notched bar path.
  final double notchMargin;

  @override
  Widget build(BuildContext context) {
    assert(
      destinations.length == 4,
      'HomeBottomNavBar expects 4 destinations (2 left, 2 right of the notch).',
    );

    final double barHeight = context.adaptiveSize(context.hp(8.5));

    return BottomAppBar(
      color: AppColors.primary,
      elevation: 12,
      shadowColor: Colors.black26,
      padding: EdgeInsets.zero,
      height: barHeight,
      notchMargin: notchMargin,
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: [
          Expanded(
            child: HomeNavItem(
              destination: destinations[0],
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: HomeNavItem(
              destination: destinations[1],
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ),
          // Reserved space under the floating action button / notch.
          SizedBox(width: fabSize + (notchMargin * 2)),
          Expanded(
            child: HomeNavItem(
              destination: destinations[2],
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ),
          Expanded(
            child: HomeNavItem(
              destination: destinations[3],
              selected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ),
        ],
      ),
    );
  }
}
