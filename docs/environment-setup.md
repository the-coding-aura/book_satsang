# Environment Setup

## Purpose

This document covers machine setup for building and running the Flutter training application on a developer workstation.

Training deliverable: environment ready, sample app runs.

## Prerequisites

- Windows 10 or later (current team setup) or macOS for iOS builds
- At least 8 GB RAM recommended
- USB debugging enabled on a physical Android device, or an Android emulator configured

## Step 1: Install Flutter SDK

1. Download the stable Flutter SDK from https://docs.flutter.dev/get-started/install
2. Extract to a fixed path, for example `C:\flutter`
3. Add `C:\flutter\bin` to the system PATH
4. Open a new terminal and confirm:

```
flutter --version
```

Expected: Flutter version and Dart version printed without errors.

## Step 2: Install Android Studio

1. Download Android Studio from https://developer.android.com/studio
2. Run the installer and include:
   - Android SDK
   - Android SDK Platform-Tools
   - Android Virtual Device (AVD)
3. Open Android Studio, go to SDK Manager, and install:
   - Latest stable Android SDK Platform
   - Android SDK Build-Tools
4. Create an emulator via Device Manager if you do not have a physical device

## Step 3: Install VS Code

1. Install VS Code from https://code.visualstudio.com/
2. Install extensions:
   - Dart
   - Flutter
3. Optional but useful: Flutter Widget Snippets, Error Lens

## Step 4: Run flutter doctor

```
flutter doctor
```

Fix any reported issues before continuing. Common fixes:

| Issue | Fix |
|-------|-----|
| Android licenses not accepted | Run `flutter doctor --android-licenses` and accept all |
| cmdline-tools missing | Install via Android Studio SDK Manager |
| No connected device | Start an emulator or connect a phone with USB debugging on |

Target state: flutter doctor shows Flutter and Android toolchain without errors.

## Step 5: Clone and Run the Project

1. Clone or copy the project repository
2. Open the project root in VS Code or Android Studio
3. Install dependencies:

```
flutter pub get
```

4. List available devices:

```
flutter devices
```

5. Run the app with the mock flavor (no backend required):

```
flutter run --flavor MOCK
```

6. Run against the development API:

```
flutter run --flavor DEV
```

## Build Flavors

The Android project defines four flavors: MOCK, DEV, UAT, PROD.

Each flavor loads a different environment file under lib/environments/ and sets a different API base URL.

| Flavor | Use case |
|--------|----------|
| MOCK | Local training and UI work without a live API |
| DEV | Integration against the development server |
| UAT | User acceptance testing (URL placeholder in env file) |
| PROD | Production (URL placeholder in env file) |

Flavor is read from native Android code via a MethodChannel in main.dart. If the channel fails, the app falls back to MOCK.

## Tests and Checks

| Check | Expected result |
|-------|-----------------|
| flutter doctor | No blocking errors |
| flutter pub get | Completes without dependency errors |
| flutter run --flavor MOCK | App launches, splash screen appears |
| Login screen reachable | After splash with no saved session, login screen shows |

## Common Issues

**Gradle build fails on first run**

Run `flutter clean` then `flutter pub get` and retry. Ensure Android SDK and JDK bundled with Android Studio are installed.

**Flavor not found**

Always pass `--flavor MOCK` or `--flavor DEV` when running. The project expects a flavor dimension named environment.

**Device not detected**

Enable USB debugging on the phone. For emulators, cold boot the AVD from Android Studio Device Manager.

**Certificate or SSL errors on DEV**

The app uses MyHttpOverrides to accept self-signed certificates in development. This is intentional for the DEV server but must be reviewed before production release.

## Notes for Future Developers

- Do not commit local SDK paths or machine-specific IDE settings.
- Update PROD and UAT base URLs in lib/environments/prod.dart and uat.dart before release builds.
- Document any new flavors in android/app/build.gradle.kts and add a matching start function under lib/environments/.
