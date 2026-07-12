# Krishna App — GitHub Actions iOS IPA Build (Quick Reference)

Full documentation: ios/IOS_FLAVORS_SETUP.md (Steps 9–10, Verification Checklist)

## Workflow files (in this folder)

| File | Actions tab name | Flavor |
| --- | --- | --- |
| ios-ipa-build-unified.yml | iOS-ipa-build | DEV / MOCK / PROD (select at run time) |
| ios-ipa-build-DEV.yml | iOS-ipa-build-DEV | DEV only |
| ios-ipa-build-MOCK.yml | iOS-ipa-build-MOCK | MOCK only |
| ios-ipa-build-PROD.yml | iOS-ipa-build-PROD | PROD only |

## Flavor → IPA output

| Flavor | .app bundle | Example IPA filename |
| --- | --- | --- |
| PROD | KrishnaCargo.app | KrishnaCargo-PROD-v1.1.6+19.ipa |
| DEV | KrishnaDEV.app | KrishnaDEV-DEV-v1.1.6+19.ipa |
| MOCK | KrishnaMOCK.app | KrishnaMOCK-MOCK-v1.1.6+19.ipa |

Version/build number come from pubspec.yaml. Release tags: v1.1.6-PROD, v1.1.6-DEV, etc.

## Prerequisites

- Workflows must be on the default branch (master) to appear in the Actions tab.
- Actions enabled: Repo → Settings → Actions → General.
- iOS deployment target 15.0 in Podfile, project.pbxproj, and AppFrameworkInfo.plist. Without this, pod install fails on macos-latest (Flutter 3.44 + Xcode 27).

## How to run

1. GitHub → Actions → select a workflow → Run workflow.
2. Choose branch (master) and inputs (flavor, optional release tag).
3. Download IPA from Actions → Artifacts, or Releases (e.g. v1.1.6-PROD).

## Pipeline steps

flutter pub get → pod install --repo-update → flutter build ios --flavor X --release --no-codesign → zip Payload → upload artifact + release

## Important

- Builds are UNSIGNED (--no-codesign). Re-sign on a Mac for device/TestFlight/App Store.
- Each flavor needs its own provisioning profile (different bundle IDs).
- Trigger is manual only (workflow_dispatch); no auto-run on push.

## Actions used

actions/checkout@v4, subosito/flutter-action@v2, actions/upload-artifact@v4, softprops/action-gh-release@v2

## Signed IPA (future)

Add Apple certificate secrets and use: flutter build ipa --flavor PROD --release --export-options-plist=ios/ExportOptions.plist

See ios/IOS_FLAVORS_SETUP.md Step 10 for troubleshooting and full details.