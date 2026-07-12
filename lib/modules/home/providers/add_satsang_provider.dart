import 'package:book_satsang/configs/components/app_flushbar.dart';
import 'package:book_satsang/dependency_injection/locator.dart';
import 'package:book_satsang/modules/home/models/request_models/add_satsang_request_model.dart';
import 'package:book_satsang/modules/home/repository/home_api_repository.dart';
import 'package:book_satsang/modules/home/validators/add_satsang_validator.dart';
import 'package:book_satsang/modules/master/repository/master_api_repository.dart';
import 'package:book_satsang/modules/registeration/models/request_models/taluka_request_model.dart';
import 'package:book_satsang/modules/registeration/models/request_models/village_request_model.dart';
import 'package:book_satsang/modules/registeration/models/response_models/taluka_list_response_model.dart';
import 'package:book_satsang/modules/registeration/models/response_models/village_list_response_model.dart';
import 'package:book_satsang/network_module/response/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

/// Manages add satsang form state, validation, and API interactions.
class AddSatsangProvider extends ChangeNotifier with AddSatsangValidator {
  final HomeApiRepository _homeRepository = getIt<HomeApiRepository>();
  final MasterApiRepository _masterApiRepository = getIt<MasterApiRepository>();

  /// Date formatter used for event date display and parsing.
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  /// Text controller bound to the from date field.
  final fromDateController = TextEditingController();

  /// Text controller bound to the to date field.
  final toDateController = TextEditingController();

  final satsangNameSubject = BehaviorSubject<String>.seeded('');
  final templeNameSubject = BehaviorSubject<String>.seeded('');
  final templeAddressSubject = BehaviorSubject<String>.seeded('');
  final talukaSubject = BehaviorSubject<TalukaData?>();
  final villageSubject = BehaviorSubject<VillageData?>();
  final fromDateSubject = BehaviorSubject<String>.seeded('');
  final toDateSubject = BehaviorSubject<String>.seeded('');

  Stream<String> satsangNameStream() =>
      satsangNameSubject.stream.transform(validateSatsangName());

  Stream<String> templeNameStream() =>
      templeNameSubject.stream.transform(validateTempleName());

  Stream<String> templeAddressStream() =>
      templeAddressSubject.stream.transform(validateTempleAddress());

  Stream<TalukaData?> talukaStream() =>
      talukaSubject.stream.transform(validateTaluka());

  Stream<VillageData?> villageStream() =>
      villageSubject.stream.transform(validateVillage());

  Stream<String> fromDateStream() => fromDateSubject.stream.transform(
    validateEventDate(emptyMessage: 'From date should not be empty.'),
  );

  Stream<String> toDateStream() => toDateSubject.stream
      .transform(
        validateEventDate(emptyMessage: 'To date should not be empty.'),
      )
      .withLatestFrom(fromDateSubject, (toDate, fromDate) {
        return validateToDateAgainstFromDate(
          toDate: toDate,
          fromDate: fromDate,
          parseDate: dateFormat.parse,
        );
      });

  Stream<bool> validateForm() => Rx.combineLatest7(
    satsangNameStream(),
    templeNameStream(),
    templeAddressStream(),
    talukaStream(),
    villageStream(),
    fromDateStream(),
    toDateStream(),
    (a, b, c, d, e, f, g) => true,
  );

  Function(String) get changeSatsangName => satsangNameSubject.sink.add;
  Function(String) get changeTempleName => templeNameSubject.sink.add;
  Function(String) get changeTempleAddress => templeAddressSubject.sink.add;
  Function(TalukaData?) get changeTaluka => talukaSubject.sink.add;
  Function(VillageData?) get changeVillage => villageSubject.sink.add;
  Function(String) get changeFromDate => fromDateSubject.sink.add;
  Function(String) get changeToDate => toDateSubject.sink.add;

  ApiResponse<List<TalukaData>> talukaResponse = ApiResponse.idle();
  ApiResponse<List<VillageData>> villageResponse = ApiResponse.idle();
  ApiResponse<int> addSatsangResponse = ApiResponse.idle();

  /// Loads taluka master data for the dropdown.
  Future<void> initiatePage() async {
    await fetchTalukaList('');
  }

