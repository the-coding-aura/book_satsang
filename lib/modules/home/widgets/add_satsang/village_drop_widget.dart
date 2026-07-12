import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/modules/home/extensions/add_satsang_provider_extension.dart';
import 'package:book_satsang/modules/home/providers/add_satsang_provider.dart';
import 'package:book_satsang/modules/registeration/models/response_models/village_list_response_model.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Searchable dropdown for selecting a village on the add satsang form.
class AddSatsangVillageDropWidget extends StatelessWidget {
  const AddSatsangVillageDropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.wp(2.5),
        horizontal: context.wp(5),
      ),
      child: Selector<AddSatsangProvider, List<VillageData>>(
        selector: (context, p) => p.villageResponse.data ?? [],
        builder: (context, value, child) => StreamBuilder(
          stream: context.addSatsangProvider.villageStream(),
          builder: (context, snapshot) {
            return DropdownSearch<VillageData>(
              selectedItem: snapshot.data,
              items: (filter, infiniteScrollProps) async =>
                  await context.addSatsangProvider.fetchVillageList(
                    filter,
                    context
                            .addSatsangProvider
                            .talukaSubject
                            .valueOrNull
                            ?.idTalukaMaster ??
                        0,
                  ),
              itemAsString: (VillageData item) => item.villageName ?? 'N/A',
              compareFn: (VillageData a, VillageData b) =>
                  a.idVillageMaster == b.idVillageMaster,
              dropdownBuilder: (BuildContext _, VillageData? item) {
                return Text(
                  item != null ? item.villageName ?? 'N/A' : '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.labelColor,
                    fontSize: context.wp(4),
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
              onSelected: context.addSatsangProvider.changeVillage,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchDelay: Duration.zero,
              ),
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(labelText: 'Select Village'),
              ),
            );
          },
        ),
      ),
    );
  }
}
