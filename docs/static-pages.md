# Static Pages

## Purpose

This document covers the Special Thanks and Core Team static content pages opened from the home drawer.

Training deliverable: static pages ready, layouts responsive on phone sizes.

## Module Location

lib/modules/drawer/

| File | Role |
|------|------|
| pages/special_thanks_page.dart | Special Thanks screen |
| pages/core_team_page.dart | Core Team screen |
| widgets/static_page_layout_widget.dart | Shared scaffold and header |
| widgets/static_content_card_widget.dart | Shared card shell |
| widgets/acknowledgement_card_widget.dart | Thanks entry card |
| widgets/team_member_card_widget.dart | Team member card |

Routes:

- /special-thanks -> SpecialThanksPage
- /core-team -> CoreTeamPage

Defined in routes_name.dart and routes.dart. No provider required.

## Shared Layout Widget

StaticPageLayoutWidget parameters:

- appBarTitle -- shown in AppBar
- headerTitle -- primary heading in brand color
- headerDescription -- intro paragraph
- children -- list of content widgets below the header

Handles Scaffold, AppBar, SingleChildScrollView, and responsive padding via ResponsiveExtension (context.wp, context.hp, context.sp).

## Special Thanks Page

Data is a hardcoded list of acknowledgement records with title and description.

Categories currently listed:

- Volunteers
- Satsang Organizers
- Community Members
- Well-wishers and Supporters

Each item renders as AcknowledgementCardWidget inside StaticContentCardWidget styling.

No API calls. Content updates require editing the _acknowledgements list in special_thanks_page.dart.

## Core Team Page

Data is a hardcoded list of team members with name, role, and bio.

Each item renders as TeamMemberCardWidget with:

- CircleAvatar placeholder icon
- Name in accent color
- Role in primary brand color
- Bio paragraph

No API calls. Content updates require editing the _members list in core_team_page.dart.

## Navigation from Drawer

File: lib/modules/drawer/pages/home_drawer.dart

On tap:

1. Navigator.pop to close drawer
2. Navigator.pushNamed to the route

Back button on the static page returns to HomePage with tab state preserved.

## Step-by-Step: Update Static Content

### Add a thanks entry

1. Open special_thanks_page.dart
2. Add a new record to _acknowledgements with title and description
3. Hot restart and open Special Thanks from drawer

### Add a team member

1. Open core_team_page.dart
2. Add a new record to _members with name, role, bio
3. Hot restart and open Core Team from drawer

### Add a new static drawer page

1. Create page under lib/modules/drawer/pages/
2. Reuse StaticPageLayoutWidget and card widgets or add a new card widget
3. Add route constant and generateRoute case
4. Add ListTile in home_drawer.dart

## Tests and Checks

| Check | Expected |
|-------|----------|
| Open Special Thanks | Scroll works, all cards visible |
| Open Core Team | Avatar and text align on small screen |
| Rotate device or resize | Content scrolls, no overflow errors |
| Back navigation | Returns to home without losing session |

Test on a phone-width emulator. ResponsiveExtension scales font and padding from screen size.

## Common Issues

**Bottom overflow on small screens**

Content is in SingleChildScrollView. If overflow appears, check that new widgets are inside the scroll view children list, not outside the layout widget.

**Drawer stays open behind new page**

home_drawer.dart must call Navigator.pop before pushNamed.

**Card styling inconsistent**

Reuse StaticContentCardWidget rather than creating raw Card widgets in page files.

## Notes for Future Developers

- If content will come from CMS or API later, move lists to a provider and repository but keep the layout widgets.
- TeamMemberCardWidget accepts optional image URL extension point: add a network image parameter when photos are available.
- Static pages do not require MOCK vs DEV flavor distinction.

See home-module.md for drawer integration and navigation.md for route names.
