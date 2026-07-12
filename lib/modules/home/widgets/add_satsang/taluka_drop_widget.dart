import 'package:book_satsang/configs/theme/app_colors.dart';
import 'package:book_satsang/modules/home/extensions/add_satsang_provider_extension.dart';
import 'package:book_satsang/modules/home/providers/add_satsang_provider.dart';
import 'package:book_satsang/modules/registeration/models/response_models/taluka_list_response_model.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Searchable dropdown for selecting a taluka on the add satsang form.
class AddSatsangTalukaDropWidget extends StatelessWidget {
  const AddSatsangTalukaDropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.wp(2.5),
        horizontal: context.wp(5),
      ),
      child: Selector<AddSatsangProvider, List<TalukaData>>(
        selector: (context, p) => p.talukaResponse.data ?? [],
        builder: (context, value, child) => StreamBuilder(
          stream: context.addSatsangProvider.talukaStream(),
          builder: (context, snapshot) {
            return DropdownSearch<TalukaData>(
              selectedItem: snapshot.data,
              items: (filter, infiniteScrollProps) async =>
                  await context.addSatsangProvider.fetchTalukaList(filter),
              itemAsString: (TalukaData item) => item.talukaName ?? 'N/A',
              compareFn: (TalukaData a, TalukaData b) =>
                  a.idTalukaMaster == b.idTalukaMaster,
              dropdownBuilder: (BuildContext _, TalukaData? item) {
                return Text(
                  item != null ? item.talukaName ?? 'N/A' : '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.labelColor,
                    fontSize: context.wp(4),
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
              onSelected: context.addSatsangProvider.onChangeTaluka,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchDelay: Duration.zero,
              ),
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(labelText: 'Select Taluka'),
              ),
            );
          },
        ),
      ),
    );
  }
}
