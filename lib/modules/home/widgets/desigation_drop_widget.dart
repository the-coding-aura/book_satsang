import 'package:book_satsang/modules/home/extensions/profile_screen_rpovider_extension.dart';
import 'package:book_satsang/modules/registeration/models/response_models/designation_list_response_model.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_screen_provider.dart';

/// Dropdown for selecting a designation on the profile screen.
///
/// Populates options from [ProfileScreenProvider.designationResponse].
class DesigationDropWidget extends StatelessWidget {
  /// Creates a [DesigationDropWidget].
  const DesigationDropWidget({super.key});

  /// Builds the designation dropdown with validation state.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: context.wp(2.5),
        horizontal: context.wp(5),
      ),
      child: Selector<ProfileScreenProvider, List<DesignationData>>(
        selector: (context, p) => p.designationResponse.data ?? [],
        builder: (context, value, child) => StreamBuilder(
          stream: context.profileScreenProvider.designationStream(),
          builder: (context, snapshot) {
            return DropdownButtonFormField<DesignationData>(
              initialValue: snapshot.data,
              decoration: InputDecoration(
                hintText: "Select Designation",
                labelText: "Designation",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              items: List.generate(
                value.length,
                (index) => DropdownMenuItem<DesignationData>(
                  value: value[index],
                  child: Text(value[index].designationName ?? ""),
                ),
              ),
              onChanged: context.profileScreenProvider.changeDesignation,
            );
          },
        ),
      ),
    );
  }
}
