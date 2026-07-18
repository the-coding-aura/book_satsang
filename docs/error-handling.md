# Error Handling and UX

## Purpose

This document covers how API errors, loading states, and user feedback are implemented across the app.

Training deliverable: UX polished, errors visible to the user, loaders shown during async work.

## ApiResponse State Pattern

File: lib/network_module/response/api_response.dart

Every major provider exposes one or more ApiResponse fields.

Lifecycle:

1. idle -- initial state
2. loading -- set before async call with a message string
3. completed -- success with typed data
4. error -- failure with message string

Providers call notifyListeners after each transition.

UI reads:

- isLoading -- show spinner or disable button
- isError -- show error feedback
- isCompleted -- enable next action or show success

## User Feedback Components

### AppFlushbar

File: lib/configs/components/app_flushbar.dart

Methods: success, warning, error

Custom overlay at top of screen with colored background from AppColors flushbar constants.

Used in: login, OTP, satsang list, and other providers on API result.

### SnackBar

Used for file upload failures and permission denial messages in FileUploadService and PermissionService.

### Session expired dialog

NetworkApiServices shows a blocking AlertDialog when token refresh fails.

Confirm navigates to login via AppNavigator and clears the session path.

### HTTP 403 Access Restricted

NetworkApiServices maps HTTP 403 to ForbiddenException and shows AppFlushbar.error with "Access Restricted." via AppNavigator.

Applies to get, post, and uploadFile. Concurrent 403s are deduped so the message is not spammed.

### No Internet page

NetworkApiServices checks ConnectivityService before each live API call.

When offline, it pushes RoutesName.noInternet and throws NoInternetException.

NoInternetPage offers Check Again. Reconnected users pop back to the previous screen; still-offline users see an error flushbar and remain on the page.

See connectivity.md for full details.

## Loading UI Patterns

### Button loading

Selector watches provider ApiResponse.isLoading.

Button disabled and label changes, for example "Checking..." or "Submitting...".

See SendOtpButton and registration submit button.

### List loading

SatsangScreen shows Center CircularProgressIndicator when satsangListResponse.isLoading.

### Upload progress

Profile and registration image widgets show CircularProgressIndicator with value bound to upload progress fraction from FileUploadService.

### No global overlay

There is no app-wide loading dialog. Each screen handles its own loading indicator.

## Network Exceptions

File: lib/network_module/exception/app_exceptions.dart

Types include NoInternetException, ForbiddenException, FetchDataException, BadRequestException, UnauthorisedException.

NetworkApiServices throws these based on status code and connectivity.

HTTP 403 shows an Access Restricted flushbar from the network layer before throwing ForbiddenException.

Providers typically catch errors and set ApiResponse.error(error.toString()).

Message quality depends on exception toString output. Improve mapping if user-facing copy is needed.

## Step-by-Step: Add Error Handling to a New API Call

1. Add ApiResponse field to provider
2. Set loading before await repository call
3. notifyListeners
4. On success set completed with data
5. On null or unsuccessful response set error with server message or fallback string
6. On catch set error with exception message
7. notifyListeners
8. In widget:
   - Selector disables button when isLoading
   - Listen for isError and call AppFlushbar.error in builder or addListener

Example pattern from LoginProvider checkUserExist and sendOTP methods.

## Tests and Checks

| Scenario | Expected UX |
| --- | --- |
| MOCK login wrong OTP | Error flushbar or error state |
| No network on DEV | No Internet page opens; Check Again retries |
| Satsang fetch loading | Spinner visible |
| Submit while loading | Button disabled |
| Session expired | Dialog, then login screen |
| HTTP 403 | Access Restricted flushbar |

Turn off network on device or emulator to test offline behavior on DEV flavor.

## Common Issues

**Error shown twice**

Avoid calling flushbar in both provider and widget listener. Pick one layer.

**Loading stuck true**

Ensure every code path after await sets completed or error. Use try/finally if needed.

**Raw exception text shown to user**

Map known exceptions to friendly strings in provider before setting error state.

**Flushbar hidden behind keyboard**

Dismiss keyboard before showing flushbar on form screens.

## Notes for Future Developers

- Keep loading and error state in the provider, not in widget local state, for consistency.
- validationMessages from BaseApiResponse may contain field errors. Parse these for form-level feedback when backend sends them.
- Profile submit when wired should follow the same ApiResponse plus flushbar pattern.

See network-layer.md for ApiResponse and exception types, connectivity.md for offline UX, and authentication.md for examples in login and OTP flows.