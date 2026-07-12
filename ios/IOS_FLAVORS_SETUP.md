# iOS Flutter Flavors Implementation Guide (DEV, MOCK, PROD)

This document describes **every change** made to configure the iOS native project to
support the three Flutter flavors — **DEV**, **MOCK**, and **PROD** — so the iOS app
behaves consistently with the existing Android flavor setup.

It is written so another developer can reproduce the entire setup from scratch.

---

## 1. Overview

| Flavor | Xcode Scheme | Bundle Identifier | Product / Display Name | App Icon Set | Dart Environment |
|--------|--------------|-------------------|------------------------|--------------|------------------|
| **PROD** | `PROD` | `com.example.bookSatsangApp` | `KrishnaCargo` | `AppIcon-PROD` (original) | `startProduction()` → `https://api.kaclpl.com` |
| **DEV**  | `DEV`  | `com.example.bookSatsangApp.dev` | `KrishnaDEV` | `AppIcon-DEV` (blue tint) | `startDev()` → `https://krishnacargoapi.ifelsesolutions.in` |
| **MOCK** | `MOCK` | `com.example.bookSatsangApp.mock` | `KrishnaMOCK` | `AppIcon-MOCK` (purple tint) | `startMock()` → `http://localhost:3000` |

Because the three flavors use **different bundle identifiers**, all three apps can be
installed on the **same device simultaneously**.

The bundle-ID suffixes (`.dev`, `.mock`, none for PROD) intentionally mirror the Android
`applicationIdSuffix` values (`.dev`, `.mock`, none), and the icon tint colors match the
Android launcher icon tints (DEV `#1976D2` blue, MOCK `#7B1FA2` purple, PROD original).

---

## 2. Build Configuration Matrix

Nine new Xcode build configurations were created (in addition to the original
`Debug` / `Release` / `Profile`, which were kept for tooling compatibility):

| Base Mode | DEV | MOCK | PROD |
|-----------|-----|------|------|
| Debug   | `Debug-DEV`   | `Debug-MOCK`   | `Debug-PROD`   |
| Release | `Release-DEV` | `Release-MOCK` | `Release-PROD` |
| Profile | `Profile-DEV` | `Profile-MOCK` | `Profile-PROD` |

### Scheme → Configuration mapping

| Scheme | Run (Debug) | Test | Profile | Analyze | Archive (Release) |
|--------|-------------|------|---------|---------|-------------------|
| **DEV**  | `Debug-DEV`  | `Debug-DEV`  | `Profile-DEV`  | `Debug-DEV`  | `Release-DEV`  |
| **MOCK** | `Debug-MOCK` | `Debug-MOCK` | `Profile-MOCK` | `Debug-MOCK` | `Release-MOCK` |
| **PROD** | `Debug-PROD` | `Debug-PROD` | `Profile-PROD` | `Debug-PROD` | `Release-PROD` |

---

## 3. Files Created

| # | File | Purpose |
|---|------|---------|
| 1 | `ios/Runner.xcodeproj/xcshareddata/xcschemes/DEV.xcscheme` | Shared Xcode scheme for the DEV flavor. |
| 2 | `ios/Runner.xcodeproj/xcshareddata/xcschemes/MOCK.xcscheme` | Shared Xcode scheme for the MOCK flavor. |
| 3 | `ios/Runner.xcodeproj/xcshareddata/xcschemes/PROD.xcscheme` | Shared Xcode scheme for the PROD flavor. |
| 4 | `ios/Runner/Assets.xcassets/AppIcon-PROD.appiconset/` (Contents.json + PNGs) | PROD app icon (original branding). |
| 5 | `ios/Runner/Assets.xcassets/AppIcon-DEV.appiconset/` (Contents.json + PNGs) | DEV app icon (blue-tinted). |
| 6 | `ios/Runner/Assets.xcassets/AppIcon-MOCK.appiconset/` (Contents.json + PNGs) | MOCK app icon (purple-tinted). |
| 7 | `ios/IOS_FLAVORS_SETUP.md` | This documentation. |
| 8 | `.github/workflows/ios-ipa-build-unified.yml` | Unified CI workflow — choose DEV / MOCK / PROD at run time. |
| 9 | `.github/workflows/ios-ipa-build-DEV.yml` | CI workflow for DEV flavor only. |
| 10 | `.github/workflows/ios-ipa-build-MOCK.yml` | CI workflow for MOCK flavor only. |
| 11 | `.github/workflows/ios-ipa-build-PROD.yml` | CI workflow for PROD flavor only. |
| 12 | `.github/workflows/README.txt` | Quick-reference guide for the GitHub Actions workflows. |

