# Book Satsang — Architecture Setup Guide

> Reference projects: `voter_reg-main` (folder/repository structure) + `perfect_enterprises-dev` (API services, AppConfig, AppEnvironment, locator, responsive extension)
>
> **State management:** Provider + Selector + RxDart — no Bloc anywhere.

---

## 1. Project Summary

| Item | Value |
|------|-------|
| App | Book Satsang (Flutter) |
| State management | Provider + Selector + RxDart streams |
| DI | `get_it` via `setupLocator()` |
| Flavors | MOCK · DEV · UAT · PROD |
| OTP length | 4 digits |
| Mock OTP | `123456` |
| OTP timer | 30 seconds |

---

## 2. Complete Folder Structure

```
lib/
├── app.dart                                    ← Root MaterialApp widget
├── main.dart                                   ← Flavor bootstrap + locator + runApp
│
├── environments/
│   ├── mock.dart                               ← AppConfig.setup(env: mock)
│   ├── dev.dart
│   ├── uat.dart
│   └── prod.dart
│
├── network_module/
│   ├── exception/
│   │   └── app_exceptions.dart                ← AppException, FetchDataException, etc.
│   ├── network/
│   │   ├── network.dart                       ← Barrel export for this folder
│   │   ├── app_config.dart                    ← Static AppConfig.setup() / AppConfig.apiBaseUrl
│   │   ├── app_environment.dart               ← AppEnvironmentType enum + AppEnvironment.isMock
│   │   ├── base_api_services.dart             ← Abstract: get() / post()
│   │   ├── mock_api_services.dart             ← Simulates network with delay (MOCK flavor)
│   │   ├── network_api_services.dart          ← Real HTTP via `http` package
│   │   ├── api_path.dart                      ← ApiPath enum + ApiPathHelper.getValue()
│   │   └── my_http_overrides.dart             ← Bypass SSL in dev
│   └── response/
│       ├── response.dart                      ← Barrel export
│       ├── status.dart                        ← enum Status { loading, completed, error }
│       ├── api_response.dart                  ← UI state wrapper ApiResponse<T>
│       └── base_api_response.dart             ← Generic API envelope BaseApiResponse<T>
│
├── dependency_injection/
│   └── locator.dart                           ← setupLocator() + GetIt getIt instance
│
├── configs/
│   ├── routes/
│   │   ├── routes_name.dart                   ← Route name constants
│   │   └── routes.dart                        ← Routes.generateRoute with per-route providers
│   └── theme/
│       ├── app_colors.dart                    ← AppColors constants
│       └── app_theme.dart                     ← AppTheme.lightTheme
│
├── utils/
│   ├── constants/
│   │   └── app_constants.dart                 ← otpLength, otpTimerSeconds, mockOtp
│   └── extensions/
│       └── responsive_extension.dart          ← wp() hp() sp() adaptiveSize() isPhone etc.
│
└── modules/
    ├── login/
    │   ├── models/
    │   │   └── login_response_model.dart       ← typedef LoginResponseModel = BaseApiResponse<int>
    │   ├── repository/
    │   │   ├── login_repository.dart           ← Barrel export
    │   │   ├── login_api_repository.dart       ← Abstract: isUserExist()
    │   │   ├── login_mock_api_repository.dart  ← Mock impl
    │   │   └── login_http_api_repository.dart  ← HTTP impl (uses getIt<BaseApiServices>)
    │   ├── providers/
    │   │   └── login_provider.dart             ← ChangeNotifier: isUserExist → sendOTP flow
    │   ├── validators/
    │   │   └── login_validator.dart            ← RxDart StreamTransformer mixin
    │   ├── extensions/
    │   │   └── login_provider_extension.dart   ← context.loginProvider shortcut
    │   ├── pages/
    │   │   └── login_page.dart
    │   └── widgets/
    │       ├── login_header.dart
    │       ├── login_mobile_field.dart         ← StreamBuilder → red border on error
    │       ├── login_mobile_input.dart         ← Plain TextFormField (no inner error)
    │       ├── send_otp_button.dart            ← StreamBuilder + Selector
    │       ├── terms_checkbox.dart             ← StreamBuilder on termStream()
    │       ├── term_label_button.dart          ← Tap → TermCondialog
    │       └── dialoges/
    │           ├── terms_con.dart              ← TermCondialog.show(context)
    │           └── privacy_policy.dart         ← PrivacyPolicyDialog.show(context)
    │
    ├── otp/
    │   ├── models/
    │   │   └── otp_response_model.dart         ← typedef OTPResponseModel = BaseApiResponse<int>
    │   ├── repository/
    │   │   ├── otp_repository.dart             ← Barrel export
    │   │   ├── otp_api_repository.dart         ← Abstract: sendOTP / resendOTP / verifyOTP
    │   │   ├── otp_mock_api_repository.dart    ← Mock: checks AppConstants.mockOtp
    │   │   └── otp_http_api_repository.dart    ← HTTP: uses getIt<BaseApiServices>
    │   ├── providers/
    │   │   └── otp_provider.dart               ← ChangeNotifier: timer, maskedMobile, verify
    │   ├── extensions/
    │   │   └── otp_provider_extension.dart     ← context.otpProvider shortcut
    │   ├── pages/
    │   │   └── otp_page.dart                   ← Auto-verify on onCompleted
    │   └── widgets/
    │       ├── otp_logo_header.dart
    │       ├── otp_title_section.dart
    │       ├── otp_masked_mobile_text.dart     ← Selector<OtpProvider, String>
    │       ├── otp_pin_input.dart              ← Pinput 4-digit square boxes
    │       ├── otp_timer_section.dart          ← Selector<OtpProvider, int>
    │       └── otp_change_mobile_link.dart
    │
    └── home/
        └── pages/home_page.dart               ← Placeholder
```

