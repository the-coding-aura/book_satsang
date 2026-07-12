import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import '../../utils/bootstrap/android_image_picker_config.dart';

/// Identifies the source used when the user selects a file to upload.
enum FileSourceType {
  /// Image captured with the device camera.
  camera,

  /// Image chosen from the photo gallery.
  gallery,

  /// Document chosen via the system file picker.
  document,
}

/// Picks images and documents from the device and validates upload constraints.
///
/// Enforces a maximum file size and returns structured [FileUploadResult]
/// values for UI and upload flows.
class FileUploadService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Maximum allowed file size in bytes (5 MB).
  static const int maxFileSizeInBytes = 5 * 1024 * 1024; // 10 MB

  /// Maximum allowed file size in megabytes, used in user-facing messages.
  static const double maxFileSizeInMB = 5.0;

  /// Opens the camera and returns a validated image [FileUploadResult].
  ///
  /// Returns a failure result when the user cancels or capture fails.
  Future<FileUploadResult> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) {
        return FileUploadResult(
          success: false,
          errorMessage: 'No image captured',
        );
      }

      final File file = File(image.path);
      return _validateAndCreateResult(file, preferredDisplayName: image.name);
    } catch (e) {
      return FileUploadResult(
        success: false,
        errorMessage: 'Error capturing image: $e',
      );
    }
  }

  /// Opens the gallery and returns a validated single-image [FileUploadResult].
  ///
  /// Gallery uses [ImagePicker]. Android Photo Picker is enabled in
  /// [configureAndroidImagePickerForSingleGalleryPick] from [main] and again
  /// here so the first gallery open matches later opens if startup ran before
  /// the plugin was ready.
  Future<FileUploadResult> pickImageFromGallery() async {
    try {
      configureAndroidImagePickerForSingleGalleryPick();

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) {
        return FileUploadResult(
          success: false,
          errorMessage: 'No image selected',
        );
      }

      final File file = File(image.path);
      return _validateAndCreateResult(file, preferredDisplayName: image.name);
    } catch (e) {
      return FileUploadResult(
        success: false,
        errorMessage: 'Error selecting image: $e',
      );
    }
  }

  /// Opens the file picker for supported document and image types.
  ///
  /// Allowed extensions include PDF, DOC, DOCX, JPG, JPEG, and PNG.
  Future<FileUploadResult> pickDocument() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return FileUploadResult(
          success: false,
          errorMessage: 'No file selected',
        );
      }

      final PlatformFile platformFile = result.files.first;
      if (platformFile.path == null) {
        return FileUploadResult(
          success: false,
          errorMessage: 'Invalid file path',
        );
      }

      final File file = File(platformFile.path!);
      return _validateAndCreateResult(
        file,
        preferredDisplayName: platformFile.name,
      );
    } catch (e) {
      return FileUploadResult(
        success: false,
        errorMessage: 'Error selecting file: $e',
      );
    }
  }

  /// Human-readable name for UI (not the temp path Android uses for scaled copies).
  static String _displayNameForUi(
    String filePath, {
    String? preferredDisplayName,
  }) {
    final String fromPicker = preferredDisplayName?.trim() ?? '';
    if (fromPicker.isNotEmpty) {
      return _stripScaledCachePrefix(fromPicker);
    }
    return _stripScaledCachePrefix(path.basename(filePath));
  }

  /// Removes `scaled_` / `Scaled-` style prefixes from gallery/camera cache paths.
  static String _stripScaledCachePrefix(String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return trimmed;
    final RegExp prefix = RegExp(
      r'^(scaled|resized)([_\-.])?',
      caseSensitive: false,
    );
    final String stripped = trimmed.replaceFirst(prefix, '');
    return stripped.isNotEmpty ? stripped : trimmed;
  }

  /// Validate file size and create result
  Future<FileUploadResult> _validateAndCreateResult(
    File file, {
    String? preferredDisplayName,
  }) async {
    try {
      final int fileSize = await file.length();

      if (fileSize > maxFileSizeInBytes) {
        final double fileSizeInMB = fileSize / (1024 * 1024);
        return FileUploadResult(
          success: false,
          errorMessage:
              'File size (${fileSizeInMB.toStringAsFixed(2)} MB) exceeds maximum allowed size of $maxFileSizeInMB MB',
        );
      }

      final String fileName = _displayNameForUi(
        file.path,
        preferredDisplayName: preferredDisplayName,
      );
      final String? mimeType = lookupMimeType(file.path);

      return FileUploadResult(
        success: true,
        file: file,
        fileName: fileName,
        fileSizeInBytes: fileSize,
        mimeType: mimeType ?? 'application/octet-stream',
      );
    } catch (e) {
      return FileUploadResult(
        success: false,
        errorMessage: 'Error validating file: $e',
      );
    }
  }

  /// Builds a server-side file name from [originalFileName].
  ///
  /// Uses a `Profile_` prefix and a millisecond timestamp before the extension.
  String generateServerFileName({required String originalFileName}) {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String extension = path.extension(originalFileName);

    return "Profile_$timestamp$extension";
  }

  /// Formats [bytes] as a human-readable size string (B, KB, or MB).
  ///
  /// Uses two decimal places for KB and MB values.
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}

/// Outcome of a file pick or validation operation.
///
/// On success, includes file metadata; on failure, includes [errorMessage].
class FileUploadResult {
  /// Creates a file upload result with the given fields.
  const FileUploadResult({
    required this.success,
    this.file,
    this.fileName,
    this.fileSizeInBytes,
    this.mimeType,
    this.errorMessage,
  });

  /// Whether the pick and validation completed successfully.
  final bool success;

  /// The selected file when [success] is true.
  final File? file;

  /// Display-friendly name of the selected file.
  final String? fileName;

  /// Size of [file] in bytes when available.
  final int? fileSizeInBytes;

  /// Detected MIME type of [file], or a default octet-stream value.
  final String? mimeType;

  /// User-facing error description when [success] is false.
  final String? errorMessage;

  /// [fileSizeInBytes] formatted via [FileUploadService.formatFileSize].
  String get fileSizeFormatted {
    if (fileSizeInBytes == null) return '';
    return FileUploadService.formatFileSize(fileSizeInBytes!);
  }
}
