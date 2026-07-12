import 'package:book_satsang/modules/home/extensions/profile_screen_rpovider_extension.dart';
import 'package:book_satsang/modules/home/providers/profile_screen_provider.dart';
import 'package:book_satsang/modules/home/widgets/desigation_drop_widget.dart';
import 'package:book_satsang/modules/home/widgets/dob_field_widget.dart';
import 'package:book_satsang/modules/home/widgets/first_name_widget.dart';
import 'package:book_satsang/modules/home/widgets/last_name_widget.dart';
import 'package:book_satsang/modules/home/widgets/profile_image_widget.dart';
import 'package:book_satsang/modules/home/widgets/shimmers/profile_shimmer_widget.dart';
import 'package:book_satsang/modules/home/widgets/taluka_drop_widget.dart';
import 'package:book_satsang/modules/home/widgets/village_drop_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/submit_profile_button.dart';

/// Screen for viewing and editing the member profile.
///
/// Displays profile fields inside a scrollable card with a submit action.
class ProfileScreen extends StatefulWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({super.key});

  /// Creates the state for this widget.
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.profileScreenProvider.initiateRegPage(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          SizedBox(
            height: context.hp(70),
            width: context.wp(90),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(20),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),

                child: Selector<ProfileScreenProvider, bool>(
                  selector: (_, p) => p.profileResponse.isCompleted,
                  builder: (context, isCompleted, child) {
                    if (!isCompleted) {
                      return const ProfileShimmerWidget();
                    }
                    return child!;
                  },
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
            ),
          ),
          SubmitProfileButton(),
        ],
      ),
    );
  }
}
