import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/modules/home/extensions/home_provider_extension.dart';
import 'package:book_satsang/modules/home/providers/home_page_provider.dart';
import 'package:book_satsang/modules/home/providers/profile_screen_provider.dart';
import 'package:book_satsang/modules/home/providers/satsang_screen_provider.dart';
import 'package:book_satsang/modules/home/screens/member_screen.dart';
import 'package:book_satsang/modules/home/screens/profile_screen.dart';
import 'package:book_satsang/modules/home/screens/satsang_screen.dart';
import 'package:book_satsang/modules/home/screens/wall_screen.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../drawer/pages/home_drawer.dart';
import '../../drawer/providers/home_drawer_provider.dart';

/// Main shell after login with bottom navigation and drawer.
///
/// Hosts wall, satsang, members, and profile tabs in a [PageView].
class HomePage extends StatefulWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  /// Creates the state for this widget.
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChangeNotifierProvider(
        create: (BuildContext context) => HomeDrawerProvider(),
        child: HomeDrawer(),
      ),
      appBar: AppBar(title: Text("Home Page"), centerTitle: true),
      body: Selector<HomePageProvider, PageController>(
        selector: (context, p) => p.homePageCon,
        builder: (context, value, child) => PageView(
          onPageChanged: context.homePageProvider.onPageChanged,
          controller: value,
          children: [
            WallScreen(),
            ChangeNotifierProvider<SatsangScreenProvider>(
              create: (context) => SatsangScreenProvider(),
              child: SatsangScreen(),
            ),
            MemberScreen(),
            ChangeNotifierProvider<ProfileScreenProvider>(
              create: (context) => ProfileScreenProvider(),
              child: ProfileScreen(),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Selector<HomePageProvider, (List<BottomNavigationBarItem>, int)>(
            selector: (context, p) => (p.options, p.currentIndex),
            builder: (context, value, child) => BottomNavigationBar(
              backgroundColor: AppColors.primary,
              landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
              items: value.$1,
              currentIndex: value.$2,
              onTap: context.homePageProvider.onChangeMenu,
            ),
          ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        label: Row(
          children: [
            Text(
              "Add Satsang",
              style: TextStyle(color: Colors.white, fontSize: context.wp(4)),
            ),
            Icon(Icons.add, color: Colors.white, size: context.wp(8)),
          ],
        ),
        onPressed: () {},
        backgroundColor: AppColors.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
