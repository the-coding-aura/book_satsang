import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:flutter/material.dart';

/// Manages bottom navigation and page switching for [HomePage].
///
/// Coordinates [PageController] state with the selected tab index.
class HomePageProvider extends ChangeNotifier {
  /// Controller driving the home tab [PageView].
  PageController homePageCon = PageController();

  /// Bottom navigation bar items for each home tab.
  final List<BottomNavigationBarItem> options = [
    BottomNavigationBarItem(icon: Icon(Icons.event), label: "Posts"),
    BottomNavigationBarItem(icon: Icon(Icons.event), label: "Satsang"),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: "Members"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  /// Index of the currently selected bottom navigation tab.
  int currentIndex = 0;

  /// Updates the selected tab and jumps the [PageView] to [value].
  onChangeMenu(int value) {
    currentIndex = value;
    homePageCon.jumpToPage(
      value,
      // duration: Duration(milliseconds: 300),
      // curve: Curves.bounceIn,
    );
    notifyListeners();
  }

  /// Syncs [currentIndex] when the user swipes between pages.
  onPageChanged(int value) {
    currentIndex = value;
    notifyListeners();
  }

  /// Opens the add satsang screen, then switches to the satsang tab and refreshes the list.
  Future<void> navigateToAddSatsang(BuildContext context) async {
    await Navigator.pushNamed(context, RoutesName.addSatsang);
    if (!context.mounted) return;

    onChangeMenu(1);
  }
}
