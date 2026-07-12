# Home Module

## Purpose

This document covers the main shell after login: bottom navigation tabs, PageView switching, and the navigation drawer.

Training deliverable: Home and navigation ready, drawer items open correctly.

## Entry Point

File: lib/modules/home/pages/home_page.dart

Structure:

- Scaffold with drawer, app bar, body, bottom navigation bar
- Drawer: HomeDrawer wrapped in HomeDrawerProvider
- Body: PageView driven by HomePageProvider.homePageCon
- BottomNavigationBar synced with currentIndex

## Bottom Tabs

Managed by HomePageProvider in lib/modules/home/providers/home_page_provider.dart.

| Index | Label | Screen | Status |
|-------|-------|--------|--------|
| 0 | Posts | WallScreen | Placeholder |
| 1 | Satsang | SatsangScreen | Implemented |
| 2 | Members | MemberScreen | Placeholder |
| 3 | Profile | ProfileScreen | Partial (see profile-module.md) |

Tab change calls homePageCon.jumpToPage(index). Swiping the PageView calls onPageChanged to update the bottom bar index.

SatsangScreen has its own ChangeNotifierProvider created inline in HomePage.

ProfileScreen has ProfileScreenProvider scoped the same way.

## Satsang Tab

Files:

- lib/modules/home/screens/satsang_screen.dart
- lib/modules/home/providers/satsang_screen_provider.dart

On load, fetchSatsangList calls GET /Satsang/GetSatsang with pageNumber 1 and pageSize 20.

UI shows a list of cards with satsang name, temple, address, village, taluka, and dates.

Uses LabelInfoWidget from lib/modules/home/widgets/label_info.dart for row layout.

Loading state shows CircularProgressIndicator. Errors use AppFlushbar.

## Wall and Members Tabs

WallScreen: displays placeholder text "Wall Screen".

MemberScreen: displays placeholder text "Members".

Member search and listing are not implemented. See member-search.md.

## Navigation Drawer

File: lib/modules/drawer/pages/home_drawer.dart

Menu items:

| Item | Action |
|------|--------|
| Home | Closes drawer |
| Special Thanks | Navigates to /special-thanks |
| Core Team | Navigates to /core-team |
| Logout | Calls HomeDrawerProvider.logoutUser |

Drawer header is static placeholder text. Update branding here if needed.

Logout flow is documented in session-storage.md.

Static page details are in static-pages.md.

## Provider Access Pattern

Extensions in lib/modules/home/extensions/:

- home_provider_extension.dart -- context.homePageProvider
- satsang_provider_extension.dart -- context.satsangScreenProvider
- profile_screen_rpovider_extension.dart -- context.profileScreenProvider (filename has typo)

Drawer extension: lib/modules/drawer/extensions/home_drawer_provider_extension.dart

## Step-by-Step: Add a New Tab

1. Create screen widget under lib/modules/home/screens/
2. Add BottomNavigationBarItem in HomePageProvider.options
3. Add screen to PageView children in home_page.dart in the same index order
4. If the tab needs state or API calls, add a provider and wrap the screen in ChangeNotifierProvider
5. Test tab tap and swipe both update the correct index

## Tests and Checks

| Check | Expected |
|-------|----------|
| Login lands on home | Default tab is index 0 (Posts) |
| Tab switching | Tapping each tab shows correct screen |
| Swipe between tabs | Bottom bar index updates |
| Drawer Special Thanks | Page opens, back returns to home |
| Drawer Core Team | Page opens, back returns to home |
| Satsang tab MOCK | List loads from mock repository |
| Satsang tab DEV | List loads from API or shows error flushbar |

## Common Issues

**PageView and bottom bar out of sync**

Ensure onPageChanged updates currentIndex and onChangeMenu uses jumpToPage not animateToPage unless both are configured.

**Satsang list empty on DEV**

Check API response shape against SatsangListResponseModel. Confirm auth token is present.

**Drawer provider not found**

HomeDrawerProvider is only available below the drawer ChangeNotifierProvider in home_page.dart.

## Notes for Future Developers

- AppBar title is hardcoded "Home Page". Consider making it dynamic per tab.
- Wall tab is reserved for a future posts or events feed.
- Members tab should host member search when that feature is built.

See static-pages.md for drawer static content and profile-module.md for the profile tab.
