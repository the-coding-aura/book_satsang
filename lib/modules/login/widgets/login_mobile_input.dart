import 'package:book_satsang/modules/login/extensions/login_provider_extension.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Raw text field for entering a 10-digit Indian mobile number.
///
/// Binds to [LoginProvider.mobileNumberCon] and updates the provider on change.
class LoginMobileInput extends StatelessWidget {
  /// Creates the mobile number text input.
  const LoginMobileInput({super.key});

  /// Builds the phone [TextFormField] with +91 prefix and digit limits.
  ///
  /// Wires the controller and change handler to [LoginProvider].
  @override
  Widget build(BuildContext context) {
    final loginProvider = context.loginProvider;

    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+ 91',
              style: TextStyle(
                fontSize: context.sp(4),
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      controller: loginProvider.mobileNumberCon,
      onChanged: loginProvider.changeMobileNum,
    );
  }
}
