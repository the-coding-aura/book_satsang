# Testing and QA

## Purpose

This document provides a practical QA checklist for verifying all training milestones and known flows before release or handover to the next team.

Training deliverable: all flows stable after QA and bugfix pass.

## Test Environment Setup

| Environment | Command | Use for |
|-------------|---------|---------|
| MOCK | flutter run --flavor MOCK | Offline UI and flow testing |
| DEV | flutter run --flavor DEV | Live API integration |
| UAT | flutter run --flavor UAT | UAT when URL is configured |
| PROD | flutter run --flavor PROD | Production when URL is configured |

Run static analysis before any release candidate:

```
flutter analyze
```

Run unit/widget test:

```
flutter test
```

Current test coverage is minimal. test/widget_test.dart only smoke-tests that BookSatsangApp builds.

## Automated Tests

| File | Coverage |
|------|----------|
| test/widget_test.dart | App widget pumps without error |

No integration tests or mockito-based unit tests exist at handover.

Primary QA path is manual testing on MOCK and DEV flavors.

## QA Checklist by Milestone

### Environment

- [ ] flutter doctor passes on build machine
- [ ] flutter pub get succeeds
- [ ] App launches on emulator and physical device

### Authentication -- Login UI

- [ ] Mobile field accepts digits only
- [ ] Submit disabled until 10 digits entered
- [ ] Terms must be accepted
- [ ] Privacy policy dialog opens and closes

### Authentication -- OTP UI

- [ ] OTP screen shows masked mobile
- [ ] Timer counts down from 30 seconds
- [ ] Resend disabled during countdown
- [ ] Change mobile link returns to login
- [ ] MOCK login OTP 123456 completes login

### Navigation

- [ ] Splash routes to login when logged out
- [ ] Splash routes to home when session exists
- [ ] Login to OTP to home flow works
- [ ] New user reaches registration after OTP verify
- [ ] Registration success returns to login
- [ ] Back from login does not bypass auth incorrectly

### Registration

- [ ] All fields validate before submit
- [ ] Taluka and village dropdown search works
- [ ] Profile image upload from camera and gallery
- [ ] File size over 5 MB rejected
- [ ] Register API success on DEV

### Home and Drawer

- [ ] All four bottom tabs switch correctly
- [ ] PageView swipe syncs with bottom bar
- [ ] Drawer opens and closes
- [ ] Special Thanks page opens and scrolls
- [ ] Core Team page opens and scrolls
- [ ] Logout returns to login and clears session

### Satsang tab

- [ ] List loads on MOCK
- [ ] List loads on DEV with valid session
- [ ] Loading spinner shows during fetch
- [ ] Error flushbar on failure

### Profile tab

- [ ] Profile data loads after login
- [ ] Fields editable
- [ ] Image upload works
- [ ] Submit button known gap -- document if still unwired

### Session

- [ ] Session survives app restart after login
- [ ] Logout clears session
- [ ] Session expired dialog on DEV when token invalid

### Error handling

- [ ] API errors show flushbar or error state
- [ ] Buttons disabled during loading
- [ ] No uncaught exception dialogs on common flows

### Not in scope at handover

- [ ] Members search screen
- [ ] Wall feed content
- [ ] Role-based UI differences
- [ ] OTP resend API
- [ ] Profile save API

Mark these as pending in bug tracker, not as failures.

## Mock Test Credentials

MOCK flavor uses mock repositories. No real credentials needed.

Login OTP for mock member login: 123456 (AppConstants.mockOtp)

Confirm OTP input field length matches what mock repository accepts.

## DEV Test Notes

DEV base URL: https://vhp-karwar-api.ifelsesolutions.in/api

Requires valid mobile numbers registered on the DEV server.

SSL override is active in main.dart for certificate issues.

## Bug Reporting Template

When logging issues during QA, include:

1. Flavor (MOCK or DEV)
2. Device and OS version
3. Steps to reproduce
4. Expected vs actual result
5. Screenshot or log snippet if available

## Common Regression Areas

- OTP length mismatch between UI and backend
- Taluka change not clearing village selection
- Drawer navigation without closing drawer first
- Provider scope errors after route changes
- Permission denial on Android 13+ for gallery pick

## Notes for Future Developers

- Expand flutter test coverage starting with LoginValidator and RegisterFormValidator unit tests.
- Add integration_test package for end-to-end login flow when CI is available.
- Run full checklist on both MOCK and DEV before each milestone demo or release.
- Update this checklist when profile submit, member search, or role UI are completed.

See README.md for known gaps summary and individual module docs for implementation detail.
