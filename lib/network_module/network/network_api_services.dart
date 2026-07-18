import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

import '../../configs/components/app_flushbar.dart';
import '../../configs/routes/app_navigator.dart';
import '../../configs/routes/routes_name.dart';
import '../../dependency_injection/locator.dart';
import '../../services/auth/auth_service.dart';
import '../../services/connectivity/connectivity_service.dart';
import '../exception/app_exceptions.dart';
import '../models/request_models/refresh_token_request_model.dart';
import '../models/response_models/refresh_token_response_model.dart';
import 'api_path.dart';
import 'base_api_services.dart';

/// Live HTTP client that attaches auth headers and handles token refresh.
///
/// On a 401 response, [NetworkApiServices] attempts a silent refresh via
/// [_performRefresh]. If refresh fails, [_handleSessionExpired] logs the user
/// out and shows a non-dismissible dialog before navigating to login.
class NetworkApiServices implements BaseApiServices {
  final AuthService _authService = getIt<AuthService>();
  final ConnectivityService _connectivityService = getIt<ConnectivityService>();

  /// Single auth-data instance shared across every network call. It is created
  /// lazily on first use and kept up to date after a token refresh.
  AuthData? _authData;

  /// Prevents showing the session-expired dialog more than once.
  bool _isHandlingSessionExpired = false;

  /// Prevents stacking multiple no-internet pages for concurrent API calls.
  bool _isHandlingNoInternet = false;

  /// Prevents spamming the access-restricted flushbar for concurrent 403s.
  bool _isShowingAccessRestricted = false;

  static const Duration _timeout = Duration(seconds: 20);

  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  Future<void> _ensureAuthData() async {
    _authData ??= await _authService.readAuthData();
  }

  /// Builds the `Authorization: Bearer` header from the cached access token.
  ///
  /// Returns an empty map when no token is stored.
  Map<String, String> _authHeader() {
    final token = _authData?.authToken;
    debugPrint('AUTH TOKEN: $token');
    debugPrint('REFRESH TOKEN: ${_authData?.refreshToken}');
    if (token != null && token.isNotEmpty) {
      return {'Authorization': 'Bearer $token'};
    }
    return const {};
  }