  /// Opens a date picker for the from date field.
  Future<void> selectFromDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(currentDate.year - 1),
      lastDate: DateTime(currentDate.year + 5),
      initialDate: currentDate,
    );

    if (selectedDate == null) return;

    final formattedDate = dateFormat.format(selectedDate);
    changeFromDate(formattedDate);
    fromDateController.text = formattedDate;

    final toDateText = toDateSubject.valueOrNull ?? '';
    if (toDateText.isNotEmpty) {
      final toDate = dateFormat.parse(toDateText);
      if (toDate.isBefore(selectedDate)) {
        changeToDate('');
        toDateController.clear();
      } else {
        changeToDate(toDateText);
      }
    }
  }

  /// Opens a date picker for the to date field.
  Future<void> selectToDate(BuildContext context) async {
    final fromDateText = fromDateSubject.valueOrNull ?? '';
    final currentDate = DateTime.now();
    final firstDate = fromDateText.isNotEmpty
        ? dateFormat.parse(fromDateText)
        : DateTime(currentDate.year - 1);

    final selectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: DateTime(currentDate.year + 5),
      initialDate: firstDate,
    );

    if (selectedDate == null) return;

    final formattedDate = dateFormat.format(selectedDate);
    changeToDate(formattedDate);
    toDateController.text = formattedDate;
  }

  /// Fetches taluka options matching [searchText].
  Future<List<TalukaData>> fetchTalukaList(String searchText) async {
    talukaResponse = ApiResponse.loading('Fetching Taluka List');
    notifyListeners();
    await _masterApiRepository
        .fetchTaluka(TalukaRequestModel(talukaName: searchText).toJson())
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            talukaResponse = ApiResponse.completed(value.data ?? []);
          } else {
            final msg = value?.message ?? 'Taluka fetch failed.';
            talukaResponse = ApiResponse.error(msg);
          }
        })
        .onError((error, _) {
          talukaResponse = ApiResponse.error(error.toString());
        });
    notifyListeners();
    return talukaResponse.data ?? [];
  }

  /// Fetches villages for [talukaId] filtered by [searchText].
  Future<List<VillageData>> fetchVillageList(
    String searchText,
    int talukaId,
  ) async {
    villageResponse = ApiResponse.loading('Fetching Village List');
    notifyListeners();
    await _masterApiRepository
        .fetchVillage(
          VillageMasterRequestModel(
            villageName: searchText,
            idTalukaMaster: talukaId,
          ).toJson(),
        )
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            villageResponse = ApiResponse.completed(value.data ?? []);
          } else {
            final msg = value?.message ?? 'Village fetch failed.';
            villageResponse = ApiResponse.error(msg);
          }
        })
        .onError((error, _) {
          villageResponse = ApiResponse.error(error.toString());
        });
    notifyListeners();
    return villageResponse.data ?? [];
  }

  /// Updates taluka selection and reloads villages for the new taluka.
  Future<void> onChangeTaluka(TalukaData? talukaData) async {
    changeTaluka(talukaData);
    changeVillage(null);
    if (talukaData != null && (talukaData.idTalukaMaster ?? 0) != 0) {
      await fetchVillageList('', talukaData.idTalukaMaster ?? 0);
    }
  }

  /// Submits the add satsang form and pops on success.
  Future<void> submitAddSatsang(BuildContext context) async {
    addSatsangResponse = ApiResponse.loading('Submitting ...');
    notifyListeners();

    final fromDate = dateFormat.parse(fromDateSubject.valueOrNull ?? '');
    final toDate = dateFormat.parse(toDateSubject.valueOrNull ?? '');

    await _homeRepository
        .addSatsang(
          AddSatsangRequestModel(
            satsangName: satsangNameSubject.valueOrNull ?? '',
            templeName: templeNameSubject.valueOrNull ?? '',
            templeAddress: templeAddressSubject.valueOrNull ?? '',
            talukaMasterId: talukaSubject.valueOrNull?.idTalukaMaster ?? 0,
            villageMasterId: villageSubject.valueOrNull?.idVillageMaster ?? 0,
            fromDate: fromDate.toIso8601String(),
            toDate: toDate.toIso8601String(),
          ).toJson(),
        )
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            addSatsangResponse = ApiResponse.completed(value.data ?? 0);
            if (context.mounted) {
              AppFlushbar.success(
                context,
                message: value.message ?? 'Satsang added successfully.',
              );
              Navigator.pop(context, true);
            }
          } else {
            final msg =
                value?.validationMessages?.join(', ') ??
                value?.message ??
                'Add satsang failed.';
            addSatsangResponse = ApiResponse.error(msg);
            if (context.mounted) {
              AppFlushbar.error(context, message: msg);
            }
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          addSatsangResponse = ApiResponse.error(msg);
          if (context.mounted) {
            AppFlushbar.error(context, message: msg);
          }
        });

    notifyListeners();
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    satsangNameSubject.close();
    templeNameSubject.close();
    templeAddressSubject.close();
    talukaSubject.close();
    villageSubject.close();
    fromDateSubject.close();
    toDateSubject.close();
    super.dispose();
  }
}
