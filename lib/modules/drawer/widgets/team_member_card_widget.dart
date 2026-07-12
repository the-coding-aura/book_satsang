import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/modules/drawer/widgets/static_content_card_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Card displaying a core team member's profile summary.
class TeamMemberCardWidget extends StatelessWidget {
  /// Creates a [TeamMemberCardWidget].
  const TeamMemberCardWidget({
    super.key,
    required this.name,
    required this.role,
    required this.bio,
  });

  /// Team member's full name.
  final String name;

  /// Role or designation within the team.
  final String role;

  /// Short biography or responsibility summary.
  final String bio;

  @override
  Widget build(BuildContext context) {
    return StaticContentCardWidget(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: context.wp(7),
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
            child: Icon(
              Icons.person,
              color: AppColors.primary,
              size: context.sp(6),
            ),
          ),
          SizedBox(width: context.wp(4)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: context.sp(4.2),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFA05D19),
                  ),
                ),
                SizedBox(height: context.hp(0.5)),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: context.sp(3.5),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: context.hp(1)),
                Text(
                  bio,
                  style: TextStyle(
                    fontSize: context.sp(3.6),
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
