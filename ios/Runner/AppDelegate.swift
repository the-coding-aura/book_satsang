import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as? FlutterViewController
    if let messenger = controller?.binaryMessenger {
      let flavorChannel = FlutterMethodChannel(name: "flavor", binaryMessenger: messenger)
      flavorChannel.setMethodCallHandler { call, result in
        if call.method == "getFlavor" {
          result(AppDelegate.resolveFlavor())
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Resolves the active flavor from the bundle identifier suffix so the Dart
  /// side selects the same environment as Android's `BuildConfig.FLAVOR`.
  private static func resolveFlavor() -> String {
    let bundleId = Bundle.main.bundleIdentifier ?? ""
    if bundleId.hasSuffix(".dev") {
      return "DEV"
    } else if bundleId.hasSuffix(".mock") {
      return "MOCK"
    } else {
      return "PROD"
    }
  }
}
