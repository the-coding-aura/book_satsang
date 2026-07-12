import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Reusable scaffold layout for static drawer pages.
///
/// Provides an app bar, scrollable body, and a shared header section.
class StaticPageLayoutWidget extends StatelessWidget {
  /// Creates a [StaticPageLayoutWidget].
  const StaticPageLayoutWidget({
    super.key,
    required this.appBarTitle,
    required this.headerTitle,
    required this.headerDescription,
    required this.children,
  });

  /// Title shown in the app bar.
  final String appBarTitle;

  /// Primary heading below the app bar.
  final String headerTitle;

  /// Introductory text below [headerTitle].
  final String headerDescription;

  /// Content widgets rendered below the header.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.wp(6),
          vertical: context.hp(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              headerTitle,
              style: TextStyle(
                fontSize: context.sp(5),
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: context.hp(1)),
            Text(
              headerDescription,
              style: TextStyle(
                fontSize: context.sp(3.8),
                height: 1.5,
                color: AppColors.labelColor,
              ),
            ),
            SizedBox(height: context.hp(3)),
            ...children,
          ],
        ),
      ),
    );
  }
}
