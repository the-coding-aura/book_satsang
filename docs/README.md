# Flutter Application Handover

This folder contains developer handover notes for the Flutter training project. Each file covers one functional area and can be read on its own.

The app is a member-facing mobile application with OTP login, registration, a tabbed home screen, drawer navigation, and API-backed profile and satsang data.

## Documentation Index

| File | Area |
|------|------|
| environment-setup.md | Flutter SDK, IDE setup, running the app |
| flutter-fundamentals.md | Widget basics covered during training |
| project-structure.md | Folder layout, state management, flavors, DI |
| navigation.md | Named routes and screen flow |
| authentication.md | Login, OTP, registration |
| network-layer.md | API client, models, repositories |
| connectivity.md | Offline check and No Internet page |
| home-module.md | Bottom tabs, notched bar, Add Satsang FAB, drawer, satsang tab |
| static-pages.md | Special Thanks and Core Team pages |
| profile-module.md | Profile fetch and edit screen |
| member-search.md | Members tab and search dropdowns |
| session-storage.md | Secure token storage and logout |
| error-handling.md | Loaders, flushbars, API error states |
| role-based-access.md | Role-based UI status and future work |
| testing-and-qa.md | QA checklist and test commands |

## Quick Start

1. Complete steps in environment-setup.md
2. Run with mock flavor for local development without a backend:

```
flutter pub get
flutter run --flavor MOCK
```

3. Run against the DEV API:

```
flutter run --flavor DEV
```

## Training Milestone Map

The project was built in stages during candidate training. Each doc file notes which milestone it relates to.

| Milestone | Deliverable | Doc reference |
|-----------|-------------|-----------------|
| Environment setup | Dev machine ready | environment-setup.md |
| Flutter basics | Simple UI with state | flutter-fundamentals.md |
| Login UI | Mobile input with validation | authentication.md |
| OTP UI | PIN input and resend timer | authentication.md |
| Navigation | Login to OTP to Home flow | navigation.md |
| Project structure | Modules, Provider, packages | project-structure.md |
| API layer | Models and ApiClient | network-layer.md |
| Connectivity | Offline check and retry page | connectivity.md |
| Send OTP integration | Login API wired | authentication.md |
| Verify OTP integration | Login and register paths | authentication.md |
| Registration | Form UI and API | authentication.md |
| Home and drawer | Tabs, notched FAB nav, drawer | home-module.md |
| Member search | Search screen | member-search.md |
| Static pages | Special Thanks, Core Team | static-pages.md |
| Session handling | Token persistence, logout | session-storage.md |
| Error handling | Loaders and user feedback | error-handling.md |
| Role-based UI | Admin and core role checks | role-based-access.md |
| QA and bugfix | Stable flows | testing-and-qa.md |

## Known Gaps at Handover

These items were planned in training but are incomplete or placeholder only:

- Profile submit API is not wired. UI and fetch work; save button does nothing.
- Members tab is a placeholder. No member list or search screen yet.
- Wall tab is a placeholder.
- OTP resend API call is commented out. Timer UI still runs.
- Role-based UI rules are not implemented.
- PROD and UAT base URLs in environment files are placeholders.

Review the relevant doc file before picking up any of these tasks.

## Key Entry Points in Code

| Concern | Location |
|---------|----------|
| App entry | lib/main.dart |
| MaterialApp and routes | lib/app.dart, lib/configs/routes/ |
| Dependency injection | lib/dependency_injection/locator.dart |
| Environment config | lib/environments/ |
| HTTP client | lib/network_module/network/network_api_services.dart |
| Connectivity | lib/services/connectivity/connectivity_service.dart |
| Auth storage | lib/services/auth/auth_service.dart |
| Home shell | lib/modules/home/pages/home_page.dart |