---

## 3. Environment & AppConfig

### `environments/mock.dart`

```dart
void startMOCK() {
  AppConfig.setup(
    name: 'Book Satsang [MOCK]',
    flavor: 'MOCK',
    baseUrl: 'http://localhost:3000',
    env: AppEnvironmentType.mock,    // sets AppEnvironment.isMock = true
  );
}
```

Each flavor file follows the same pattern. `AppConfig` is a **pure static class** — no singleton, no `getInstance()`.

### Accessing config

```dart
AppConfig.apiBaseUrl    // base URL string
AppConfig.flavorName    // 'MOCK' | 'DEV' | 'UAT' | 'PROD'
AppEnvironment.isMock   // bool — used by locator
```

---

## 4. Dependency Injection (get_it)

### `dependency_injection/locator.dart`

```dart
final GetIt getIt = GetIt.instance;

void setupLocator() {
  if (AppEnvironment.isMock) {
    getIt.registerLazySingleton<BaseApiServices>(MockApiServices.new);
    getIt.registerLazySingleton<LoginApiRepository>(LoginMockApiRepository.new);
    getIt.registerLazySingleton<OTPApiRepository>(OTPMockApiRepository.new);
  } else {
    getIt.registerLazySingleton<BaseApiServices>(NetworkApiServices.new);
    getIt.registerLazySingleton<LoginApiRepository>(LoginHttpApiRepository.new);
    getIt.registerLazySingleton<OTPApiRepository>(OTPHttpApiRepository.new);
  }
}
```

Called once in `main()` **after** `AppConfig.setup()`.

### Using getIt in repositories

```dart
class OTPHttpApiRepository implements OTPApiRepository {
  OTPHttpApiRepository() : _apiService = getIt<BaseApiServices>();
  final BaseApiServices _apiService;
}
```

### Using getIt in providers

```dart
class LoginProvider extends ChangeNotifier {
  final LoginApiRepository _loginRepository = getIt<LoginApiRepository>();
  final OTPApiRepository   _otpRepository   = getIt<OTPApiRepository>();
}
```

---

## 5. main.dart & app.dart

