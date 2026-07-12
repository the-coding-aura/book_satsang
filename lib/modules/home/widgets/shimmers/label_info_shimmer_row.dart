import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:book_satsang/utils/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

/// Shimmer row that mirrors [LabelInfoWidget] with shaded boxes for icon,
/// label, and value.
class LabelInfoShimmerRow extends StatelessWidget {
  /// Creates a [LabelInfoShimmerRow].
  const LabelInfoShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final rowHeight = context.sp(4) * 1.25;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShimmerBox(
          width: context.wp(8),
          height: context.wp(8),
          borderRadius: 6,
        ),
        SizedBox(width: context.wp(1.5)),
        ShimmerBox(
          width: context.wp(26),
          height: rowHeight,
          borderRadius: 4,
        ),
        SizedBox(width: context.wp(1.5)),
        Expanded(
          child: ShimmerBox(
            width: double.infinity,
            height: rowHeight,
            borderRadius: 4,
          ),
        ),
      ],
    );
  }
}
