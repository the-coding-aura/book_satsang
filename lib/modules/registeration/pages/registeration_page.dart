import 'package:book_satsang/modules/registeration/extensions/registeration_provider_extension.dart';
import 'package:book_satsang/modules/registeration/widgets/dob_field_widget.dart';
import 'package:book_satsang/modules/registeration/widgets/last_name_widget.dart';
import 'package:book_satsang/modules/registeration/widgets/profile_image_widget.dart';
import 'package:book_satsang/modules/registeration/widgets/submit_reg_button.dart';
import 'package:book_satsang/modules/registeration/widgets/taluka_drop_widget.dart';
import 'package:book_satsang/modules/registeration/widgets/village_drop_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

import '../widgets/desigation_drop_widget.dart';
import '../widgets/first_name_widget.dart';

/// Member registration screen with profile form fields.
///
/// Collects personal details and submits them after OTP verification.
class RegisterationPage extends StatefulWidget {
  /// Creates a [RegisterationPage].
  const RegisterationPage({super.key});

  /// Creates the state for this widget.
  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      context.registerationProvider.initiateRegPage(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Member Registeration")),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/logo.png',
                height: context.hp(7),
                width: context.hp(14),
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.hp(0.5)),
                child: Text(
                  'Registration',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.sp(6),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.hp(0.25)),
                child: Text(
                  'Complete your profile information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.sp(4),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFA05D19),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                child: Container(
                  height: context.hp(60),
                  width: context.wp(80),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfileImageWidget(),
                        FirstNameWidget(),
                        LastNameWidget(),
                        DOBFieldWidget(),
                        DesigationDropWidget(),
                        TalukaDropWidget(),
                        VillageDropWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SubmitRegButton(),
      ),
    );
  }
}