### `main.dart`

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();   // bypass SSL in dev

  // 1. Read native flavor
  String flavor = 'MOCK';
  try {
    flavor = await MethodChannel('flavor').invokeMethod('getFlavor') ?? 'MOCK';
  } catch (_) { /* fallback */ }

  // 2. Configure AppConfig + AppEnvironment
  switch (flavor.toUpperCase()) {
    case 'PROD': startPROD(); break;
    case 'UAT':  startUAT();  break;
    case 'DEV':  startDEV();  break;
    default:     startMOCK(); break;
  }

  // 3. Register repositories in get_it
  setupLocator();

  runApp(const BookSatsangApp());
}
```

### `app.dart`

```dart
class BookSatsangApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: RoutesName.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
```

---

## 6. Routes

### `configs/routes/routes_name.dart`

```dart
class RoutesName {
  static const String login = '/';
  static const String otp   = '/otp';
  static const String home  = '/home';
}
```

### `configs/routes/routes.dart` — per-route providers

```dart
case RoutesName.login:
  return MaterialPageRoute(
    builder: (_) => ChangeNotifierProvider<LoginProvider>(
      create: (_) => LoginProvider(),
      child: const LoginPage(),
    ),
  );
```

Providers are scoped to their route — they are created when the route is pushed and disposed when it is popped. No `MultiProvider` at the root.

---

## 7. Network Layer

### API Services

| Class | When used |
|-------|-----------|
| `MockApiServices` | MOCK flavor — simulated delay, no real HTTP |
| `NetworkApiServices` | All live flavors — real HTTP via `http` package |

Both implement `BaseApiServices`:

```dart
abstract class BaseApiServices {
  Future<dynamic> get(String url, {Map<String, String>? headers});
  Future<dynamic> post(String url, {Map<String, String>? headers, dynamic body});
}
```

### API Paths — `network_module/network/api_path.dart`

```dart
enum ApiPath { isUserExist, sendOtp, resendOtp, verifyOtp }

ApiPathHelper.getValue(ApiPath.sendOtp)
// → 'https://api.dev.com/Auth/SendOTP'
```

---

## 8. Response Models

### `BaseApiResponse<T>` — `network_module/response/base_api_response.dart`

Generic envelope that every API response uses.

```json
{
  "data": 1,
  "currentPage": 0, "totalCount": 0, "pageSize": 0,
  "totalPages": 0, "previousPage": null, "nextPage": null,
  "message": "OTP sent successfully.",
  "validationMessages": [],
  "isSuccessful": true,
  "isBusinessError": false,
  "isSystemError": false,
  "systemErrorMessage": null,
  "businessErrorMessage": null
}
```

```dart
BaseApiResponse<T>.fromJson(json, (d) => d as T)   // parse
bool get isOk => isSuccessful == true && data != null
BaseApiResponse.success(data: 1, message: '...')   // mock factory
BaseApiResponse.failure(message: '...')            // mock factory
```

### Module-level response models (typedef pattern)

```dart
// modules/otp/models/otp_response_model.dart
typedef OTPResponseModel = BaseApiResponse<int>;

OTPResponseModel otpResponseFromJson(Map<String, dynamic> json) =>
    OTPResponseModel.fromJson(json, (d) => d as int);
```

```dart
// modules/login/models/login_response_model.dart
typedef LoginResponseModel = BaseApiResponse<int>;

LoginResponseModel loginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponseModel.fromJson(json, (d) => d as int);
```

For a new module with a custom data model:

```dart
typedef HomeResponseModel = BaseApiResponse<List<VoterModel>>;

HomeResponseModel homeResponseFromJson(Map<String, dynamic> json) =>
    HomeResponseModel.fromJson(
      json,
      (d) => (d as List).map((e) => VoterModel.fromJson(e)).toList(),
    );
```

### `ApiResponse<T>` — UI state wrapper

Lives in `network_module/response/api_response.dart`. Used **only inside providers** to track async state.

```dart
enum Status { loading, completed, error }

class ApiResponse<T> {
  factory ApiResponse.loading([String? message]) { ... }
  factory ApiResponse.completed(T data)          { ... }
  factory ApiResponse.error(String message)      { ... }

