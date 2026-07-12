import 'package:book_satsang/modules/home/widgets/shimmers/label_info_shimmer_row.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:book_satsang/utils/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';

/// Shimmer placeholder that mirrors the member list card layout while it loads.
class MemberListShimmerWidget extends StatelessWidget {
  /// Creates a [MemberListShimmerWidget].
  const MemberListShimmerWidget({super.key});

  static const _rowCount = 7;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.wp(2.5)),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(height: context.hp(1)),
        itemBuilder: (_, __) => _cardPlaceholder(context),
      ),
    );
  }

  Widget _cardPlaceholder(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: EdgeInsets.all(context.wp(1)),
        child: Column(
          children: List.generate(
            _rowCount,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index < _rowCount - 1 ? context.hp(0.6) : 0,
              ),
              child: const LabelInfoShimmerRow(),
            ),
          ),
        ),
      ),
    );
  }
}
