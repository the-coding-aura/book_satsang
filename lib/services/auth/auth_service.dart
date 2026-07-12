import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists and retrieves authentication tokens using secure device storage.
///
/// Use [storeAuthData], [readAuthData], and [logout] to manage the active
/// session across app launches.
class AuthService {
  /// Secure storage instance used for reading and writing auth credentials.
  final storage = FlutterSecureStorage();

  /// Storage key under which serialized [AuthData] is saved.
  final String authKey = "authKey";

  /// Writes the given [data] to secure storage as a JSON string.
  ///
  /// Replaces any previously stored session for [authKey].
  Future storeAuthData(AuthData data) async {
    await storage.write(key: authKey, value: data.toJsonString());
  }

  /// Reads the stored session, if one exists.
  ///
  /// Returns `null` when no auth data has been saved or the key is missing.
  Future<AuthData?> readAuthData() async {
    var authData = await storage.read(key: authKey);
    return authData != null ? AuthData.fromJsonString(authData) : null;
  }

  /// Clears persisted auth data and ends the local session.
  ///
  /// Does not invalidate tokens on the server.
  Future<void> logout() async {
    await storage.delete(key: authKey);
  }
}

/// Immutable authentication payload returned after a successful login.
///
/// Contains access and refresh tokens used for authorized API requests.
class AuthData {
  /// Bearer token sent with authenticated API calls.
  final String authToken;

  /// Token used to obtain a new [authToken] when it expires.
  final String refreshToken;

  /// Creates auth data with the required [authToken] and [refreshToken].
  AuthData({required this.authToken, required this.refreshToken});

  /// Converts this instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {'authToken': authToken, 'refreshToken': refreshToken};
  }

  /// Creates [AuthData] from a JSON map produced by [toJson].
  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      authToken: json['authToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  /// Encodes this instance as a JSON string for secure storage.
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Decodes [jsonString] into [AuthData].
  ///
  /// Expects the format produced by [toJsonString].
  factory AuthData.fromJsonString(String jsonString) {
    return AuthData.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
