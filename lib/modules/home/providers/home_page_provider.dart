import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:book_satsang/modules/home/widgets/bottom_nav/add_satsang_fab.dart';
import 'package:flutter/material.dart';

/// Manages bottom navigation and page switching for [HomePage].
///
/// Coordinates [PageController] state with the selected tab index.
class HomePageProvider extends ChangeNotifier {
  /// Controller driving the home tab [PageView].
  PageController homePageCon = PageController();

  /// Bottom navigation destinations for each home tab.
  ///
  /// Layout is two items left of the Add Satsang notch, two on the right:
  /// Posts, Satsang | notch | Members, Profile.
  final List<HomeNavDestination> destinations = const [
    HomeNavDestination(icon: Icons.dynamic_feed_rounded, label: 'Posts'),
    HomeNavDestination(icon: Icons.temple_hindu_rounded, label: 'Satsang'),
    HomeNavDestination(icon: Icons.people_alt_rounded, label: 'Members'),
    HomeNavDestination(icon: Icons.person_rounded, label: 'Profile'),
  ];

  /// Index of the currently selected bottom navigation tab.
  int currentIndex = 0;

  /// Updates the selected tab and jumps the [PageView] to [value].
  void onChangeMenu(int value) {
    currentIndex = value;
    homePageCon.jumpToPage(value);
    notifyListeners();
  }

  /// Syncs [currentIndex] when the user swipes between pages.
  void onPageChanged(int value) {
    currentIndex = value;
    notifyListeners();
  }

  /// Opens the add satsang screen, then switches to the satsang tab.
  Future<void> navigateToAddSatsang(BuildContext context) async {
    await Navigator.pushNamed(context, RoutesName.addSatsang);
    if (!context.mounted) return;

    onChangeMenu(1);
  }
}