## 4. Files Modified

| # | File | What changed |
|---|------|--------------|
| 1 | `ios/Runner.xcodeproj/project.pbxproj` | Added 27 `XCBuildConfiguration` objects (9 per configuration list) and registered them in the Project, Runner, and RunnerTests configuration lists. Set per-flavor `PRODUCT_BUNDLE_IDENTIFIER`, `PRODUCT_NAME`, and `ASSETCATALOG_COMPILER_APPICON_NAME`. |
| 2 | `ios/Runner/Info.plist` | `CFBundleDisplayName` changed from the hard-coded `Krishna App` to `$(PRODUCT_NAME)` so the home-screen name follows the active configuration. |
| 3 | `ios/Runner/AppDelegate.swift` | Added a `flavor` `FlutterMethodChannel` (`getFlavor`) that returns the flavor derived from the bundle identifier suffix — the iOS equivalent of Android's `BuildConfig.FLAVOR`. |
| 4 | `ios/Podfile` | Added CocoaPods build-configuration mappings for the 9 new configurations so pods are compiled in the correct (debug/release) mode. Set `platform :ios, '15.0'` and enforce `IPHONEOS_DEPLOYMENT_TARGET = 15.0` for all pods in `post_install`. |
| 5 | `ios/Flutter/AppFrameworkInfo.plist` | Raised `MinimumOSVersion` from `12.0` to `15.0` to match Flutter 3.44+ and Xcode 27 requirements. |
| 6 | `ios/Runner.xcodeproj/project.pbxproj` (deployment target) | Set all `IPHONEOS_DEPLOYMENT_TARGET` values to `15.0` (required for CI and local builds with current Flutter/Xcode). |

> No changes were required to the Dart layer for iOS: `lib/main.dart` already resolves the
> flavor through `MethodChannel('flavor').invokeMethod('getFlavor')` and calls
> `startDev()` / `startMock()` / `startProduction()`. The new iOS `AppDelegate` handler
> supplies the value that channel expects.

---

## 5. Step-by-Step Implementation Details

### Step 1 — Build Configurations (`project.pbxproj`)

Xcode stores build configurations in three `XCConfigurationList` objects:

* **PBXProject "Runner"** — project-level defaults (compiler/warning flags, SDK, deployment target).
* **PBXNativeTarget "Runner"** — the app target (bundle id, product name, app icon, xcconfig base).
* **PBXNativeTarget "RunnerTests"** — the unit-test target (`TEST_HOST` pointing at the host app).

For each list, nine new `XCBuildConfiguration` entries were added:

* `Debug-*` entries are based on the original **Debug** settings
  (`DEBUG_INFORMATION_FORMAT = dwarf`, `ONLY_ACTIVE_ARCH = YES`, `SWIFT_OPTIMIZATION_LEVEL = -Onone`,
  and `baseConfigurationReference = Flutter/Debug.xcconfig` on the app target).
* `Release-*` entries are based on the original **Release** settings
  (`dwarf-with-dsym`, `SWIFT_COMPILATION_MODE = wholemodule`, `SWIFT_OPTIMIZATION_LEVEL = -O`,
  `baseConfigurationReference = Flutter/Release.xcconfig`).
