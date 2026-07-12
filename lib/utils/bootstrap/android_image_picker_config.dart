import 'package:flutter/foundation.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// Enables the Android system Photo Picker for [image_picker] gallery flows.
///
/// Call once from [main] after [WidgetsFlutterBinding.ensureInitialized]. Some
/// devices only misbehave (multi-select / pre-checked tiles) on the **first**
/// gallery open if this flag is applied only immediately before [pickImage];
/// setting it at startup avoids that.
void configureAndroidImagePickerForSingleGalleryPick() {
  if (defaultTargetPlatform != TargetPlatform.android) {
    return;
  }
  final ImagePickerPlatform platform = ImagePickerPlatform.instance;
  if (platform is ImagePickerAndroid) {
    platform.useAndroidPhotoPicker = true;
  }
}
