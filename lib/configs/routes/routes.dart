import 'package:book_satsang/configs/routes/routes_name.dart';
import 'package:book_satsang/modules/drawer/pages/core_team_page.dart';
import 'package:book_satsang/modules/drawer/pages/special_thanks_page.dart';
import 'package:book_satsang/modules/home/pages/add_satsang_page.dart';
import 'package:book_satsang/modules/home/pages/home_page.dart';
import 'package:book_satsang/modules/home/providers/add_satsang_provider.dart';
import 'package:book_satsang/modules/home/providers/home_page_provider.dart';
import 'package:book_satsang/modules/login/pages/login_page.dart';
import 'package:book_satsang/modules/login/providers/login_provider.dart';
import 'package:book_satsang/modules/otp/pages/otp_page.dart';
import 'package:book_satsang/modules/otp/providers/otp_provider.dart';
import 'package:book_satsang/modules/registeration/pages/registeration_page.dart';
import 'package:book_satsang/modules/registeration/providers/registeration_provider.dart';
import 'package:book_satsang/modules/splash/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modules/splash/pages/splash_page.dart';

/// Central route factory for named application navigation.
///
/// Maps [RoutesName] values to page routes and wires each screen with its
/// [ChangeNotifierProvider].
class Routes {
  /// Builds a [MaterialPageRoute] for the given [settings.name].
  ///
  /// Returns a fallback error page when [settings.name] does not match a known
  /// route.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<LoginProvider>(
            create: (_) => LoginProvider(),
            child: const LoginPage(),
          ),
        );
      case RoutesName.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<RegisterationProvider>(
            create: (context) => RegisterationProvider(),
            child: const RegisterationPage(),
          ),
        );

      case RoutesName.otp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<OtpProvider>(
            create: (_) => OtpProvider(),
            child: const OTPPage(),
          ),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<HomePageProvider>(
            create: (context) => HomePageProvider(),
            child: const HomePage(),
          ),
        );
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => SplashProvider(),
            child: const SplashScreen(),
          ),
        );

      case RoutesName.specialThanks:
        return MaterialPageRoute(
          builder: (_) => const SpecialThanksPage(),
        );

      case RoutesName.coreTeam:
        return MaterialPageRoute(
          builder: (_) => const CoreTeamPage(),
        );

      case RoutesName.addSatsang:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<AddSatsangProvider>(
            create: (_) => AddSatsangProvider(),
            child: const AddSatsangPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Something went wrong.')),
          ),
        );
    }
  }
}
