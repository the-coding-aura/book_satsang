import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Delegates to [openAppSettings] from permission_handler. A class method with
/// the same name would recurse; keep this at library scope.
Future<bool> _openPermissionHandlerAppSettings() => openAppSettings();

/// Runtime permissions requested before camera, gallery, or file access.
enum PermissionType {
  /// Permission to capture photos with the device camera.
  camera,

  /// Permission to read images from the photo gallery.
  gallery,

  /// Permission to read files from device storage.
  files,
}

/// Requests and inspects platform permissions for media and file access.
///
/// Handles Android API-level differences for photos and storage scopes.
class PermissionService {
  /// Requests camera permission and returns whether it was granted.
  ///
  /// Does not open system settings when the user denies the request.
  Future<bool> requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Requests gallery permission using the API level-appropriate permission.
  ///
  /// Android 13+ uses [Permission.photos]; earlier versions use
  /// [Permission.storage].
  Future<bool> requestGalleryPermission() async {
    if (await _isAndroid13OrHigher()) {
      final PermissionStatus status = await Permission.photos.request();
      return status.isGranted;
    } else {
      final PermissionStatus status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  /// Requests file access permission when required by the platform.
  ///
  /// Android 13+ typically does not require a separate permission for scoped
  /// storage used by the file picker.
  Future<bool> requestFileAccessPermission() async {
    if (await _isAndroid13OrHigher()) {
      // Android 13+ doesn't require special permission for file_picker
      // when using scoped storage (which file_picker does by default)
      return true;
    } else if (await _isAndroid11OrHigher()) {
      // For Android 11-12, try storage permission first
      // file_picker uses scoped storage which doesn't require special permission
      // But for compatibility, we check storage permission
      final PermissionStatus status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      }
      // Request storage permission
      final PermissionStatus requestStatus = await Permission.storage.request();
      return requestStatus.isGranted;
    } else {
      // Android 10 and below
      final PermissionStatus status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  /// Returns whether camera permission is currently granted.
  Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.isGranted;
  }

  /// Returns whether gallery permission is currently granted.
  ///
  /// Uses photos permission on Android 13+ and storage on older versions.
  Future<bool> isGalleryPermissionGranted() async {
    if (await _isAndroid13OrHigher()) {
      return await Permission.photos.isGranted;
    } else {
      return await Permission.storage.isGranted;
    }
  }

  /// Returns whether file access is allowed on the current platform.
  ///
  /// Always returns true on Android 13+ where scoped storage applies.
  Future<bool> isFileAccessPermissionGranted() async {
    if (await _isAndroid13OrHigher()) {
      return true; // No special permission needed
    } else {
      return await Permission.storage.isGranted;
    }
  }

  /// Opens the app settings screen so the user can enable denied permissions.
  ///
  /// Useful when a permission is permanently denied.
  Future<void> openAppSettings() async {
    await _openPermissionHandlerAppSettings();
  }

  /// Returns whether [type] was permanently denied by the user.
  ///
  /// File access on Android 13+ is never considered permanently denied.
  Future<bool> isPermissionPermanentlyDenied(PermissionType type) async {
    Permission permission;
    switch (type) {
      case PermissionType.camera:
        permission = Permission.camera;
        break;
      case PermissionType.gallery:
        permission = await _isAndroid13OrHigher()
            ? Permission.photos
            : Permission.storage;
        break;
      case PermissionType.files:
        if (await _isAndroid13OrHigher()) {
          return false; // No permission needed
        }
        permission = Permission.storage;
        break;
    }
    return await permission.isPermanentlyDenied;
  }

  /// Helper method to check if device is running Android 13 or higher
  Future<bool> _isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 33; // Android 13 = API 33
    } catch (e) {
      // Fallback: if device_info fails, assume lower version for safety
      return false;
    }
  }

  /// Helper method to check if device is running Android 11 or higher
  Future<bool> _isAndroid11OrHigher() async {
    if (!Platform.isAndroid) return false;
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 30; // Android 11 = API 30
    } catch (e) {
      // Fallback: if device_info fails, assume lower version for safety
      return false;
    }
  }

  /// Requests [type] and returns a [PermissionResult] with status and message.
  ///
  /// Sets [PermissionResult.isPermanentlyDenied] when the user must use
  /// settings to re-enable the permission.
  Future<PermissionResult> requestPermission(PermissionType type) async {
    try {
      bool isGranted = false;
      String permissionName = '';

      switch (type) {
        case PermissionType.camera:
          isGranted = await requestCameraPermission();
          permissionName = 'Camera';
          break;
        case PermissionType.gallery:
          isGranted = await requestGalleryPermission();
          permissionName = 'Gallery';
          break;
        case PermissionType.files:
          isGranted = await requestFileAccessPermission();
          permissionName = 'File Access';
          break;
      }

      if (isGranted) {
        return PermissionResult(
          isGranted: true,
          message: '$permissionName permission granted',
        );
      } else {
        final bool isPermanentlyDenied =
            await isPermissionPermanentlyDenied(type);
        if (isPermanentlyDenied) {
          return PermissionResult(
            isGranted: false,
            isPermanentlyDenied: true,
            message:
                '$permissionName permission permanently denied. Please enable it in app settings.',
          );
        } else {
          return PermissionResult(
            isGranted: false,
            message: '$permissionName permission denied',
          );
        }
      }
    } catch (e) {
      return PermissionResult(
        isGranted: false,
        message: 'Error requesting permission: $e',
      );
    }
  }
}

/// Result of a [PermissionService.requestPermission] call.
///
/// Includes grant status, an optional permanent-denial flag, and a message.
class PermissionResult {
  /// Creates a permission result with the given status and [message].
  const PermissionResult({
    required this.isGranted,
    required this.message,
    this.isPermanentlyDenied = false,
  });

  /// Whether the requested permission is granted.
  final bool isGranted;

  /// Human-readable outcome or error message for the request.
  final String message;

  /// Whether the user must open app settings to grant the permission.
  final bool isPermanentlyDenied;
}
