import 'package:book_satsang/modules/home/extensions/profile_screen_rpovider_extension.dart';
import 'package:book_satsang/modules/home/providers/profile_screen_provider.dart';
import 'package:book_satsang/modules/registeration/models/response_models/village_list_response_model.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configs/theme/app_colors.dart';

/// Searchable dropdown for selecting a village on the profile screen.
///
/// Loads villages filtered by the currently selected taluka.
class VillageDropWidget extends StatelessWidget {
  /// Creates a [VillageDropWidget].
  const VillageDropWidget({super.key});

  /// Builds the village search dropdown with remote filtering.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: context.wp(2.5),
        horizontal: context.wp(5),
      ),
      child: Selector<ProfileScreenProvider, List<VillageData>>(
        selector: (context, p) => p.villageResponse.data ?? [],
        builder: (context, value, child) => StreamBuilder(
          stream: context.profileScreenProvider.villageStream(),
          builder: (context, snapshot) {
            return DropdownSearch<VillageData>(
              selectedItem: snapshot.data,
              items: (filter, infiniteScrollProps) async =>
                  await context.profileScreenProvider.fetchVillageList(
                    filter,
                    context
                            .profileScreenProvider
                            .talukaSubject
                            .valueOrNull
                            ?.idTalukaMaster ??
                        0,
                  ),
              itemAsString: (VillageData u) => u.villageName ?? "N/A",
              compareFn: (VillageData a, VillageData b) =>
                  a.idVillageMaster == b.idVillageMaster,
              dropdownBuilder: (BuildContext _, VillageData? item) {
                return Text(
                  item != null ? item.villageName ?? 'N/A' : "",
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
              onSelected: context.profileScreenProvider.changeVillage,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchDelay: Duration.zero,
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(labelText: "Select Village"),
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
