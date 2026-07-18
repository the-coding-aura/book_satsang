import 'package:book_satsang/modules/home/extensions/home_provider_extension.dart';
import 'package:book_satsang/modules/home/providers/home_page_provider.dart';
import 'package:book_satsang/modules/home/providers/member_screen_provider.dart';
import 'package:book_satsang/modules/home/providers/profile_screen_provider.dart';
import 'package:book_satsang/modules/home/providers/satsang_screen_provider.dart';
import 'package:book_satsang/modules/home/screens/member_screen.dart';
import 'package:book_satsang/modules/home/screens/profile_screen.dart';
import 'package:book_satsang/modules/home/screens/satsang_screen.dart';
import 'package:book_satsang/modules/home/screens/wall_screen.dart';
import 'package:book_satsang/modules/home/widgets/bottom_nav/add_satsang_fab.dart';
import 'package:book_satsang/modules/home/widgets/bottom_nav/home_bottom_nav_bar.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:book_satsang/utils/widgets/exit_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../drawer/pages/home_drawer.dart';
import '../../drawer/providers/home_drawer_provider.dart';

/// Main shell after login with bottom navigation and drawer.
///
/// Hosts wall, satsang, members, and profile tabs in a [PageView], with a
/// notched bottom bar and centered Add Satsang floating action button.
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
    final double fabSize = context.adaptiveSize(context.wp(14)).clamp(52.0, 72.0);
    const double notchMargin = 8;

    return ExitHandler(
      child: ChangeNotifierProvider<SatsangScreenProvider>(
        create: (_) => SatsangScreenProvider(),
        child: Scaffold(
          extendBody: true,
          drawer: ChangeNotifierProvider(
            create: (BuildContext context) => HomeDrawerProvider(),
            child: const HomeDrawer(),
          ),
          appBar: AppBar(title: const Text('Home Page'), centerTitle: true),
          body: Selector<HomePageProvider, PageController>(
            selector: (context, p) => p.homePageCon,
            builder: (context, value, child) => PageView(
              onPageChanged: context.homePageProvider.onPageChanged,
              controller: value,
              children: [
                const WallScreen(),
                const SatsangScreen(),
                ChangeNotifierProvider<MemberScreenProvider>(
                  create: (_) => MemberScreenProvider(),
                  child: const MemberScreen(),
                ),
                ChangeNotifierProvider<ProfileScreenProvider>(
                  create: (context) => ProfileScreenProvider(),
                  child: const ProfileScreen(),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: AddSatsangFab(
            size: fabSize,
            onPressed: () =>
                context.homePageProvider.navigateToAddSatsang(context),
          ),
          bottomNavigationBar:
              Selector<HomePageProvider, (List<HomeNavDestination>, int)>(
            selector: (context, p) => (p.destinations, p.currentIndex),
            builder: (context, value, child) => HomeBottomNavBar(
              destinations: value.$1,
              currentIndex: value.$2,
              fabSize: fabSize,
              notchMargin: notchMargin,
              onTap: context.homePageProvider.onChangeMenu,
            ),
          ),
        ),
      ),
    );
  }
}
