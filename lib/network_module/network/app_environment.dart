/// Distinguishes mock (offline) and live (real API) runtime modes.
///
/// Set via [AppConfig.setup] and read by [AppEnvironment.current].
enum AppEnvironmentType { mock, live }

/// Tracks the active runtime environment for conditional behavior.
///
/// Use [isMock] to branch between mock services and live network calls.
class AppEnvironment {
  AppEnvironment._();

  /// The environment currently in effect, defaulting to mock.
  static AppEnvironmentType current = AppEnvironmentType.mock;

  /// Whether the app is running against mock data instead of the live API.
  static bool get isMock => current == AppEnvironmentType.mock;
}
