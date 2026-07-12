import 'package:book_satsang/modules/drawer/widgets/static_content_card_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Card displaying a titled acknowledgement for the special thanks page.
class AcknowledgementCardWidget extends StatelessWidget {
  /// Creates an [AcknowledgementCardWidget].
  const AcknowledgementCardWidget({
    super.key,
    required this.title,
    required this.description,
  });

  /// Acknowledgement heading.
  final String title;

  /// Supporting description text.
  final String description;

  @override
  Widget build(BuildContext context) {
    return StaticContentCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(4.2),
              fontWeight: FontWeight.w700,
              color: const Color(0xFFA05D19),
            ),
          ),
          SizedBox(height: context.hp(1)),
          Text(
            description,
            style: TextStyle(
              fontSize: context.sp(3.6),
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