  /// Exchanges the stored refresh token for a new access/refresh token pair.
  ///
  /// Persists the new tokens via [AuthService] and updates [_authData].
  /// Returns `false` and triggers session expiry on 401.
  Future<bool> _performRefresh() async {
    final current = _authData;
    if (current == null || current.refreshToken.isEmpty) return false;
    try {
      if (kDebugMode) debugPrint('REFRESH TOKEN');
      final response = await http
          .post(
            Uri.parse(ApiPathHelper.getValue(ApiPath.refreshToken)),
            headers: {..._defaultHeaders, ..._authHeader()},
            body: jsonEncode(
              RefreshTokenRequestModel(
                refreshToken: current.refreshToken,
              ).toJson(),
            ),
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final refreshResponse = refreshTokenResponseFromJson(
          jsonDecode(response.body),
        );
        final String? accessToken = refreshResponse.data?.accessToken;
        final String? refreshToken = refreshResponse.data?.refreshToken;
        if (accessToken == null || refreshToken == null) return false;

        final newAuthData = AuthData(
          authToken: accessToken,
          refreshToken: refreshToken,
        );
        await _authService.storeAuthData(newAuthData);
        _authData = newAuthData;
        return true;
      }
      if (response.statusCode == 401) {
        await _handleSessionExpired();
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Clears auth state and prompts the user to log in again.
  ///
  /// Shows a blocking "Session Expired" dialog, then navigates to the login
  /// screen. Guarded by [_isHandlingSessionExpired] to avoid duplicate dialogs.
  Future<void> _handleSessionExpired() async {
    if (_isHandlingSessionExpired) return;
    _isHandlingSessionExpired = true;

    _authData = null;
    await _authService.logout();

    final context = AppNavigator.context;
    if (context == null || !context.mounted) {
      _isHandlingSessionExpired = false;
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Session Expired'),
            content: const Text(
              'Your session has expired. Please login again.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  AppNavigator.state?.pushNamedAndRemoveUntil(
                    RoutesName.login,
                    (route) => false,
                  );
                  _isHandlingSessionExpired = false;
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows an error flushbar for HTTP 403 responses.
  ///
  /// Uses [AppNavigator] so the message can appear without a widget-local
  /// [BuildContext]. Scheduled after the current frame so the root overlay is
  /// available. Guarded to avoid duplicate bars for concurrent failures.
  void _showAccessRestrictedFlushbar() {
    if (_isShowingAccessRestricted) return;

    final NavigatorState? navigator = AppNavigator.state;
    if (navigator == null) return;

    final BuildContext context = navigator.overlay?.context ?? navigator.context;
    if (!context.mounted) return;

    _isShowingAccessRestricted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        _isShowingAccessRestricted = false;
        return;
      }
      AppFlushbar.error(context, message: 'Access Restricted.');
      Future<void>.delayed(const Duration(seconds: 3), () {
        _isShowingAccessRestricted = false;
      });
    });
  }

  /// Verifies internet reachability before an API call.
  ///
  /// When offline, navigates to [RoutesName.noInternet] and throws
  /// [NoInternetException] so the request is not sent.
  Future<void> _ensureInternetConnection() async {
    final bool hasConnection =
        await _connectivityService.hasInternetConnection();
    if (hasConnection) return;

    await _handleNoInternet();
    throw const NoInternetException();
  }

  /// Pushes the no-internet page once via [AppNavigator].
  ///
  /// Skips navigation when the navigator is unavailable or the top route is
  /// already [RoutesName.noInternet]. Does not wait for the page to be popped
  /// so callers can throw [NoInternetException] immediately.
  Future<void> _handleNoInternet() async {
    if (_isHandlingNoInternet) return;
    _isHandlingNoInternet = true;

    final NavigatorState? navigator = AppNavigator.state;
    if (navigator == null) {
      _isHandlingNoInternet = false;
      return;
    }

    final String? currentRoute =
        ModalRoute.of(navigator.context)?.settings.name;
    if (currentRoute == RoutesName.noInternet) {
      _isHandlingNoInternet = false;
      return;
    }

    unawaited(
      navigator.pushNamed(RoutesName.noInternet).whenComplete(() {
        _isHandlingNoInternet = false;
      }),
    );
  }

  /// Sends an authenticated GET request with automatic token refresh on 401.
  ///
  /// Merges [_defaultHeaders], optional [headers], and [_authHeader].
  /// [queryParams] are appended to the request URI.
  @override
  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    await _ensureInternetConnection();
    await _ensureAuthData();
    if (kDebugMode) debugPrint('GET $url');
    try {
      var uri = Uri.parse(url);
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(
          queryParameters: {
            ...uri.queryParameters,
            ...queryParams.map((key, value) => MapEntry(key, value.toString())),
          },
        );
      }
      Future<http.Response> send() => http
          .get(
            uri,
            headers: {..._defaultHeaders, ...?headers, ..._authHeader()},
          )
          .timeout(_timeout);

      var response = await send();
      if (response.statusCode == 401 && await _performRefresh()) {
        response = await send();
      }
      return _handleResponse(response);
    } on SocketException {
      await _handleNoInternet();
      throw const NoInternetException();
    } on TimeoutException {
      throw const FetchDataException('Network request timed out.');
    }
  }

