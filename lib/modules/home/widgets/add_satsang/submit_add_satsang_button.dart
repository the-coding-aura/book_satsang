import 'package:book_satsang/modules/home/extensions/add_satsang_provider_extension.dart';
import 'package:book_satsang/modules/home/providers/add_satsang_provider.dart';
import 'package:book_satsang/network_module/response/api_response.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Submit button for the add satsang form.
class SubmitAddSatsangButton extends StatelessWidget {
  const SubmitAddSatsangButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.addSatsangProvider;

    return StreamBuilder<bool>(
      stream: provider.validateForm(),
      builder: (context, snapshot) {
        return Selector<AddSatsangProvider, ApiResponse<int>>(
          selector: (_, p) => p.addSatsangResponse,
          builder: (context, response, child) {
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
                    (snapshot.hasData &&
                        (response.isIdle || response.isError))
                    ? () async => await provider.submitAddSatsang(context)
                    : null,
                child: Text(
                  (response.isIdle || response.isError)
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
