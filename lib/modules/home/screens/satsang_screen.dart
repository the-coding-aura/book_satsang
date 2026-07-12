import 'package:book_satsang/modules/home/extensions/satsang_provider_extension.dart';
import 'package:book_satsang/modules/home/extensions/string_extensions.dart';
import 'package:book_satsang/modules/home/providers/satsang_screen_provider.dart';
import 'package:book_satsang/modules/home/widgets/label_info.dart';
import 'package:book_satsang/modules/home/widgets/shimmers/satsang_list_shimmer_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../network_module/response/api_response.dart';
import '../../../network_module/response/status.dart';
import '../models/response_models/satsang_list_response_model.dart';

/// Screen that lists upcoming and past satsang events.
///
/// Fetches satsang data on load and renders each entry as a card.
class SatsangScreen extends StatefulWidget {
  /// Creates a [SatsangScreen].
  const SatsangScreen({super.key});

  /// Creates the state for this widget.
  @override
  State<SatsangScreen> createState() => _SatsangScreenState();
}

class _SatsangScreenState extends State<SatsangScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.satsangScreenProvider.assignAUthData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SatsangScreenProvider, ApiResponse<List<SatsangData>>>(
      selector: (context, p) => p.satsangListRes,
      builder: (context, value, child) {
        switch (value.status) {
          case Status.loading:
          case Status.idle:
            return const SatsangListShimmerWidget();

          case Status.error:
            return Text(value.message ?? '');

          case Status.completed:
            var satsangList = value.data ?? [];
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(height: context.hp(1)),
                padding: EdgeInsets.all(context.wp(2.5)),
                itemCount: satsangList.length,
                itemBuilder: (context, index) {
                  var cardItem = satsangList[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(context.wp(1)),
                      child: Column(
                        children: [
                          LabelInfoWidget(
                            label: "Satsang Name",
                            icon: Icons.event_available_rounded,
                            info: cardItem.satsangName ?? "N/A",
                          ),
                          LabelInfoWidget(
                            label: "Temple Name",
                            icon: Icons.temple_hindu,
                            info: cardItem.templeName ?? "N/A",
                          ),
                          LabelInfoWidget(
                            label: "Temple Address",
                            icon: Icons.location_pin,
                            info: cardItem.templeAddress ?? "N/A",
                          ),
                          LabelInfoWidget(
                            label: "Village",
                            icon: Icons.holiday_village,
                            info: cardItem.villageName ?? "N/A",
                          ),
                          LabelInfoWidget(
                            label: "Taluka",
                            info: cardItem.talukaName ?? "N/A",
                            icon: Icons.location_city,
                          ),
                          LabelInfoWidget(
                            label: "Start Date",
                            icon: Icons.date_range,
                            info:
                                cardItem.fromDate?.getFormattedDateTime() ??
                                "N/A",
                          ),
                          LabelInfoWidget(
                            label: "End Date",
                            icon: Icons.date_range,
                            info:
                                cardItem.toDate?.getFormattedDateTime() ??
                                "N/A",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );

        }
      },
    );
  }
}
