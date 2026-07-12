import 'package:flutter/material.dart';

import '../../../../utils/extensions/responsive_extension.dart';
import '../../../services/access/file_upload_service.dart';

/// Dialog for choosing a file upload source.
///
/// Offers camera, gallery, and optional document picker actions.
class FileUploadSourceDialog extends StatelessWidget {
  /// Creates a [FileUploadSourceDialog].
  const FileUploadSourceDialog({
    super.key,
    required this.onSourceSelected,
    this.showDocumentOption = true,
  });

  /// Called when the user selects a [FileSourceType].
  final void Function(FileSourceType) onSourceSelected;

  /// Whether the document upload option is shown.
  final bool showDocumentOption;

  /// Builds the upload source selection dialog.
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.wp(3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.wp(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Choose Upload Source',
              style: TextStyle(
                fontSize: context.sp(4.2),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: context.wp(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _SourceOptionCard(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => onSourceSelected(FileSourceType.camera),
                ),
                _SourceOptionCard(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => onSourceSelected(FileSourceType.gallery),
                ),
                if (showDocumentOption)
                  _SourceOptionCard(
                    icon: Icons.insert_drive_file,
                    label: 'Document',
                    onTap: () => onSourceSelected(FileSourceType.document),
                  ),
              ],
            ),
            SizedBox(height: context.wp(3)),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: context.sp(3.8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceOptionCard extends StatelessWidget {
  const _SourceOptionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.wp(2.5)),
      child: Container(
        width: context.wp(22),
        padding: EdgeInsets.symmetric(vertical: context.wp(4)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey.shade200, width: 1.5),
          borderRadius: BorderRadius.circular(context.wp(2.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: context.sp(8), color: Colors.blueGrey.shade700),
            SizedBox(height: context.wp(2)),
            Text(
              label,
              style: TextStyle(
                fontSize: context.sp(3.4),
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
