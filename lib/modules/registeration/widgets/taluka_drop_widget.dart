import 'package:book_satsang/modules/registeration/extensions/registeration_provider_extension.dart';
import 'package:book_satsang/modules/registeration/models/response_models/taluka_list_response_model.dart';
import 'package:book_satsang/modules/registeration/providers/registeration_provider.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configs/theme/app_colors.dart';

/// Searchable dropdown for selecting a taluka during registration.
///
/// Triggers village list refresh when the selection changes.
class TalukaDropWidget extends StatelessWidget {
  /// Creates a [TalukaDropWidget].
  const TalukaDropWidget({super.key});

  /// Builds the taluka search dropdown with remote filtering.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: context.wp(2.5),
        horizontal: context.wp(5),
      ),
      child: Selector<RegisterationProvider, List<TalukaData>>(
        selector: (context, p) => p.talukaResponse.data ?? [],
        builder: (context, value, child) => StreamBuilder(
          stream: context.registerationProvider.talukaStream(),
          builder: (context, snapshot) {
            return DropdownSearch<TalukaData>(
              selectedItem: snapshot.data,
              items: (filter, infiniteScrollProps) async =>
                  await context.registerationProvider.fetchTalukaList(filter),
              itemAsString: (TalukaData u) => u.talukaName ?? "N/A",
              compareFn: (TalukaData a, TalukaData b) =>
                  a.idTalukaMaster == b.idTalukaMaster,
              dropdownBuilder: (BuildContext _, TalukaData? item) {
                return Text(
                  item != null ? item.talukaName ?? 'N/A' : "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.labelColor,
                    fontSize: context.wp(4),
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
              // onBeforePopupOpening: (TalukaData? selectedItem) async {
              //   if (selectedItem == null && value.isNotEmpty) {
              //     validationBloc.onVehicleModelOpenedWhenUnselected();
              //   }
              //   return true;
              // },
              onSelected: context.registerationProvider.onChangeTaluka,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchDelay: Duration.zero,
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(labelText: "Select Taluka"),
              ),
              // suffixProps: const DropdownSuffixProps(
              //   dropdownButtonProps: DropdownButtonProps(

              //   ),
              //   icon: Icon(
              //     Icons.arrow_drop_down_rounded,
              //     color: AppColors.iconColor,
              //   ),
              // ),
            );
          },
        ),
      ),
    );
  }
}
