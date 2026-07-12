import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:book_satsang/utils/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

/// Shimmer placeholder that mirrors the profile form layout while it loads.
///
/// Renders an avatar circle followed by field-shaped boxes, all animated by
/// the reusable [ShimmerLoading] effect from the utils module.
class ProfileShimmerWidget extends StatelessWidget {
  /// Creates a [ProfileShimmerWidget].
  const ProfileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.wp(5)),
              child: ShimmerBox(
                width: context.wp(40),
                height: context.wp(40),
                shape: BoxShape.circle,
              ),
            ),
            _fieldPlaceholder(context),
            _fieldPlaceholder(context),
            _fieldPlaceholder(context),
            _fieldPlaceholder(context),
            _fieldPlaceholder(context),
            _fieldPlaceholder(context),
          ],
        ),
      ),
    );
  }

  Widget _fieldPlaceholder(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(5),
        vertical: context.wp(2.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: context.wp(25), height: context.wp(3.5)),
          SizedBox(height: context.wp(2)),
          ShimmerBox(
            width: double.infinity,
            height: context.wp(12),
            borderRadius: 12,
          ),
        ],
      ),
    );
  }
}
