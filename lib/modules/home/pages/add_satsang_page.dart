import 'package:book_satsang/modules/home/extensions/add_satsang_provider_extension.dart';
import 'package:book_satsang/modules/home/widgets/add_satsang/from_date_field_widget.dart';
import 'package:book_satsang/modules/home/widgets/add_satsang/satsang_name_field_widget.dart';
import 'package:book_satsang/modules/home/widgets/add_satsang/submit_add_satsang_button.dart';
import 'package:book_satsang/modules/home/widgets/add_satsang/taluka_drop_widget.dart';
import 'package:book_satsang/modules/home/widgets/add_satsang/temple_address_field_widget.dart';
import 'package:book_satsang/modules/home/widgets/add_satsang/temple_name_field_widget.dart';
import 'package:book_satsang/modules/home/widgets/add_satsang/to_date_field_widget.dart';
import 'package:book_satsang/modules/home/widgets/add_satsang/village_drop_widget.dart';
import 'package:book_satsang/utils/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';

/// Screen for creating a new satsang event.
class AddSatsangPage extends StatefulWidget {
  const AddSatsangPage({super.key});

  @override
  State<AddSatsangPage> createState() => _AddSatsangPageState();
}

class _AddSatsangPageState extends State<AddSatsangPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.addSatsangProvider.initiatePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Satsang'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(context.wp(5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: const Column(
                    children: [
                      SatsangNameFieldWidget(),
                      TempleNameFieldWidget(),
                      TempleAddressFieldWidget(),
                      AddSatsangTalukaDropWidget(),
                      AddSatsangVillageDropWidget(),
                      FromDateFieldWidget(),
                      ToDateFieldWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const SubmitAddSatsangButton(),
      ),
    );
  }
}
