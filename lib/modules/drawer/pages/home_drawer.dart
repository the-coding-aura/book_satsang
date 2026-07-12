import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:book_satsang/modules/drawer/extensions/home_drawer_provider_extension.dart';
import 'package:flutter/material.dart';

/// Side navigation drawer for the home screen.
///
/// Provides shortcuts and a logout action via [HomeDrawerProvider].
class HomeDrawer extends StatelessWidget {
  /// Creates a [HomeDrawer].
  const HomeDrawer({super.key});

  /// Builds the drawer menu with navigation and logout items.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Drawer Header',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.of(context).pop(), // Close the drawer
          ),
          ListTile(
            leading: Icon(Icons.handshake),
            title: Text('Special Thanks'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, RoutesName.specialThanks);
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Core Team'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, RoutesName.coreTeam);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async => context.homeDrawerProvider.logoutUser(
              context,
            ), // Call logout from provider
          ),
        ],
      ),
    );
  }
}
