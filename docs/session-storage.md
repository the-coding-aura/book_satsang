# Session Storage

## Purpose

This document covers local auth token storage, session persistence across app restarts, and logout.

Training deliverable: session handling done, session persists after login, logout clears session.

## Auth Service

File: lib/services/auth/auth_service.dart

Storage: flutter_secure_storage

Key: authKey

Stored object: AuthData serialized as JSON with authToken and refreshToken fields.

### Methods

| Method | Behavior |
|--------|----------|
| storeAuthData | Writes token JSON to secure storage |
| readAuthData | Reads and parses AuthData, returns null if missing |
| logout | Deletes authKey from storage |

Registered as lazy singleton in locator.dart.

## Session Persistence Flow

### Save on login

OtpProvider.memberLogin on success calls AuthService.storeAuthData with tokens from VerifyLogin response.

Registration OTP verify does not store tokens. User must complete registration and log in separately.

### Restore on launch

SplashProvider.checkSessionExists:

1. readAuthData
2. If authToken present and non-empty: pushReplacementNamed home
3. Else: pushReplacementNamed login

### Use on API calls

NetworkApiServices reads token before each request and attaches Authorization Bearer header.

On 401, client attempts refresh using refreshToken via /Member/GetRefreshToken. Updates stored AuthData on success.

## Logout Flow

Triggered from HomeDrawer Logout item.

HomeDrawerProvider.logoutUser:

1. Read refreshToken from AuthService
2. If no refresh token: local logout only, navigate to login
3. Else: POST /Member/VerifyLogout with refresh token via DrawerApiRepository
4. On server success: AuthService.logout, pushNamedAndRemoveUntil login
5. On server failure: logout may not complete locally depending on response handling. Check provider logic when debugging.

DrawerApiRepository has HTTP and mock implementations registered in locator.dart.

## Step-by-Step: Verify Session Handling

1. Run app MOCK flavor
2. Complete login flow to home
3. Kill app process completely
4. Relaunch app
5. Expected: splash then home without login screen
6. Open drawer, tap Logout
7. Expected: login screen
8. Kill and relaunch
9. Expected: splash then login

## Tests and Checks

| Check | Expected |
|-------|----------|
| Login then restart | Session restored, home opens |
| Logout | Login screen, token cleared |
| API after login | Authorized requests succeed |
| Session expired dialog | Redirect to login, storage cleared on confirm |

Session expired dialog is triggered from NetworkApiServices when refresh fails.

## Common Issues

**Always lands on login after restart**

storeAuthData not called on login path. Verify memberLogin success handler in OtpProvider.

**Logout still shows home on back**

Must use pushNamedAndRemoveUntil with (route) => false.

**Secure storage errors on emulator**

Some emulators have keystore issues. Test on physical device if storage read/write fails.

**Token present but API returns 401**

Token expired and refresh failed. User should see session expired dialog.

## Notes for Future Developers

- Do not store tokens in SharedPreferences. Secure storage is intentional.
- If adding biometric lock, wrap readAuthData behind local auth check without changing storage format.
- Logout API failure handling may need UX improvement to force local logout on network error.

See authentication.md for login token creation and navigation.md for post-logout routing.