  bool get isLoading   => status == Status.loading;
  bool get isCompleted => status == Status.completed;
  bool get isError     => status == Status.error;
}
```

Initial state: `ApiResponse.completed(0)` — `data: 0` means "not yet triggered".

---

## 9. Repository Pattern (Per Module)

Every module gets **4 files** in `modules/<module>/repository/`:

| File | Purpose |
|------|---------|
| `<module>_api_repository.dart` | Abstract contract |
| `<module>_mock_api_repository.dart` | Mock — hardcoded delay + data |
| `<module>_http_api_repository.dart` | HTTP — uses `getIt<BaseApiServices>()` |
| `<module>_repository.dart` | Barrel export |

Repository methods take `Map<String, String>` body and return a nullable response model:

```dart
abstract class OTPApiRepository {
  Future<OTPResponseModel?> sendOTP(Map<String, String> body);
  Future<OTPResponseModel?> resendOTP(Map<String, String> body);
  Future<OTPResponseModel?> verifyOTP(Map<String, String> body);
}
```

### Mock repository example

```dart
class OTPMockApiRepository implements OTPApiRepository {
  @override
  Future<OTPResponseModel?> verifyOTP(Map<String, String> body) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (body['otp'] == AppConstants.mockOtp) {
      return OTPResponseModel.success(data: 1, message: 'OTP verified.');
    }
    return OTPResponseModel.failure(message: 'Invalid OTP.');
  }
}
```

### HTTP repository example

```dart
class OTPHttpApiRepository implements OTPApiRepository {
  OTPHttpApiRepository() : _apiService = getIt<BaseApiServices>();
  final BaseApiServices _apiService;

  @override
  Future<OTPResponseModel?> sendOTP(Map<String, String> body) async {
    final json = await _apiService.post(
      ApiPathHelper.getValue(ApiPath.sendOtp),
      body: body,
    );
    return otpResponseFromJson(json as Map<String, dynamic>);
  }
}
```

---

## 10. Provider Pattern

### Structure

```dart
class LoginProvider extends ChangeNotifier with LoginValidator {
  // 1. Inject repositories via getIt
  final LoginApiRepository _loginRepository = getIt<LoginApiRepository>();
  final OTPApiRepository   _otpRepository   = getIt<OTPApiRepository>();

  // 2. RxDart subjects for validation streams
  final BehaviorSubject<String> mobileNumberSubject = BehaviorSubject();
  final BehaviorSubject<bool>   termAcceptCheck     = BehaviorSubject();
  final TextEditingController   mobileNumberCon     = TextEditingController();

  // 3. UI state (triggers Selector rebuilds via notifyListeners)
  ApiResponse<int> sendOtpResponse = ApiResponse.completed(0);

  // 4. Validation streams (feed StreamBuilder widgets)
  Stream<String> mobileStream() =>
      mobileNumberSubject.stream.transform(validateMobNum());
  Stream<bool> isValidForSent() => Rx.combineLatest2(
        mobileNumberSubject,
        termAcceptCheck.startWith(false),
        (mobile, terms) => RegExp(r'^\d{10}$').hasMatch(mobile) && terms,
      );

  // 5. Actions
  Future<void> sendOtp(BuildContext context) async { ... }

