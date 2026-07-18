# Home Module

## Purpose

This document covers the main shell after login: custom notched bottom navigation, PageView switching, the centered Add Satsang action, and the navigation drawer.

Training deliverable: Home and navigation ready, drawer items open correctly, Add Satsang FAB sits in the bottom-bar notch.

## Entry Point

File: lib/modules/home/pages/home_page.dart

Structure:

- Scaffold with `extendBody: true`, drawer, app bar, body, notched bottom bar, and center-docked FAB
- Drawer: HomeDrawer wrapped in HomeDrawerProvider
- Body: PageView driven by HomePageProvider.homePageCon
- Bottom bar: HomeBottomNavBar synced with currentIndex
- FAB: AddSatsangFab aligned in the inward circular notch

## Custom Bottom Navigation

Files:

| File | Role |
|------|------|
| lib/modules/home/widgets/bottom_nav/home_bottom_nav_bar.dart | Notched BottomAppBar with four tab slots |
| lib/modules/home/widgets/bottom_nav/add_satsang_fab.dart | Circular Add Satsang button and HomeNavItem |
| lib/modules/home/widgets/bottom_nav/bottom_nav_notch_clipper.dart | Optional CustomClipper matching the notch geometry |

Behavior:

- BottomAppBar uses CircularNotchedRectangle for a smooth inward center curve
- FloatingActionButtonLocation.centerDocked places AddSatsangFab in the notch
- Two destinations sit left of the notch, two on the right
- Selected tab uses brighter white + slight scale; unselected uses softer white
- FAB size is responsive via context.wp and context.adaptiveSize, clamped for phones and tablets
- Safe area / home-indicator padding is handled by BottomAppBar
- AddSatsangFab uses a short press scale animation before navigation

Managed by HomePageProvider in lib/modules/home/providers/home_page_provider.dart.

## Bottom Tabs

| Index | Label | Screen | Status |
|-------|-------|--------|--------|
| 0 | Posts | WallScreen | Placeholder |
| 1 | Satsang | SatsangScreen | Implemented |
| 2 | Members | MemberScreen | Implemented (see member-search.md) |
| 3 | Profile | ProfileScreen | Partial (see profile-module.md) |

Tab change calls homePageCon.jumpToPage(index). Swiping the PageView calls onPageChanged to update the bottom bar index.

SatsangScreenProvider is created above the home Scaffold. Member and Profile providers wrap their screens inline.

## Add Satsang FAB

AddSatsangFab calls HomePageProvider.navigateToAddSatsang:

1. pushNamed to RoutesName.addSatsang
2. After return, onChangeMenu(1) selects the Satsang tab

Route wiring lives in routes_name.dart and routes.dart. The add form itself is documented under the home Add Satsang page and widgets.

## Satsang Tab

Files:

- lib/modules/home/screens/satsang_screen.dart
- lib/modules/home/providers/satsang_screen_provider.dart

On load, fetchSatsangList calls GET /Satsang/GetSatsang with pageNumber 1 and pageSize 20.

UI shows a list of cards with satsang name, temple, address, village, taluka, and dates.

Uses LabelInfoWidget from lib/modules/home/widgets/label_info.dart for row layout.

Loading state shows a shimmer list. Errors use AppFlushbar.

## Wall and Members Tabs

WallScreen: displays placeholder text "Wall Screen".

MemberScreen: loads and lists members. See member-search.md for search and filters.

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
2. Add a HomeNavDestination in HomePageProvider.destinations
3. Add screen to PageView children in home_page.dart in the same index order
4. Keep an even split around the notch (update HomeBottomNavBar layout if the count is no longer 2 + 2)
5. If the tab needs state or API calls, add a provider and wrap the screen in ChangeNotifierProvider
6. Test tab tap, swipe, and FAB alignment on phone and tablet sizes

## Tests and Checks

| Check | Expected |
|-------|----------|
| Login lands on home | Default tab is index 0 (Posts) |
| Tab switching | Tapping each tab shows correct screen |
| Swipe between tabs | Bottom bar index updates |
| Notch + FAB | Circular Add button sits centered in the inward curve |
| FAB tap | Opens Add Satsang; returning selects Satsang tab |
| Drawer Special Thanks | Page opens, back returns to home |
| Drawer Core Team | Page opens, back returns to home |
| Satsang tab MOCK | List loads from mock repository |
| Satsang tab DEV | List loads from API or shows error flushbar |
| Small / large phones | Bar height and FAB size remain balanced |

## Common Issues

**PageView and bottom bar out of sync**

Ensure onPageChanged updates currentIndex and onChangeMenu uses jumpToPage not animateToPage unless both are configured.

**FAB covers a tab label**

Confirm HomeBottomNavBar still reserves SizedBox width for fabSize + notchMargin * 2 in the center.

**Satsang list empty on DEV**

Check API response shape against SatsangListResponseModel. Confirm auth token is present.

**Drawer provider not found**

HomeDrawerProvider is only available below the drawer ChangeNotifierProvider in home_page.dart.

**Content hidden behind the bar**

HomePage sets extendBody: true. List screens may need bottom padding equal to the bar height when content scrolls under the notch.

## Notes for Future Developers

- AppBar title is hardcoded "Home Page". Consider making it dynamic per tab.
- Wall tab is reserved for a future posts or events feed.
- BottomNavNotchClipper is available if a fully custom-painted bar is needed instead of BottomAppBar.
- Prefer AppColors.primary and ResponsiveExtension sizing when adjusting FAB or bar metrics.

See static-pages.md for drawer static content, member-search.md for the members tab, and profile-module.md for the profile tab.
