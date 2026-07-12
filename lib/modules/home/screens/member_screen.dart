import 'package:book_satsang/modules/home/extensions/member_provider_extension.dart';
import 'package:book_satsang/modules/home/extensions/string_extensions.dart';
import 'package:book_satsang/modules/home/providers/member_screen_provider.dart';
import 'package:book_satsang/modules/home/widgets/label_info.dart';
import 'package:book_satsang/modules/home/widgets/shimmers/member_list_shimmer_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../network_module/response/api_response.dart';
import '../../../network_module/response/status.dart';
import '../models/response_models/member_list_response_model.dart';

/// Screen that lists all registered members.
class MemberScreen extends StatefulWidget {
  /// Creates a [MemberScreen].
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.memberScreenProvider.assignAuthData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MemberScreenProvider, ApiResponse<List<MemberData>>>(
      selector: (context, p) => p.memberListRes,
      builder: (context, value, child) {
        switch (value.status) {
          case Status.loading:
          case Status.idle:
            return const MemberListShimmerWidget();

          case Status.error:
            return Center(child: Text(value.message ?? ''));

          case Status.completed:
            final memberList = value.data ?? [];
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    SizedBox(height: context.hp(1)),
                padding: EdgeInsets.all(context.wp(2.5)),
                itemCount: memberList.length,
                itemBuilder: (context, index) {
                  final member = memberList[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(context.wp(1)),
                      child: Column(
                        children: [
                          LabelInfoWidget(
                            label: 'First Name',
                            icon: Icons.person,
                            info: member.firstName ?? 'N/A',
                          ),
                          LabelInfoWidget(
                            label: 'Last Name',
                            icon: Icons.person_outline,
                            info: member.lastName ?? 'N/A',
                          ),
                          LabelInfoWidget(
                            label: 'Mobile Number',
                            icon: Icons.phone,
                            info: member.mobileNumber ?? 'N/A',
                          ),
                          LabelInfoWidget(
                            label: 'Date of Birth',
                            icon: Icons.cake,
                            info:
                                member.dateOfBirth?.getFormattedDateTime() ??
                                'N/A',
                          ),
                          LabelInfoWidget(
                            label: 'Village',
                            icon: Icons.holiday_village,
                            info: member.villageName ?? 'N/A',
                          ),
                          LabelInfoWidget(
                            label: 'Taluka',
                            icon: Icons.location_city,
                            info: member.talukaName ?? 'N/A',
                          ),
                          LabelInfoWidget(
                            label: 'Designation',
                            icon: Icons.badge,
                            info: member.designationName ?? 'N/A',
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