  // 6. Always dispose
  @override
  void dispose() {
    mobileNumberSubject.close();
    termAcceptCheck.close();
    mobileNumberCon.dispose();
    super.dispose();
  }
}
```

### Login flow — isUserExist → sendOTP

```dart
Future<void> sendOtp(BuildContext context) async {
  // Step 1 — check user exists
  sendOtpResponse = ApiResponse.loading('Checking user...');
  notifyListeners();

  bool userExists = false;
  await _loginRepository.isUserExist({'mobileNo': mobile}).then((value) {
    if (value != null && value.isSuccessful == true && value.data == 1) {
      userExists = true;
    } else {
      sendOtpResponse = ApiResponse.error(value?.message ?? 'Not registered.');
    }
  }).onError((error, _) {
    sendOtpResponse = ApiResponse.error(error.toString());
  });

  if (!userExists) { notifyListeners(); return; }

  // Step 2 — send OTP
  sendOtpResponse = ApiResponse.loading('Sending OTP...');
  notifyListeners();

  await _otpRepository.sendOTP({'mobileNo': mobile}).then((value) async {
    if (value != null && value.isSuccessful == true && value.data == 1) {
      sendOtpResponse = ApiResponse.completed(value.data!);
      if (context.mounted) Navigator.pushNamed(context, RoutesName.otp, arguments: mobile);
    } else {
      sendOtpResponse = ApiResponse.error(value?.message ?? 'Failed.');
    }
  }).onError((error, _) => sendOtpResponse = ApiResponse.error(error.toString()));

  notifyListeners();
}
```

---

## 11. UI Rebuild Rules

| Widget type | Use |
|------------|-----|
| Depends on `notifyListeners()` state | `Selector<Provider, T>` |
| Depends on RxDart stream (validation) | `StreamBuilder<T>` |
| One-time action / stable read | `context.loginProvider` (extension) |

**Never** put a stream inside `Selector`. `Selector` only responds to `notifyListeners()`.

### Send OTP button (nested pattern)

```dart
StreamBuilder<bool>(                          // outer: form validity stream
  stream: loginProvider.isValidForSent(),
  builder: (context, snapshot) {
    final canSend = snapshot.hasData && snapshot.data == true;

    return Selector<LoginProvider, bool>(     // inner: loading state
      selector: (_, p) => p.sendOtpResponse.isLoading,
      builder: (context, isLoading, child) => ElevatedButton(
        onPressed: canSend && !isLoading
            ? () => context.loginProvider.sendOtp(context)
            : null,
        child: isLoading ? const Text('Sending...') : child!,
      ),
      child: const Text('Send OTP'),
    );
  },
);
```

### Login page widget rebuild table

| Widget | Rebuilds when |
|--------|---------------|
| `LoginHeader` | Never (static) |
| `LoginMobileField` | Mobile validation stream → error border |
| `LoginMobileInput` | Never (controller-driven, no stream) |
| `TermsCheckbox` | `termStream()` changes |
| `TermLabelButton` | Never (static text) |
| `SendOtpButton` outer | `isValidForSent()` stream |
| `SendOtpButton` inner | `sendOtpResponse.isLoading` via `notifyListeners()` |

### Error border pattern

The **outer container** owns the error indicator, not the inner `TextFormField`:

```dart
// login_mobile_field.dart
StreamBuilder<String>(
  stream: loginProvider.mobileStream(),
  builder: (context, snapshot) {
    final hasError = snapshot.hasError;
    return Container(
      decoration: BoxDecoration(
        border: hasError
            ? Border.all(color: Colors.red, width: 2.5)
            : Border.all(color: Colors.transparent, width: 2.5),
      ),
      child: Row([ Icon(color: hasError ? Colors.red : Colors.orange), ... ]),
    );
  },
);
```

### OTP auto-verify (no button)

```dart
OtpPinInput(
  onCompleted: (pin) {
    if (pin.length == AppConstants.otpLength) {
      context.otpProvider.verifyOtp(context, pin);
    }
  },
),
```

---

## 12. Responsive Extension

All sizes use `ResponsiveExtension` from `utils/extensions/responsive_extension.dart`. Never use `MediaQuery.of(context).size` directly.

| Method | Use |
|--------|-----|
| `context.wp(10)` | 10% of screen **width** |
| `context.hp(5)` | 5% of screen **height** |
| `context.sp(4)` | Responsive **font size**, clamped 12–34 |
| `context.adaptiveSize(16)` | Scales phone size up for tablet/desktop |
| `context.isPhone` / `context.isTablet` | Device class check |

```dart
// Before
fontSize: size.width * 0.04,
padding: EdgeInsets.all(size.width * 0.02),

// After
fontSize: context.sp(4),
padding: EdgeInsets.all(context.wp(2)),
```

---

## 13. Context Extensions

```dart
// modules/login/extensions/login_provider_extension.dart
extension LoginProviderExtension on BuildContext {
  LoginProvider get loginProvider => read<LoginProvider>();
}

