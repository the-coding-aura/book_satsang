import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Row widget displaying a labeled icon and informational text.
///
/// Used in satsang cards to present field label and value pairs.
class LabelInfoWidget extends StatelessWidget {
  /// Icon shown beside the label.
  final IconData icon;

  /// Display label for the information row.
  final String label;

  /// Value text displayed after the label.
  final String info;

  /// Creates a [LabelInfoWidget] with the given [icon], [label], and [info].
  const LabelInfoWidget({
    super.key,
    required this.label,
    required this.info,
    required this.icon,
  });

  /// Builds the labeled information row.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: context.wp(8)),
        Text(
          " $label : ",
          style: TextStyle(
            color: AppColors.labelColor,
            fontSize: context.sp(4),
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            info,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: context.sp(4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
