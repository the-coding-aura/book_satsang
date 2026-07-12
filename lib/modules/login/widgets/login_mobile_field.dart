import 'package:book_satsang/modules/login/extensions/login_provider_extension.dart';
import 'package:book_satsang/modules/login/widgets/login_mobile_input.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Styled container for the login mobile number field with validation UI.
///
/// Shows error styling when [LoginProvider.mobileStream] emits a validation error.
class LoginMobileField extends StatelessWidget {
  /// Creates the labeled mobile number field group.
  const LoginMobileField({super.key});

  /// Builds the styled mobile field with validation error highlighting.
  ///
  /// Listens to [LoginProvider.mobileStream] for error state.
  @override
  Widget build(BuildContext context) {
    final loginProvider = context.loginProvider;

    return StreamBuilder<String>(
      stream: loginProvider.mobileStream(),
      builder: (context, snapshot) {
        final hasError = snapshot.hasError;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: hasError
                ? Border.all(color: Colors.red, width: 2.5)
                : Border.all(color: Colors.transparent, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(context.wp(2)),
                child: Icon(
                  Icons.phone_android_outlined,
                  color: hasError ? Colors.red : Colors.orange,
                  size: context.wp(10),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile Number',
                    style: TextStyle(
                      fontSize: context.sp(4),
                      fontWeight: FontWeight.w500,
                      color: hasError ? Colors.red : const Color(0xFFA05D19),
                    ),
                  ),
                  SizedBox(
                    width: context.wp(55),
                    height: context.hp(6),
                    child: const LoginMobileInput(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
