# Navigation

## Purpose

This document covers named route setup and the screen flow from splash through login, OTP, registration, and home.

Training deliverable: navigation flow ready, Login to OTP to Home works.

## Route Definitions

Routes are defined in two files:

- lib/configs/routes/routes_name.dart -- path string constants
- lib/configs/routes/routes.dart -- Route factory with provider wiring

| Route constant | Path | Screen |
|----------------|------|--------|
| splash | /splash | SplashScreen |
| login | / | LoginPage |
| otp | /otp | OTPPage |
| register | /register | RegisterationPage |
| home | /home | HomePage |
| specialThanks | /special-thanks | SpecialThanksPage |
| coreTeam | /core-team | CoreTeamPage |
| addSatsang | /add-satsang | AddSatsangPage |
| noInternet | /no-internet | NoInternetPage |

MaterialApp in lib/app.dart sets initialRoute to splash and onGenerateRoute to Routes.generateRoute.

Global navigator key is in lib/configs/routes/app_navigator.dart. The network layer uses this for session-expired redirects and the No Internet page when no widget BuildContext is available.

## Screen Flow

### Cold start

1. SplashScreen loads
2. SplashProvider checks AuthService for a stored token
3. Token exists: pushReplacementNamed to home
4. No token: pushReplacementNamed to login

### Login to OTP

Two paths depending on whether the mobile number is already registered.

**Existing user**

1. User enters mobile and accepts terms
2. checkUserExist API returns status 1
3. Navigate to OTP with OtpArguments(mobileNo, VerificationType.login)

**New user**

1. checkUserExist returns user not found
2. sendOTP API is called
3. Navigate to OTP with OtpArguments(mobileNo, VerificationType.otp)

### OTP to next screen

**Login verification type**

1. memberLogin API with mobile and OTP
2. On success, store AuthData via AuthService
3. pushNamedAndRemoveUntil to home

**Registration verification type**

1. verifyOtp API
2. On success, pushNamed to register with mobile number as route argument
3. No auth token stored at this step

### Registration to login

1. User completes registration form
2. registerMember API succeeds
3. pushNamed to login

### Home drawer pages

From HomeDrawer:

1. Close drawer for Home item
2. pushNamed to specialThanks or coreTeam for static pages
3. Logout clears session and pushNamedAndRemoveUntil to login

### Home notched bottom navigation

HomePage uses a custom HomeBottomNavBar with CircularNotchedRectangle and a center-docked AddSatsangFab.

Tap Add Satsang to open /add-satsang. On return, the shell selects the Satsang tab.

See home-module.md for layout, sizing, and tab mapping.

## Passing Route Arguments

OTP screen expects RouteSettings.arguments as OtpArguments:

```
OtpArguments(mobileNo: '9876543210', verificationType: VerificationType.login)
```

Registration screen expects a String mobile number in arguments.

Always pass arguments when calling pushNamed for these routes. Missing arguments will cause runtime errors in provider init.

## Implementation Steps to Add a New Route

1. Add a constant in routes_name.dart
2. Import the page in routes.dart
3. Add a case in generateRoute switch
4. Wrap with ChangeNotifierProvider if the screen has a provider
5. Navigate using Navigator.pushNamed(context, RoutesName.yourRoute)

## Tests and Checks

| Flow | Steps | Expected |
|------|-------|----------|
| Fresh install | Launch app | Splash then login |
| Mock login | MOCK flavor, existing user flow, OTP 123456 | Lands on home |
| Register flow | New user, OTP, complete form | Returns to login |
| Drawer static page | Open drawer, tap Special Thanks | Page opens, back returns to home |
| Logout | Drawer logout | Login screen, back does not return to home |

## Common Issues

**Black screen or wrong route after navigation**

Check that route name string matches exactly between pushNamed and routes_name.dart.

**Provider not found after navigation**

Provider must be created in generateRoute for that route, not only on a parent route.

**User returns to home after logout via back button**

Use pushNamedAndRemoveUntil with predicate (route) => false for auth reset flows.

**Session expired dialog navigates incorrectly**

AppNavigator.key must be attached to MaterialApp navigatorKey. Already set in app.dart.

## Notes for Future Developers

- Static pages (Special Thanks, Core Team) do not need providers unless you add API-driven content later.
- HomePage hosts its own HomeDrawerProvider inside the drawer widget. It is not route-scoped at the app level.
- When adding deep links, extend generateRoute to parse query parameters before building the page.

See authentication.md for API details behind each navigation branch, connectivity.md for the offline route, and home-module.md for in-home tab switching.