* `Profile-*` entries mirror the original **Profile** settings
  (like Release but without whole-module optimization; `baseConfigurationReference = Flutter/Release.xcconfig`,
  matching Flutter's default Profile config).

Each configuration is referenced from its list, e.g. for the Runner target:

```
97C147051CF9000F007C117D /* Build configuration list for PBXNativeTarget "Runner" */ = {
    isa = XCConfigurationList;
    buildConfigurations = (
        97C147061CF9000F007C117D /* Debug */,
        97C147071CF9000F007C117D /* Release */,
        249021D4217E4FDB00AE95B9 /* Profile */,
        AAAA1111AAAA1111AAAA0001 /* Debug-DEV */,
        ... (Debug-MOCK, Debug-PROD, Release-*, Profile-*) ...
    );
    ...
};
```

> **Reproduce in Xcode (GUI alternative):** open `Runner.xcodeproj` → select the project →
> **Info** tab → **Configurations** → click **+** → *Duplicate "Debug"/"Release"/"Profile"* and
> rename to `Debug-DEV`, `Release-DEV`, `Profile-DEV`, etc.

### Step 2 — Bundle Identifiers (Step 4 of the request)

On the **Runner target** configurations only:

| Configuration | `PRODUCT_BUNDLE_IDENTIFIER` |
|---------------|-----------------------------|
| `*-DEV`  | `com.example.bookSatsangApp.dev` |
| `*-MOCK` | `com.example.bookSatsangApp.mock` |
| `*-PROD` | `com.example.bookSatsangApp` |

> **Reproduce in Xcode:** Runner target → **Build Settings** → *Packaging* →
> **Product Bundle Identifier** → set a per-configuration value.

### Step 3 — Product Names (Step 5 of the request)

On the **Runner target** configurations only:

| Configuration | `PRODUCT_NAME` |
|---------------|----------------|
| `*-DEV`  | `KrishnaDEV` |
| `*-MOCK` | `KrishnaMOCK` |
| `*-PROD` | `KrishnaCargo` |

### Step 4 — `Info.plist` (Step 6 of the request)

```xml
<key>CFBundleDisplayName</key>
<string>$(PRODUCT_NAME)</string>
```

Because `CFBundleDisplayName` now resolves to `PRODUCT_NAME`, each flavor shows its own
name under the home-screen icon.

### Step 5 — Flavor-specific App Icons (Step 7 of the request)

Three Asset Catalog **AppIcon** sets were created inside `ios/Runner/Assets.xcassets/`:

* `AppIcon-PROD.appiconset` — the original icons copied verbatim from the supplied
  `IOSIcons` asset set.
* `AppIcon-DEV.appiconset` — the same icons with a **blue** (`#1976D2`) tint overlay.
* `AppIcon-MOCK.appiconset` — the same icons with a **purple** (`#7B1FA2`) tint overlay.

Source icons were taken from:
`C:\Users\Admin\Downloads\IOSIcons\Assets.xcassets\AppIcon.appiconset\_`

The tint overlays were generated programmatically (a translucent colored layer drawn over
each PNG) so the three flavors are visually distinguishable, matching the Android launcher
icon tints. Each set contains a standard iPhone `Contents.json` plus the marketing (1024px)
icon.

Each Runner target configuration selects its icon via:

```
ASSETCATALOG_COMPILER_APPICON_NAME = "AppIcon-DEV";   // or AppIcon-MOCK / AppIcon-PROD
```

> **Reproduce in Xcode:** Assets.xcassets → **+** → **iOS → App Icons & Launch Images →
> New iOS App Icon** → rename to `AppIcon-DEV` / `AppIcon-MOCK` / `AppIcon-PROD`, drag icons
> in, then set **Asset Catalog App Icon Set Name** per configuration in Build Settings.

### Step 6 — Xcode Schemes (Steps 1 & 3 of the request)

Three **shared** schemes were created under
`ios/Runner.xcodeproj/xcshareddata/xcschemes/`. Each maps its actions to the flavor's
configurations (see the table in section 2). They target the existing Runner app target
(`BlueprintIdentifier = 97C146ED1CF9000F007C117D`) and RunnerTests target
(`331C8080294A63A400263BE5`).

> **Reproduce in Xcode:** **Product → Scheme → Manage Schemes… → +** (or duplicate Runner),
> name it `DEV`/`MOCK`/`PROD`, tick **Shared**, then in **Edit Scheme** set
> Run/Test/Analyze → `Debug-<flavor>`, Profile → `Profile-<flavor>`, Archive → `Release-<flavor>`.

### Step 7 — Native flavor bridge (`AppDelegate.swift`)

To match Android (`MainActivity` returns `BuildConfig.FLAVOR`), the iOS app answers the same
`flavor` MethodChannel. The flavor is derived from the bundle identifier suffix so no extra
build settings are needed:

```swift
private static func resolveFlavor() -> String {
  let bundleId = Bundle.main.bundleIdentifier ?? ""
  if bundleId.hasSuffix(".dev")  { return "DEV" }
  if bundleId.hasSuffix(".mock") { return "MOCK" }
  return "PROD"
}
```

`lib/main.dart` calls `getFlavor`, receives `DEV` / `MOCK` / `PROD`, and initializes the
matching `AppConfig` environment — identical behavior to Android.

### Step 8 — CocoaPods (`Podfile`)

Set the iOS platform explicitly (do **not** leave it commented out — CocoaPods will
default to `12.0` and `pod install` will fail with current Flutter):

```ruby
platform :ios, '15.0'
```

CocoaPods must know the build mode of every configuration, so the project map was extended:

```ruby
project 'Runner', {
  'Debug' => :debug, 'Profile' => :release, 'Release' => :release,
  'Debug-DEV' => :debug,   'Debug-MOCK' => :debug,   'Debug-PROD' => :debug,
  'Profile-DEV' => :release, 'Profile-MOCK' => :release, 'Profile-PROD' => :release,
  'Release-DEV' => :release, 'Release-MOCK' => :release, 'Release-PROD' => :release,
}
```

Flutter's `ios/Flutter/Debug.xcconfig` / `Release.xcconfig` `#include?` the generated pod
xcconfigs, so the flavored configurations (which inherit those Flutter xcconfigs) link the
correct pods after `pod install`.

Also add a `post_install` hook so every pod target uses the same deployment target:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
```

### Step 9 — Minimum iOS deployment target (`15.0`)

Flutter **3.44+** (stable) and **Xcode 27** (used on GitHub Actions `macos-latest`) require
**iOS 15.0** as the minimum deployment target. If the project is still on `12.0` or `13.0`,
`pod install` fails with:

```
Specs satisfying the `Flutter (from `Flutter`)` dependency were found,
but they required a higher minimum deployment target.
```

Update these three places together:

| File | Setting | Value |
|------|---------|-------|
| `ios/Podfile` | `platform :ios, '…'` | `'15.0'` |
| `ios/Runner.xcodeproj/project.pbxproj` | `IPHONEOS_DEPLOYMENT_TARGET` (all configs) | `15.0` |
| `ios/Flutter/AppFrameworkInfo.plist` | `MinimumOSVersion` | `15.0` |

> **Reproduce in Xcode:** Runner target → **Build Settings** → **iOS Deployment Target** → `15.0`.
> Apply to both the **Project** and **Runner** target (and all flavor configurations).

### Step 10 — GitHub Actions (CI IPA builds)

Four workflow files were added under `.github/workflows/` to build **unsigned IPAs** for
each iOS flavor on GitHub-hosted macOS runners. They mirror the local build commands in
section 7 but run automatically in CI.

#### Workflow files

| File | Actions tab name | Trigger | Flavor |
|------|------------------|---------|--------|
| `ios-ipa-build-unified.yml` | `iOS-ipa-build` | Manual (`workflow_dispatch`) | DEV / MOCK / PROD (select at run time) |
| `ios-ipa-build-DEV.yml` | `iOS-ipa-build-DEV` | Manual | DEV only |
| `ios-ipa-build-MOCK.yml` | `iOS-ipa-build-MOCK` | Manual | MOCK only |
| `ios-ipa-build-PROD.yml` | `iOS-ipa-build-PROD` | Manual | PROD only |

> **Recommended:** use `ios-ipa-build-unified.yml` — one workflow with a flavor dropdown.
> The flavor-specific files are kept for convenience when you always build the same flavor.

#### Flavor → build output mapping (CI)

| Flavor | `--flavor` flag | Xcode scheme | `.app` bundle (not `Runner.app`) | Example IPA filename |
|--------|-----------------|--------------|-----------------------------------|----------------------|
| **PROD** | `PROD` | `PROD` | `KrishnaCargo.app` | `KrishnaCargo-PROD-v1.1.6+19.ipa` |
| **DEV**  | `DEV`  | `DEV`  | `KrishnaDEV.app`   | `KrishnaDEV-DEV-v1.1.6+19.ipa` |
| **MOCK** | `MOCK` | `MOCK` | `KrishnaMOCK.app`  | `KrishnaMOCK-MOCK-v1.1.6+19.ipa` |

Version and build number are read from `pubspec.yaml` (e.g. `1.1.6+19` → name `1.1.6`, build `19`).

#### What each workflow run does (step by step)

1. **Checkout** — `actions/checkout@v4`
2. **Set up Flutter** — `subosito/flutter-action@v2` (stable channel, cached)
3. **Read version** — parses `pubspec.yaml` for `--build-name` / `--build-number` and release tag
4. **Install dependencies** — `flutter pub get`
5. **Install CocoaPods** — `pod install --repo-update` in `ios/` (requires iOS **15.0** platform in Podfile)
6. **Build iOS** — `flutter build ios --flavor <FLAVOR> --release --no-codesign`
7. **Package IPA** — copies `<ProductName>.app` into `Payload/`, zips to `.ipa`
8. **Upload artifact** — `actions/upload-artifact@v4` (retained 30 days on unified workflow)
9. **Upload release** — `softprops/action-gh-release@v2` with tag e.g. `v1.1.6-PROD`

#### Unified workflow inputs

The unified workflow (`iOS-ipa-build`) accepts these manual inputs:

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `flavor` | choice | `PROD` | `PROD`, `DEV`, or `MOCK` |
| `release_tag` | string | *(empty)* | Override tag; defaults to `v<pubspec-version>` |
| `upload_to_release` | boolean | `true` | Upload IPA to GitHub Releases |

Flavor-specific workflows only expose an optional `release_tag` input.

#### Prerequisites for CI

1. Workflow YAML files must exist on the repository **default branch** (`master`) for the
   **Actions** tab to list them. Pushing only to a feature branch (e.g. `IOS_ENV`) will not
   show workflows until they are merged into `master`.
2. **Actions must be enabled** — Repo → **Settings** → **Actions** → **General**.
3. **iOS deployment target 15.0** — required (see Step 9). Without it, step 5 (`pod install`)
   fails with *"required a higher minimum deployment target"*.
4. Workflows use `secrets.GITHUB_TOKEN` (provided automatically) for release uploads.
   No extra secrets are required for **unsigned** builds.

#### How to run from GitHub

1. Push workflow files to `master` (or merge your branch into `master`).
2. Open the repo on GitHub → **Actions**.
3. Select `iOS-ipa-build` (unified) or a flavor-specific workflow.
4. Click **Run workflow** → choose branch → set inputs → **Run workflow**.
5. Download the IPA from:
   - **Actions run → Artifacts**, or
   - **Releases** → tag like `v1.1.6-PROD`

#### Troubleshooting CI

| Problem | Cause | Fix |
|---------|-------|-----|
| No workflows in Actions tab | Workflows not on default branch | Merge/push `.github/workflows/` to `master` |
| `pod install` deployment target error | Podfile still on iOS 12.0 / platform commented out | Set `platform :ios, '15.0'` and update `project.pbxproj` (Step 9) |
| Expected app bundle not found | Wrong `.app` name in IPA step | Use `KrishnaCargo.app` / `KrishnaDEV.app` / `KrishnaMOCK.app`, not `Runner.app` |
| Workflow runs but IPA won't install on device | `--no-codesign` produces unsigned IPA | Re-sign on a Mac with your Team, or add signing secrets to CI |

#### Unsigned vs signed builds

These workflows intentionally produce **unsigned** IPAs (`--no-codesign`). They are suitable for:

- CI artifacts and internal handoff
- Re-signing on a Mac with Xcode / your distribution certificate

For **App Store / TestFlight**, either:

- Archive from Xcode on a Mac with Automatic signing and the correct Team, or
- Extend CI with Apple certificate secrets and replace `--no-codesign` with:
  `flutter build ipa --flavor PROD --release --export-options-plist=ios/ExportOptions.plist`

Each flavor needs its own provisioning profile because bundle IDs differ (see section 6).

#### Changes from the original single-flavor workflow

The previous workflow (pre-flavor setup) had these limitations, now fixed:

| Old behavior | New behavior |
|--------------|--------------|
| No `--flavor` flag | `--flavor DEV` / `MOCK` / `PROD` |
| Packaged `Runner.app` | Packages flavor-specific `Krishna*.app` |
| Only `pod repo update` | `pod install --repo-update` after `flutter pub get` |
| Hard-coded release tag `v1.0` | Dynamic tag from `pubspec.yaml` (e.g. `v1.1.6-PROD`) |
| `checkout@v3`, old upload action | `checkout@v4`, `upload-artifact@v4`, `action-gh-release@v2` |

See also `.github/workflows/README.txt` for a short operator reference.

---

## 6. Signing & Provisioning

* Signing style is left as configured on the Runner target (`CODE_SIGN_STYLE` / your team).
* Because each flavor has a **unique bundle identifier**, you will need (for device builds /
  distribution) a provisioning profile for **each** of:
  * `com.example.bookSatsangApp`
  * `com.example.bookSatsangApp.dev`
  * `com.example.bookSatsangApp.mock`
* With **Automatic signing** and a valid Team, Xcode creates the needed profiles on demand.
  Set the Team once on the Runner target; it applies to all configurations.

---

## 7. How to Build & Run Each Flavor

### From the command line (Flutter)

```bash
# Run on a connected device / simulator
flutter run --flavor DEV
flutter run --flavor MOCK
flutter run --flavor PROD

# Build IPA / archive (unsigned, for CI)
flutter build ios --flavor DEV   --release --no-codesign
flutter build ios --flavor MOCK  --release --no-codesign
flutter build ios --flavor PROD  --release --no-codesign
flutter build ipa --flavor PROD  --release
```

After changing the deployment target or Podfile, always run:

```bash
flutter pub get
cd ios && pod install --repo-update
```

### From Xcode

1. Open `ios/Runner.xcworkspace` (**not** the `.xcodeproj`).
2. In the scheme selector (top-left), choose **DEV**, **MOCK**, or **PROD**.
3. Select a device/simulator and press **Run** (▶) — or **Product → Archive** for a
   release build.

Each produces an app with its own bundle id, display name, and icon, installable alongside
the others.

---

## 8. Verification Checklist

For each scheme (DEV / MOCK / PROD) confirm:

- [ ] App installs without replacing the other flavors (unique bundle id).
- [ ] Home-screen name = `KrishnaDEV` / `KrishnaMOCK` / `KrishnaCargo`.
- [ ] App icon shows the correct tint (blue / purple / original).
- [ ] The Dart app connects to the correct base URL (DEV/MOCK/PROD environment).
- [ ] Archive uses the `Release-<flavor>` configuration.
- [ ] `pod install` succeeds with `platform :ios, '15.0'` (no deployment-target errors).
- [ ] GitHub Actions workflow appears on the **Actions** tab (workflows present on `master`).
- [ ] CI build completes for each flavor and produces the correct `.ipa` artifact.

---

## 9. GitHub Actions — Quick Reference

This section duplicates the operator essentials from Step 10 for day-to-day use.

**Workflow location:** `.github/workflows/`

| Workflow | When to use |
|----------|-------------|
| `iOS-ipa-build` (unified) | General use — pick flavor at run time |
| `iOS-ipa-build-DEV` | Always build DEV |
| `iOS-ipa-build-MOCK` | Always build MOCK |
| `iOS-ipa-build-PROD` | Always build PROD (store/testing) |

**Trigger:** manual only (`workflow_dispatch`) — workflows do not run on push/PR.

**Outputs:**

- GitHub Actions **artifact** (`.ipa` file, 30-day retention on unified workflow)
- GitHub **Release** with tag `<version>-<FLAVOR>` (e.g. `v1.1.6-PROD`)

**Required project settings for CI:** iOS 15.0 deployment target, flavored Xcode schemes,
and Podfile platform line uncommented (see Steps 8–9).

---

## 10. Assumptions & Prerequisites

1. **macOS + Xcode 15 or newer** is required to build/run iOS (Xcode 27 on CI). All project
   edits in this change were authored on Windows; the final build/verification must be
   performed on a Mac.
2. **Minimum iOS deployment target: 15.0** — required by Flutter 3.44+ and current Xcode.
   Do not set `12.0` or `13.0`; `pod install` and CI builds will fail.
3. **CocoaPods** installed; run `flutter pub get` then `pod install --repo-update` (in `ios/`)
   after pulling these changes so the flavored pod xcconfigs are generated.
4. The base bundle identifier is `com.example.bookSatsangApp`. If you change it, update the three
   Runner-target `PRODUCT_BUNDLE_IDENTIFIER` values (and the suffix logic is unaffected).
5. Product names are intentionally space-free (`KrishnaDEV`, `KrishnaMOCK`, `KrishnaCargo`)
   to keep the `.app` bundle name and `TEST_HOST` paths clean; adjust to taste.
6. The supplied icon set is iPhone-oriented (no iPad-specific sizes); add iPad sizes to each
   `Contents.json` if iPad-optimized icons are required.
7. **GitHub Actions** workflows are manual-only; push them to `master` for them to appear in
   the Actions tab. CI uses Flutter stable on `macos-latest` (Xcode 27, Flutter 3.44+).

---

## 11. Reference: Internal Object IDs (project.pbxproj)

| Configuration list | Original IDs | New flavored IDs (prefix) |
|--------------------|--------------|---------------------------|
| PBXProject "Runner" | `97C14703` / `97C14704` / `249021D3` | `BBBB2222BBBB2222BBBB0001`–`0009` |
| PBXNativeTarget "Runner" | `97C14706` / `97C14707` / `249021D4` | `AAAA1111AAAA1111AAAA0001`–`0009` |
| PBXNativeTarget "RunnerTests" | `331C8088` / `331C8089` / `331C808A` | `CCCC3333CCCC3333CCCC0001`–`0009` |

Suffix order for every prefix: `0001`=Debug-DEV, `0002`=Debug-MOCK, `0003`=Debug-PROD,
`0004`=Release-DEV, `0005`=Release-MOCK, `0006`=Release-PROD, `0007`=Profile-DEV,
`0008`=Profile-MOCK, `0009`=Profile-PROD.
