import 'package:book_satsang/modules/drawer/widgets/acknowledgement_card_widget.dart';
import 'package:book_satsang/modules/drawer/widgets/static_page_layout_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Static page listing acknowledgements for contributors and supporters.
class SpecialThanksPage extends StatelessWidget {
  /// Creates the special thanks page.
  const SpecialThanksPage({super.key});

  static const _acknowledgements = [
    (
      title: 'Volunteers',
      description:
          'Heartfelt gratitude to every volunteer who helps coordinate '
          'satsangs, guide members, and keep the community connected.',
    ),
    (
      title: 'Satsang Organizers',
      description:
          'Thank you to the organizers and hosts who make each satsang '
          'a welcoming space for spiritual growth and fellowship.',
    ),
    (
      title: 'Community Members',
      description:
          'Your participation, feedback, and encouragement inspire us to '
          'keep improving Book Satsang for everyone.',
    ),
    (
      title: 'Well-wishers & Supporters',
      description:
          'We are deeply thankful to all well-wishers whose guidance and '
          'support made this app possible.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StaticPageLayoutWidget(
      appBarTitle: 'Special Thanks',
      headerTitle: 'With Gratitude',
      headerDescription:
          'Book Satsang exists because of the kindness, dedication, and '
          'faith of many people. We offer our sincere thanks to everyone '
          'who has contributed to this journey.',
      children: _acknowledgements
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: context.hp(2)),
              child: AcknowledgementCardWidget(
                title: item.title,
                description: item.description,
              ),
            ),
          )
          .toList(),
    );
  }
}
