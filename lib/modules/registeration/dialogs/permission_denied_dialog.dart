import 'package:flutter/material.dart';

import '../../../../utils/extensions/responsive_extension.dart';

/// Dialog shown when a required permission is permanently denied.
///
/// Prompts the user to open system settings to grant access.
class PermissionDeniedDialog extends StatelessWidget {
  /// Creates a [PermissionDeniedDialog].
  const PermissionDeniedDialog({
    super.key,
    required this.permissionName,
    required this.message,
  });

  /// Human-readable name of the denied permission.
  final String permissionName;

  /// Explanatory message shown below the title.
  final String message;

  /// Builds the permission denied dialog with settings action.
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
            Icon(
              Icons.lock_outline,
              size: context.sp(12),
              color: Colors.orange.shade700,
            ),
            SizedBox(height: context.wp(3)),
            Text(
              '$permissionName Permission Required',
              style: TextStyle(
                fontSize: context.sp(4.2),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.wp(3)),
            Text(
              message,
              style: TextStyle(
                fontSize: context.sp(3.4),
                color: Colors.blueGrey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.wp(5)),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: context.wp(3)),
                      side: BorderSide(
                        color: Colors.blueGrey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: context.sp(3.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.wp(3)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: context.wp(3)),
                      backgroundColor: Colors.orange.shade700,
                    ),
                    child: Text(
                      'Open Settings',
                      style: TextStyle(
                        fontSize: context.sp(3.6),
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
