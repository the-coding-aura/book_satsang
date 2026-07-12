import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Header section at the top of the login screen.
///
/// Shows the app logo and welcome copy above the sign-in form.
class LoginHeader extends StatelessWidget {
  /// Creates the login screen header.
  const LoginHeader({super.key});

  /// Builds the logo and welcome copy column.
  ///
  /// Uses responsive sizing via [ResponsiveExtension].
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/icons/logo.png',
          height: context.hp(15),
          width: context.wp(55),
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.hp(1)),
          child: Text(
            'Book your satsang experience with ease',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.sp(4.2),
              fontWeight: FontWeight.w600,
              color: const Color(0xFFA05D19),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: context.hp(2),
            bottom: context.hp(1),
          ),
          child: Text(
            'Welcome Back',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.sp(8),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.hp(1)),
          child: Text(
            'Sign in to continue your spiritual journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.sp(4.2),
              fontWeight: FontWeight.w600,
              color: Colors.black38,
            ),
          ),
        ),
      ],
    );
  }
}
