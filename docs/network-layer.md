# Network Layer

## Purpose

This document covers the API client setup, response handling, model conventions, and repository pattern used across the app.

Training deliverable: ApiClient ready, model parsing works.

## Architecture Overview

```
Provider -> Repository (abstract) -> Http or Mock implementation -> BaseApiServices
```

Repositories are injected via get_it. Providers call repositories and map results into ApiResponse state for the UI.

## Base API Services

Contract: lib/network_module/network/base_api_services.dart

Methods:

- get(url, {queryParams, headers})
- post(url, body, {headers})
- uploadFile(url, file, fieldName)

### Live implementation

File: lib/network_module/network/network_api_services.dart

Behavior:

- Uses http package with 20 second timeout
- Reads auth token from AuthService and adds Bearer header
- On 401, attempts token refresh via POST /Member/GetRefreshToken
- Refresh failure shows session expired dialog and navigates to login via AppNavigator
- Parses JSON into BaseApiResponse

### Mock implementation

File: lib/network_module/network/mock_api_services.dart

Returns stub responses with a short delay. Feature-level mock repositories provide richer scenario data than this base class.

## API Paths

Central enum: lib/network_module/network/api_path.dart

ApiPath.getValue(path) builds the full URL using AppConfig.apiBaseUrl.

Key endpoints:

| ApiPath | Endpoint |
|---------|----------|
| isUserExist | /Member/MobileExists |
| sendOtp | /OTP/SendOTP |
| verifyOtp | /OTP/VerifyOTP |
| memberLogin | /Member/VerifyLogin |
| registerMember | /Member/AddMember |
| fetchMemberProfile | /Member/GetMemberByToken |
| fetchSatsang | /Satsang/GetSatsang |
| fetchDesignation | /MasterData/GetDesignationMasterData |
| fetchTaluka | /MasterData/GetTalukaMasterData |
| fetchVillage | /MasterData/GetVillageMasterData |
| uploadFile | /FileHandling/UploadFile |
| refreshToken | /Member/GetRefreshToken |
| logout | /Member/VerifyLogout |

Add new paths here before implementing repository methods.

## Response Models

### Server envelope

lib/network_module/response/base_api_response.dart

Fields: isSuccessful, data, message, validationMessages, pagination fields where applicable.

### UI state wrapper

lib/network_module/response/api_response.dart

Status enum: idle, loading, completed, error

Usage in providers:

```
apiState = ApiResponse.loading('Loading...');
notifyListeners();
// after call
apiState = ApiResponse.completed(data);
// or
apiState = ApiResponse.error(message);
```

UI checks apiState.isLoading, isError, isCompleted.

## Request and Response Model Pattern

Each module keeps models under models/request_models/ and models/response_models/.

Standard steps to add a model:

1. Create request class with fields matching API doc
2. Add toJson method for POST bodies
3. Create response class with fromJson factory
4. Handle nullable fields defensively

Example flow for login:

LoginProvider builds UserExistRequestModel -> LoginHttpApiRepository.isUserExist -> parses UserExistResponseModel.

## Repository Pattern

Each feature has:

- feature_api_repository.dart -- abstract class
- feature_http_api_repository.dart -- live calls
- feature_mock_api_repository.dart -- training and offline use
- feature_repository.dart -- barrel export

HTTP repositories resolve getIt BaseApiServices in constructor or method.

Mock repositories return hardcoded success responses matching real model shapes.

## SSL Override

lib/network_module/network/my_http_overrides.dart accepts all certificates.

Set in main.dart via HttpOverrides.global. Required for some DEV servers. Remove or restrict before production.

## Step-by-Step: Integrate a New API

1. Add ApiPath entry
2. Create request and response models
3. Add method to abstract repository
4. Implement in HTTP and mock repository classes
5. Register if new repository type, or extend existing registration in locator.dart
6. Call from provider, wrap in ApiResponse loading and completed states
7. Bind UI with Selector or StreamBuilder

## Tests and Checks

| Check | How |
|-------|-----|
| Model parsing | Call mock repository from MOCK flavor, inspect completed data in UI or debug |
| Live API | DEV flavor, confirm requests hit AppConfig.apiBaseUrl in debug log |
| Auth header | After login, profile fetch should succeed without manual token handling |
| 401 handling | Expire token manually in storage and trigger an API call |

## Common Issues

**type Null is not a subtype**

Response JSON shape differs from model. Compare raw JSON with fromJson fields.

**API returns validationMessages**

Some providers only read message. Check validationMessages array for field-level errors.

**Mock works, live fails**

Compare request body casing and field names with API documentation. Check base URL flavor.

**Timeout after 20 seconds**

NetworkApiServices uses a fixed timeout. Slow endpoints may need adjustment.

## Notes for Future Developers

- Never call http directly from widgets or providers. Always go through repositories.
- Keep mock responses in sync when API contracts change. Training candidates rely on MOCK flavor.
- Profile update API is not in ApiPath yet. Add endpoint when backend is ready.

See authentication.md for auth-specific API usage and error-handling.md for how errors surface in the UI.