// modules/otp/extensions/otp_provider_extension.dart
extension OtpProviderExtension on BuildContext {
  OtpProvider get otpProvider => read<OtpProvider>();
}
```

Use for **actions and one-time reads only** — not for reactive UI (use `Selector` / `StreamBuilder` for those).

---

## 14. Validators (RxDart mixin)

```dart
// modules/login/validators/login_validator.dart
mixin LoginValidator {
  StreamTransformer<String, String> validateMobNum() =>
      StreamTransformer.fromHandlers(handleData: (mobile, sink) {
        if (mobile.isEmpty) {
          sink.addError('Mobile number should not be empty.');
        } else if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
          sink.addError('Enter a valid 10-digit mobile number.');
        } else {
          sink.add(mobile);
        }
      });

  StreamTransformer<bool, bool> validateTC() =>
      StreamTransformer.fromHandlers(handleData: (accepted, sink) {
        if (accepted) sink.add(accepted);
        else sink.addError('Please accept the terms.');
      });
}
```

---

## 15. Mock Testing

| Item | Value |
|------|-------|
| Flavor | MOCK |
| Any mobile number | Treated as registered (`isUserExist` always returns `data: 1`) |
| OTP to enter | `123456` |
| OTP length | 4 digits |
| Timer | 30 seconds |
| Success condition | `isSuccessful: true` and `data: 1` |

---

## 16. New Module Checklist

1. Create `lib/modules/<module>/` with `models/`, `repository/`, `providers/`, `widgets/`, `extensions/`, `pages/`
2. Add **response model** in `modules/<module>/models/` — typedef on `BaseApiResponse<T>`
3. Add endpoints to `ApiPath` enum in `network_module/network/api_path.dart`
4. Create **4 repository files**: abstract, mock, http, barrel
5. Register in `dependency_injection/locator.dart`
6. Create **provider** extending `ChangeNotifier`, inject repos via `getIt`, use `ApiResponse<T>` for UI state
7. Build UI with split widgets — `StreamBuilder` for streams, `Selector` for `notifyListeners()` state
8. Add `context.<module>Provider` extension
9. Add route in `configs/routes/routes_name.dart` + `configs/routes/routes.dart` with per-route `ChangeNotifierProvider`
10. Run `flutter analyze --no-pub` — must be zero issues

---

## 17. Flavors

| Flavor | Environment | `AppEnvironment.isMock` | Base URL |
|--------|------------|------------------------|----------|
| MOCK | `AppEnvironmentType.mock` | `true` | `http://localhost:3000` |
| DEV | `AppEnvironmentType.live` | `false` | `https://api.dev.com` |
| UAT | `AppEnvironmentType.live` | `false` | `https://api.uat.com` |
| PROD | `AppEnvironmentType.live` | `false` | `https://api.production.com` |

`AppEnvironment.isMock` is the **single source of truth** — used by `setupLocator()` to choose mock vs HTTP implementations.

---

## 18. Running the App

```powershell
# Launch emulator
flutter emulators --launch Medium_Phone_API_36.1

# Check connected devices
flutter devices

# Run with flavor
flutter run --flavor MOCK
flutter run --flavor DEV
```

### `.vscode/launch.json`

```json
{
  "configurations": [
    {
      "name": "MOCK",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "toolArgs": ["--flavor", "MOCK"]
    },
    {
      "name": "DEV",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "toolArgs": ["--flavor", "DEV"]
    }
  ]
}
```

---

## 19. Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1
  rxdart: ^0.28.0
  pinput: ^6.0.2
  http: ^1.2.2
  get_it: ^8.0.3
```

---

## 20. Key Rules (Quick Reference)

| Rule | Detail |
|------|--------|
| Providers scoped per-route | Wrap in `ChangeNotifierProvider` inside `Routes.generateRoute` |
| DI via getIt | Always `getIt<T>()` — never `new Repository()` directly |
| Mock vs HTTP | Decided once in `setupLocator()` via `AppEnvironment.isMock` |
| Streams for validation | Use `StreamBuilder` + RxDart `BehaviorSubject` + `StreamTransformer` |
| `notifyListeners()` state | Use `Selector<Provider, T>` |
| Sizes | Always `context.wp()` / `context.hp()` / `context.sp()` — never raw `MediaQuery` |
| API success check | `value != null && value.isSuccessful == true && value.data == 1` |
| Request body | `Map<String, String>` — field names match JSON keys exactly (`mobileNo`) |
| Dispose | Always close `BehaviorSubject`s, cancel timers, dispose controllers |
| Home module | Placeholder only — no provider/repository yet |

---

*Last updated: June 17, 2026 — aligned with voter_reg + perfect_enterprises-dev architecture.*
