# Project Structure

## Purpose

This document describes how the Flutter application is organized, which packages it uses, how environments are configured, and how dependency injection is set up.

Training deliverable: structure ready, project runs with chosen state management and packages.

## Folder Layout

```
lib/
  main.dart                  App entry, flavor resolution, DI setup
  app.dart                   MaterialApp root
  configs/
    routes/                  Named routes and navigator key
    theme/                   AppColors, AppTheme
    components/              Shared UI helpers (AppFlushbar)
  dependency_injection/
    locator.dart             get_it registrations
  environments/
    mock.dart, dev.dart, uat.dart, prod.dart
  network_module/
    network/                 HTTP client, API paths, app config
    exception/               Typed network exceptions
    response/                ApiResponse wrapper, Status enum
  services/
    auth/                    Secure token read/write
    access/                  File upload, permissions
  utils/
    bootstrap/               Android image picker config
    constants/               OTP length, timer, mock OTP
    extensions/              Responsive sizing helpers
  modules/
    splash/
    login/
    otp/
    registeration/           Note: folder name uses this spelling throughout
    home/
    drawer/
    master/                  Shared master data and file upload repos
```

Each feature module typically contains:

| Folder | Contents |
|--------|----------|
| pages/ | Top-level screen widgets |
| providers/ | ChangeNotifier classes |
| extensions/ | BuildContext shortcuts to providers |
| widgets/ | Reusable UI for that feature |
| repository/ | Abstract API contract plus HTTP and mock implementations |
| models/ | request_models/ and response_models/ |

## State Management

Primary choice: provider package with ChangeNotifier.

How it is wired:

1. Routes.generateRoute wraps each screen in ChangeNotifierProvider
2. Providers hold API state, form controllers, and validation streams
3. Extension methods on BuildContext give short access, for example context.loginProvider
4. UI uses StreamBuilder for form validity and Selector for loading flags

Reactive validation uses rxdart BehaviorSubject streams combined with StreamTransformer validators in login and registration providers.

Providers are not registered in get_it. Only services and repositories use the service locator.

## Dependency Injection

File: lib/dependency_injection/locator.dart

get_it registers:

| Registration | Mock flavor | Live flavor |
|--------------|-------------|-------------|
| BaseApiServices | MockApiServices | NetworkApiServices |
| LoginApiRepository | LoginMockApiRepository | LoginHttpApiRepository |
| OTPApiRepository | OTPMockApiRepository | OTPHttpApiRepository |
| HomeApiRepository | HomeMockApiRepository | HomeHttpApiRepository |
| RegisterApiRepository | RegisterMockApiRepository | RegisterHttpApiRepository |
| MasterApiRepository | MasterMockApiRepository | MasterHttpApiRepository |
| DrawerApiRepository | DrawerMockApiRepository | DrawerHttpApiRepository |
| AuthService | always | always |
| FileUploadService | always | always |
| PermissionService | always | always |

AppEnvironment.isMock determines which implementation set is used. This is set during flavor startup in lib/environments/.

## Environment and Flavors

main.dart reads the Android flavor via MethodChannel, calls the matching start function, then calls setupLocator().

| Flavor | Environment file | API type |
|--------|------------------|----------|
| MOCK | mock.dart | Mock repositories |
| DEV | dev.dart | Live HTTP |
| UAT | uat.dart | Live HTTP |
| PROD | prod.dart | Live HTTP |

AppConfig holds appName, flavorName, apiBaseUrl, and environment at runtime.

## Key Packages

| Package | Role |
|---------|------|
| provider | Screen-level state |
| rxdart | Form validation streams |
| get_it | Service locator |
| http | REST calls |
| flutter_secure_storage | Auth token persistence |
| pinput | OTP PIN input |
| dropdown_search | Searchable taluka and village dropdowns |
| intl | Date formatting |
| image_picker, file_picker | Profile and registration file upload |
| permission_handler, device_info_plus | Runtime permissions |
| cached_network_image | Network image caching |

Full list is in pubspec.yaml at the project root.

## Setup Steps for a New Module

1. Create lib/modules/your_feature/ with pages, providers, extensions, widgets, repository, models folders
2. Add abstract repository in repository/your_api_repository.dart
3. Add HTTP and mock implementations
4. Export via repository barrel file
5. Register repository in locator.dart for both mock and live branches
6. Add route name in routes_name.dart and case in routes.dart
7. Wrap the page provider in Routes.generateRoute

## Tests and Checks

| Check | Expected |
|-------|----------|
| flutter run --flavor MOCK | App starts, mock repos respond without network |
| flutter run --flavor DEV | App hits DEV base URL |
| New repository registered | No GetIt registration errors at startup |

## Common Issues

**GetIt: Object/factory with type X is not registered**

Add the repository to both branches in setupLocator().

**Provider not found in context**

Ensure ChangeNotifierProvider wraps the screen in routes.dart or in the parent widget tree.

**Wrong API base URL**

Check which flavor was used at build time. Debug print in main.dart logs flavor and base URL in debug mode.

## Notes for Future Developers

- Keep the registeration folder spelling consistent if you add imports. Renaming would touch many files.
- Do not put UI providers in get_it. The existing pattern scopes them per route.
- When adding a new API, add the path to ApiPath enum first, then repository, then provider.

See network-layer.md for API details and navigation.md for route wiring.
