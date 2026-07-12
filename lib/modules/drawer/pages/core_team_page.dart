import 'package:book_satsang/modules/drawer/widgets/static_page_layout_widget.dart';
import 'package:book_satsang/modules/drawer/widgets/team_member_card_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Static page introducing the core team behind Book Satsang.
class CoreTeamPage extends StatelessWidget {
  /// Creates the core team page.
  const CoreTeamPage({super.key});

  static const _members = [
    (
      name: 'Rajesh Patel',
      role: 'Project Lead',
      bio: 'Guides product vision and community outreach for Book Satsang.',
    ),
    (
      name: 'Priya Shah',
      role: 'Operations',
      bio:
          'Coordinates satsang schedules, member support, and on-ground events.',
    ),
    (
      name: 'Amit Desai',
      role: 'Technology',
      bio:
          'Builds and maintains the app experience for members and organizers.',
    ),
    (
      name: 'Neha Mehta',
      role: 'Community',
      bio:
          'Nurtures member engagement and volunteer coordination across regions.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StaticPageLayoutWidget(
      appBarTitle: 'Core Team',
      headerTitle: 'Meet the Team',
      headerDescription:
          'The core team works together to keep Book Satsang reliable, '
          'welcoming, and focused on serving the satsang community.',
      children: _members
          .map(
            (member) => Padding(
              padding: EdgeInsets.only(bottom: context.hp(2)),
              child: TeamMemberCardWidget(
                name: member.name,
                role: member.role,
                bio: member.bio,
              ),
            ),
          )
          .toList(),
    );
  }
}
