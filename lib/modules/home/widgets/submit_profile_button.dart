import 'package:book_satsang/modules/home/extensions/profile_screen_rpovider_extension.dart';
// import 'package:book_satsang/modules/home/providers/profile_screen_provider.dart';
//import 'package:book_satsang/modules/registeration/extensions/registeration_provider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../network_module/response/api_response.dart';

/// A submit button for the profile edit form.
///
/// Enables submission only when all profile fields pass validation.
class SubmitProfileButton extends StatelessWidget {
  /// Creates a [SubmitProfileButton].
  const SubmitProfileButton({super.key});

  /// Builds the profile submit button with validation-driven enabled state.
  @override
  Widget build(BuildContext context) {
    final profileScreenProvider = context.profileScreenProvider;

    return StreamBuilder<bool>(
      stream: profileScreenProvider.validateReg(),
      builder: (context, snapshot) {
        // return Selector<ProfileScreenProvider, ApiResponse<int>>(
        //   selector: (_, p) => p.registerResponse,
        //   builder: (context, regRes, child) {
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
            onPressed: snapshot.hasData ? () {} : null,
            //  && (regRes.isIdle || regRes.isError))
            // ? () async =>
            //       await profileScreenProvider.submitProfile(context)
            // : null,
            child: Text(
              // (regRes.isIdle || regRes.isError)
              //     ?
              'Submit',
              // : 'Submitting...',
              style: TextStyle(
                fontSize: context.sp(4.5),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
      // );
      // },
    );
  }
}
