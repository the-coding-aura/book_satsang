import 'package:book_satsang/configs/routes/app_navigator.dart';
import 'package:book_satsang/configs/routes/routes.dart';
import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:book_satsang/configs/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Root widget for the Book Satsang application.
///
/// Configures [MaterialApp] with app-wide theme, navigation, and the initial
/// splash route.
class BookSatsangApp extends StatelessWidget {
  /// Creates the root application widget.
  const BookSatsangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.key,
      debugShowCheckedModeBanner: false,
      title: 'Book Satsang',
      theme: AppTheme.lightTheme,
      initialRoute: RoutesName.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
