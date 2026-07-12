import 'package:book_satsang/modules/registeration/extensions/registeration_provider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../network_module/response/api_response.dart';
import '../providers/registeration_provider.dart';

/// Submit button for the member registration form.
///
/// Enables submission only when validation passes and no request is in flight.
class SubmitRegButton extends StatelessWidget {
  /// Creates a [SubmitRegButton].
  const SubmitRegButton({super.key});

  /// Builds the registration submit button with loading state.
  @override
  Widget build(BuildContext context) {
    final registerationProvider = context.registerationProvider;

    return StreamBuilder<bool>(
      stream: registerationProvider.validateReg(),
      builder: (context, snapshot) {
        return Selector<RegisterationProvider, ApiResponse<int>>(
          selector: (_, p) => p.registerResponse,
          builder: (context, regRes, child) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.hp(1),
                horizontal: context.wp(5),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, context.hp(6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed:
                    (snapshot.hasData && (regRes.isIdle || regRes.isError))
                    ? () async =>
                          await registerationProvider.registerMember(context)
                    : null,
                child: Text(
                  (regRes.isIdle || regRes.isError)
                      ? 'Submit'
                      : 'Submitting...',
                  style: TextStyle(
                    fontSize: context.sp(4.5),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
