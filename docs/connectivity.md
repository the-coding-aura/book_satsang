# Connectivity and Offline Handling

## Purpose

This document covers how the app detects internet availability before API calls and how the offline screen guides the user back when connectivity returns.

Training deliverable: connectivity check before HTTP requests, No Internet page with retry.

## Architecture Overview

```
NetworkApiServices (get / post / uploadFile)
  -> ConnectivityService.hasInternetConnection()
  -> online: continue request
  -> offline: push NoInternetPage via AppNavigator, throw NoInternetException
```

Connectivity is checked centrally in the live HTTP client so feature providers and repositories do not need their own offline logic.

Mock flavor skips this path because MockApiServices does not call ConnectivityService.

## ConnectivityService

File: lib/services/connectivity/connectivity_service.dart

Registered in locator.dart as a lazy singleton for all flavors.

Method: hasInternetConnection()

Implementation:

1. Performs InternetAddress.lookup against one.one.one.one
2. Uses a 5 second timeout
3. Returns true when the lookup yields a non-empty address
4. Returns false on SocketException, TimeoutException, or any other failure

No third-party connectivity packages are used. The probe relies on dart:io only.

## No Internet Page

File: lib/modules/connectivity/pages/no_internet_page.dart

Route: /no-internet (RoutesName.noInternet)

UI:

- Wifi-off icon in brand primary color
- Title: No Internet Connection
- Short supporting message
- Check Again button (pill style matching login submit)

Check Again behavior:

1. Button shows Checking... while the probe runs
2. ConnectivityService.hasInternetConnection is called again
3. Connection available: Navigator.pop returns to the previous page
4. Still offline: remain on the page and show AppFlushbar.error

No provider is required. The page resolves ConnectivityService from get_it.

## Network Layer Integration

File: lib/network_module/network/network_api_services.dart

Before get, post, and uploadFile:

1. Call _ensureInternetConnection
2. If offline, call _handleNoInternet then throw NoInternetException

_handleNoInternet:

- Uses AppNavigator to push RoutesName.noInternet
- Guarded by _isHandlingNoInternet so concurrent API failures do not stack pages
- Skips push when the current route is already noInternet
- Does not wait for the page to pop, so providers receive the exception immediately

SocketException during an in-flight request also triggers _handleNoInternet and NoInternetException.

## Step-by-Step: Reuse Connectivity Elsewhere

1. Resolve `getIt<ConnectivityService>()`
2. Await hasInternetConnection()
3. Branch UI or business logic on the boolean result
4. Prefer AppFlushbar or the dedicated NoInternetPage for user feedback

Do not call http directly from widgets when offline messaging is required. Keep checks in NetworkApiServices for API traffic.

## Tests and Checks

| Scenario | Expected |
| --- | --- |
| DEV flavor, Wi-Fi off, trigger any API | No Internet page opens |
| Tap Check Again while still offline | Error flushbar, stay on page |
| Restore network, tap Check Again | Previous page restored |
| Multiple API calls while offline | Single No Internet page |
| MOCK flavor API call | No connectivity page (mock client) |

Turn off network on device or emulator, then exercise login submit or satsang fetch on DEV.

## Common Issues

**No Internet page never appears**

Confirm AppNavigator.key is attached to MaterialApp and setupLocator registered ConnectivityService.

**Page opens twice**

Ensure only NetworkApiServices navigates on offline. Do not also push from providers when catching NoInternetException.

**False offline on restricted networks**

DNS lookup to one.one.one.one may fail on locked-down networks even when the API host is reachable. Adjust the lookup host if needed for that environment.

**Provider stuck in loading**

NoInternetException must propagate to the provider catch path so ApiResponse.error is set. Do not swallow the exception in the repository.

## Notes for Future Developers

- Keep connectivity probing package-free unless product requirements need continuous monitoring streams.
- If adding continuous connectivity banners later, still treat API failures as authoritative and reuse ConnectivityService for the probe.
- Document any change to the lookup host in this file and in network-layer.md.

See network-layer.md for HTTP client details, error-handling.md for exception UX, and navigation.md for route registration.
