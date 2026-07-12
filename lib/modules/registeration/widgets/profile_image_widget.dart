import 'package:book_satsang/modules/registeration/extensions/registeration_provider_extension.dart';
import 'package:book_satsang/modules/registeration/providers/registeration_provider.dart';
import 'package:book_satsang/network_module/response/response.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tappable avatar for selecting and uploading a registration profile image.
///
/// Shows upload progress and the cached network image when available.
class ProfileImageWidget extends StatelessWidget {
  /// Creates a [ProfileImageWidget].
  const ProfileImageWidget({super.key});

  /// Builds the circular profile image with upload handling.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.wp(40),
      width: context.wp(40),
      child: Selector<RegisterationProvider, (ApiResponse<String>, double)>(
        selector: (_, p) => (p.uploadResponse, p.progress),
        builder: (context, value, child) => GestureDetector(
          onTap: () async =>
              context.registerationProvider.handleUploadRequest(context),
          child: CircleAvatar(
            child: value.$1.isLoading
                ? CircularProgressIndicator(value: value.$2)
                : value.$1.isCompleted
                ? CachedNetworkImage(
                    imageUrl: value.$1.data ?? "",
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, size: context.wp(20)),
                    placeholder: (context, url) =>
                        Image.asset("assets/images/person.png"),
                  )
                : Image.asset("assets/images/person.png"),
          ),
        ),
      ),
    );
  }
}
