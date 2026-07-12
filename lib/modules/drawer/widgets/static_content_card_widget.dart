import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Styled card shell shared by static informational pages.
class StaticContentCardWidget extends StatelessWidget {
  /// Creates a [StaticContentCardWidget] wrapping [child].
  const StaticContentCardWidget({super.key, required this.child});

  /// Card body content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.inputFill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.inputBorder),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.wp(4)),
        child: child,
      ),
    );
  }
}