  /// Sends an authenticated POST request with automatic token refresh on 401.
  ///
  /// Encodes [body] as JSON unless it is already a [String].
  @override
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    await _ensureInternetConnection();
    await _ensureAuthData();
    if (kDebugMode) {
      debugPrint('POST $url');
      debugPrint('BODY: $body');
    }
    try {
      Future<http.Response> send() => http
          .post(
            Uri.parse(url),
            headers: {..._defaultHeaders, ...?headers, ..._authHeader()},
            body: body is String ? body : jsonEncode(body),
          )
          .timeout(_timeout);

      var response = await send();
      if (response.statusCode == 401 && await _performRefresh()) {
        response = await send();
      }
      return _handleResponse(response);
    } on SocketException {
      await _handleNoInternet();
      throw const NoInternetException();
    } on TimeoutException {
      throw const FetchDataException('Network request timed out.');
    } on AppException {
      rethrow;
    } catch (err) {
      debugPrint(err.toString());
      throw FetchDataException(err.toString());
    }
  }

  /// Uploads a file via multipart POST with auth headers and token refresh.
  ///
  /// Retries once after a successful refresh on 401. Invokes [onProgress]
  /// with bytes sent and total file size when provided.
  @override
  Future<dynamic> uploadFile(
    String url, {
    required String filePath,
    required String fieldName,
    required String serverFileName,
    Map<String, String>? headers,
    Map<String, String>? additionalFields,
    void Function(int sent, int total)? onProgress,
  }) async {
    await _ensureInternetConnection();
    await _ensureAuthData();
    try {
      final File file = File(filePath);
      if (!file.existsSync()) {
        throw FetchDataException('File not found: $filePath');
      }

      final String? mimeType = lookupMimeType(filePath);
      final List<String> mimeTypeParts =
          (mimeType ?? 'application/octet-stream').split('/');

      final int totalBytes = await file.length();

      Future<http.StreamedResponse> send() async {
        final http.MultipartRequest request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );

        request.headers['accept'] = '*/*';
        request.headers.addAll(_authHeader());

        if (headers != null) {
          request.headers.addAll(headers);
        }

        if (additionalFields != null) {
          request.fields.addAll(additionalFields);
        }

        final http.MultipartFile multipartFile;
        if (onProgress != null) {
          int bytesSent = 0;
          Stream<List<int>> trackedUploadStream() async* {
            await for (final chunk in file.openRead()) {
              bytesSent += chunk.length;
              onProgress(bytesSent, totalBytes);
              yield chunk;
            }
          }

          multipartFile = http.MultipartFile(
            fieldName,
            trackedUploadStream(),
            totalBytes,
            filename: serverFileName,
            contentType: mimeType != null
                ? http.MediaType(mimeTypeParts[0], mimeTypeParts[1])
                : null,
          );
        } else {
          multipartFile = await http.MultipartFile.fromPath(
            fieldName,
            filePath,
            filename: serverFileName,
            contentType: mimeType != null
                ? http.MediaType(mimeTypeParts[0], mimeTypeParts[1])
                : null,
          );
        }

        request.files.add(multipartFile);
        return request.send();
      }

      http.StreamedResponse response = await send();
      if (response.statusCode == 401 && await _performRefresh()) {
        response = await send();
      }

      final responseBytes = <int>[];
      await for (final chunk in response.stream) {
        responseBytes.addAll(chunk);
      }
      final String responseBody = utf8.decode(responseBytes);

      if (kDebugMode) {
        debugPrint('UPLOAD STATUS: ${response.statusCode}');
        debugPrint('UPLOAD BODY: $responseBody');
      }

      switch (response.statusCode) {
        case 200:
        case 400:
          return jsonDecode(responseBody);
        case 401:
          throw UnauthorisedException(responseBody);
        case 403:
          _showAccessRestrictedFlushbar();
          throw const ForbiddenException();
        case 405:
          throw MethodNotAllowedException(responseBody);
        case 404:
        case 500:
          throw BadRequestException(responseBody);
        default:
          throw FetchDataException(
            'Error communicating with server (${response.statusCode}).',
          );
      }
    } on SocketException {
      await _handleNoInternet();
      throw const NoInternetException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchDataException('Error uploading file: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (kDebugMode) {
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 400:
        return jsonDecode(response.body);
      case 401:
        throw UnauthorisedException(response.body);
      case 403:
        _showAccessRestrictedFlushbar();
        throw const ForbiddenException();
      case 405:
        throw MethodNotAllowedException(response.body);
      case 404:
      case 500:
        throw BadRequestException(response.body);
      default:
        throw FetchDataException(
          'Error communicating with server (${response.statusCode}).',
        );
    }
  }
}
