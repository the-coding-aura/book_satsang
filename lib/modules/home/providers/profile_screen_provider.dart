import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../../configs/routes/routes_name.dart';
import '../../../dependency_injection/locator.dart';
import '../../../network_module/response/api_response.dart';
import '../../../services/access/file_upload_service.dart';
import '../../../services/access/permission_service.dart';
import '../../master/repository/master_api_repository.dart';
import '../../registeration/dialogs/file_upload_source_dialog.dart';
import '../../registeration/dialogs/permission_denied_dialog.dart';
import '../../registeration/models/request_models/taluka_request_model.dart';
import '../../registeration/models/request_models/village_request_model.dart';
import '../../registeration/models/response_models/designation_list_response_model.dart';
import '../../registeration/models/response_models/taluka_list_response_model.dart';
import '../../registeration/models/response_models/village_list_response_model.dart';
import '../../registeration/validators/register_form_validator.dart';
import '../models/response_models/profile_get_response_model.dart';
import '../repository/home_api_repository.dart';

/// Manages profile edit form state, validation, and API interactions.
///
/// Loads existing profile data and coordinates master list lookups and uploads.
class ProfileScreenProvider extends ChangeNotifier with RegisterFormValidator {
  /// Date formatter used for DOB display and parsing.
  DateFormat dobFormat = DateFormat("dd/MM/yyyy");

  /// Upload progress fraction between 0.0 and 1.0.
  double progress = 0;
  final FileUploadService _fileUploadService = getIt<FileUploadService>();

  /// Text controller bound to the first name field.
  final firstNameController = TextEditingController();

  /// Text controller bound to the last name field.
  final lastNameController = TextEditingController();

  /// Text controller bound to the date-of-birth field.
  final dobFieldController = TextEditingController();
  final PermissionService _permissionService = getIt<PermissionService>();
  final MasterApiRepository _masterApiRepository = getIt<MasterApiRepository>();
  final HomeApiRepository _homeApiRepository = getIt<HomeApiRepository>();

  /// Stream subject for first name input changes.
  final firstNameSubject = BehaviorSubject<String>();

  /// Stream subject for last name input changes.
  final lastNameSubject = BehaviorSubject<String>();

  /// Stream subject for selected taluka changes.
  final talukaSubject = BehaviorSubject<TalukaData?>();

  /// Stream subject for selected designation changes.
  final designationSubject = BehaviorSubject<DesignationData?>();

  /// Stream subject for date-of-birth input changes.
  final dobSubject = BehaviorSubject<String>();

  /// Stream subject for selected village changes.
  final villageSubject = BehaviorSubject<VillageData?>();

  /// Stream subject for uploaded profile image file name changes.
  final pickedFileSubject = BehaviorSubject<String?>();

  /// Returns a validated stream of first name values.
  Stream<String> firstNameStream() =>
      firstNameSubject.stream.transform(validateFirstName());

  /// Returns a validated stream of last name values.
  Stream<String> lastNameStream() =>
      lastNameSubject.stream.transform(validateFirstName());

  /// Returns a validated stream of date-of-birth values.
  Stream<String> dobStream() => dobSubject.stream.transform(validateDOB());

  /// Returns a validated stream of taluka selections.
  Stream<TalukaData?> talukaStream() =>
      talukaSubject.stream.transform(validateTaluka());

  /// Returns a validated stream of village selections.
  Stream<VillageData?> villageStream() =>
      villageSubject.stream.transform(validateVillage());

  /// Returns a validated stream of designation selections.
  Stream<DesignationData?> designationStream() =>
      designationSubject.stream.transform(validateDesignation());

  /// Returns a validated stream of uploaded file name values.
  Stream<String?> pickedFileStream() =>
      pickedFileSubject.stream.transform(validateFile());

  /// Emits `true` when all profile form streams are valid.
  Stream<bool> validateReg() => Rx.combineLatest7(
    pickedFileStream(),
    firstNameStream(),
    lastNameStream(),
    dobStream(),
    designationStream(),
    talukaStream(),
    villageStream(),
    (a, b, c, d, e, f, g) => true,
  );

  /// Callback that pushes a new first name into [firstNameSubject].
  Function(String) get changeFirstName => firstNameSubject.sink.add;

  /// Callback that pushes a new last name into [lastNameSubject].
  Function(String) get changeLastName => lastNameSubject.sink.add;

  /// Callback that pushes a new DOB string into [dobSubject].
  Function(String) get changeDob => dobSubject.sink.add;

  /// Callback that pushes a new taluka into [talukaSubject].
  Function(TalukaData?) get changeTaluka => talukaSubject.sink.add;

  /// Callback that pushes a new village into [villageSubject].
  Function(VillageData?) get changeVillage => villageSubject.sink.add;

  /// Callback that pushes a new designation into [designationSubject].
  Function(DesignationData?) get changeDesignation =>
      designationSubject.sink.add;

  /// Callback that pushes a new file name into [pickedFileSubject].
  Function(String?) get changePickedFile => pickedFileSubject.sink.add;

  /// API response for the taluka master list request.
  ApiResponse<List<TalukaData>> talukaResponse = ApiResponse.idle();

  /// API response for the village master list request.
  ApiResponse<List<VillageData>> villageResponse = ApiResponse.idle();

  /// API response for the designation master list request.
  ApiResponse<List<DesignationData>> designationResponse = ApiResponse.idle();

  /// API response for the profile image upload request.
  ApiResponse<String> uploadResponse = ApiResponse.idle();

  /// API response for the profile update submission request.
  ApiResponse<int> updateProfileResponse = ApiResponse.idle();

  /// API response for the profile details fetch request.
  ApiResponse<ProfileData> profileResponse = ApiResponse.idle();

  /// Loads profile data and master lists, then binds values to the form.
  ///
  /// Called when the profile screen is first displayed.
  Future<void> initiateRegPage(BuildContext context) async {
    await fetchProfileDetails();
    await fetchDesignationList();
    await fetchTalukaList("");
    await assignProfileData();
  }

  /// Populates form subjects and controllers from [profileResponse].
  ///
  /// Resolves designation, taluka, and village selections by name match.
  Future<void> assignProfileData() async {
    if (profileResponse.data != null) {
      var profileData = profileResponse.data!;
      changeFirstName(profileData.firstName ?? "");
      firstNameController.text = profileData.firstName ?? "";
      changeLastName(profileData.lastName ?? "");
      lastNameController.text = profileData.lastName ?? "";
      var dob = DateTime.tryParse(profileData.dateOfBirth ?? "");
      if (dob != null) {
        var formattedDate = dobFormat.format(dob);
        changeDob(formattedDate);
        dobFieldController.text = formattedDate;
      }
      var desIdx = designationResponse.data?.indexWhere(
        (element) => element.designationName == profileData.designationName,
      );
      if (desIdx != -1) {
        changeDesignation(designationResponse.data?[desIdx ?? 0]);
      }
      var talukaIdx = talukaResponse.data?.indexWhere(
        (element) => element.talukaName == profileData.talukaName,
      );
      if (talukaIdx != -1) {
        changeTaluka(talukaResponse.data?[talukaIdx ?? 0]);
      }
      await fetchVillageList(
        "",
        talukaResponse.data?[talukaIdx ?? 0].idTalukaMaster ?? 0,
      );
      var villageIdx = villageResponse.data?.indexWhere(
        (element) => element.villageName == profileData.villageName,
      );
      if (villageIdx != -1) {
        changeVillage(villageResponse.data?[villageIdx ?? 0]);
      }
    }
  }

  /// Opens a date picker and writes the selected DOB to the form.
  ///
  /// Restricts selection to dates at least 14 years before today.
  Future<void> selectDate(BuildContext context) async {
    var currentDate = DateTime.now();
    await showDatePicker(
      context: context,
      firstDate: DateTime(currentDate.year - 100),
      lastDate: DateTime(
        currentDate.year - 14,
        currentDate.month,
        currentDate.day,
      ),
    ).then((value) {
      if (value != null) {
        var formattedDate = dobFormat.format(value);
        changeDob(formattedDate);
        dobFieldController.text = formattedDate;
      }
    });
  }

  /// Fetches taluka options matching [searchText] and updates [talukaResponse].
  ///
  /// Returns the fetched list, or an empty list on failure.
  Future<List<TalukaData>> fetchTalukaList(String searchText) async {
    talukaResponse = ApiResponse.loading("Fetching Taluka List");
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
          final msg = error.toString();
          talukaResponse = ApiResponse.error(msg);
        });
    notifyListeners();
    return talukaResponse.data ?? [];
  }

  /// Navigates to the login screen, replacing the current route stack.
  Future<void> goToLoginPage(BuildContext context) async {
    Navigator.pushNamed(context, RoutesName.login);
  }

  /// Fetches the authenticated member profile and updates [profileResponse].
  Future<void> fetchProfileDetails() async {
    profileResponse = ApiResponse.loading("Fetching Profile Data");
    notifyListeners();
    await _homeApiRepository
        .fetchProfileDetails()
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            profileResponse = ApiResponse.completed(value.data!);
          } else {
            final msg = value?.message ?? 'Profile fetch failed.';
            profileResponse = ApiResponse.error(msg);
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          profileResponse = ApiResponse.error(msg);
        });
    notifyListeners();
  }

  /// Fetches villages for [talukaId] filtered by [searchText].
  ///
  /// Updates [villageResponse] and returns the fetched list.
  Future<List<VillageData>> fetchVillageList(
    String searchText,
    int talukaId,
  ) async {
    villageResponse = ApiResponse.loading("Fetching Village List");
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
            final msg = value?.message ?? 'Taluka fetch failed.';
            villageResponse = ApiResponse.error(msg);
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          villageResponse = ApiResponse.error(msg);
        });
    notifyListeners();
    return villageResponse.data ?? [];
  }

  /// Fetches the designation master list and updates [designationResponse].
  Future<void> fetchDesignationList() async {
    designationResponse = ApiResponse.loading("Fetching Designation List");
    notifyListeners();
    await _masterApiRepository
        .fetchDesignation()
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            designationResponse = ApiResponse.completed(value.data ?? []);
          } else {
            final msg = value?.message ?? 'Designation fetch failed.';
            designationResponse = ApiResponse.error(msg);
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          designationResponse = ApiResponse.error(msg);
        });
    notifyListeners();
  }

  /// Updates taluka selection and reloads villages for the new taluka.
  ///
  /// Clears the current village selection when taluka changes.
  Future<void> onChangeTaluka(TalukaData? talukaData) async {
    changeTaluka(talukaData);
    changeVillage(null);
    if (talukaData != null && talukaData.idTalukaMaster != 0) {
      await fetchVillageList("", talukaData.idTalukaMaster ?? 0);
    }
  }

  /// Presents file source options and uploads the selected profile image.
  ///
  /// Handles permission checks and reports upload progress via [progress].
  void handleUploadRequest(BuildContext context) async {
    final FileSourceType? sourceType = await showDialog<FileSourceType>(
      context: context,
      builder: (BuildContext dialogContext) => FileUploadSourceDialog(
        onSourceSelected: (FileSourceType type) {
          Navigator.of(dialogContext).pop(type);
        },
        showDocumentOption: true,
      ),
    );

    if (sourceType == null || !context.mounted) return;

    FileUploadResult? result;
    PermissionResult? permissionResult;

    switch (sourceType) {
      case FileSourceType.camera:
        permissionResult = await _permissionService.requestPermission(
          PermissionType.camera,
        );
        if (!permissionResult.isGranted) {
          if (context.mounted) {
            await _handlePermissionDenied(
              context,
              _permissionService,
              'Camera',
              permissionResult,
            );
          }
          return;
        }
        result = await _fileUploadService.pickImageFromCamera();
        break;

      case FileSourceType.gallery:
        permissionResult = await _permissionService.requestPermission(
          PermissionType.gallery,
        );
        if (!permissionResult.isGranted) {
          if (context.mounted) {
            await _handlePermissionDenied(
              context,
              _permissionService,
              'Gallery',
              permissionResult,
            );
          }
          return;
        }
        result = await _fileUploadService.pickImageFromGallery();
        break;

      case FileSourceType.document:
        permissionResult = await _permissionService.requestPermission(
          PermissionType.files,
        );
        if (!permissionResult.isGranted) {
          if (context.mounted) {
            await _handlePermissionDenied(
              context,
              _permissionService,
              'File Access',
              permissionResult,
            );
          }
          return;
        }
        result = await _fileUploadService.pickDocument();
        break;
    }

    if (!context.mounted) return;

    if (!result.success) {
      if (!(result.errorMessage?.contains('No') ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Failed to select file'),
          ),
        );
      }
      return;
    }

    if (result.file == null || result.fileName == null) return;

    final String serverFileName = _fileUploadService.generateServerFileName(
      originalFileName: result.fileName!,
    );

    // context.read<CertificateFormFiveBloc>().add(
    //   DocumentUploadStarted(
    //     documentType: documentType,
    //     filePath: result.file!.path,
    //     fileName: result.fileName!,
    //   ),
    // );

    try {
      uploadResponse = ApiResponse.loading("Uploading file...");
      notifyListeners();
      await _masterApiRepository
          .uploadFile(result.file!.path, "Profile", serverFileName, (
            int sent,
            int total,
          ) {
            if (context.mounted) {
              final double progressNum = total > 0 ? sent / total : 0.0;
              debugPrint(progressNum.toString());
              progress = progressNum;
              notifyListeners();
            }
          })
          .then((value) async {
            if (value != null &&
                value.isSuccessful == true &&
                value.data != null &&
                (value.data ?? []).isNotEmpty) {
              uploadResponse = ApiResponse.completed(value.data?.first ?? "");
              changePickedFile(value.data?.first);
            } else {
              final msg = value?.message ?? 'Taluka fetch failed.';
              uploadResponse = ApiResponse.error(msg);
            }
          })
          .onError((error, _) {
            final msg = error.toString();
            uploadResponse = ApiResponse.error(msg);
          });
      notifyListeners();
      // context.read<CertificateFormFiveBloc>().add(
      //   DocumentUploadCompleted(
      //     documentType: documentType,
      //     fileUrl: response.fileUrl ?? '',
      //     serverFileName: serverFileName,
      //     localImagePath: localPath,
      //   ),
      // );
      // if (context.mounted) {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(SnackBar(content: Text(response?.message??"")));
      // }
    } catch (e) {
      if (context.mounted) {
        // context.read<CertificateFormFiveBloc>().add(
        //   DocumentUploadFailed(
        //     documentType: documentType,
        //     errorMessage: 'Upload failed: $e',
        //   ),
        // );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    }
  }

  // Future<void> registerMember(BuildContext context) async {
  // registerResponse = ApiResponse.loading("Submitting ...");
  // notifyListeners();
  // var formattedStr = DateFormat(
  //   "dd/MM/yyyy",
  // ).parse(dobSubject.valueOrNull ?? "");
  // var reqDateTime = formattedStr.toIso8601String();
  // await _registerApiRepository
  //     .registerMember(
  //       RegisterMemberRequestModel(
  //         firstName: firstNameSubject.valueOrNull ?? "",
  //         lastName: lastNameSubject.valueOrNull ?? "",
  //         dateOfBirth: reqDateTime,
  //         isAdmin: 0,
  //         // mobileNumber: _mobileNumber,
  //         designationId: designationSubject.valueOrNull?.idDesignation ?? 0,
  //         talukaId: talukaSubject.valueOrNull?.idTalukaMaster ?? 0,
  //         villageId: villageSubject.valueOrNull?.idVillageMaster ?? 0,
  //         // profileImageFileName: pickedFileSubject.valueOrNull ?? "",
  //       ).toJson(),
  // )
  // .then((value) async {
  //   if (value != null &&
  //       value.isSuccessful == true &&
  //       value.data != null) {
  //     registerResponse = ApiResponse.completed(value.data ?? 0);
  //     if (context.mounted) {
  //       await goToLoginPage(context);
  //     }
  //   } else {
  //     final msg =
  //         value?.validationMessages?.join(', ') ??
  //         'Member registration failed.';
  //     registerResponse = ApiResponse.error(msg);
  //     if (context.mounted) {
  //       AppFlushbar.error(context, message: msg);
  //     }
  //   }
  // })
  // .onError((error, _) {
  //   final msg = error.toString();
  //   registerResponse = ApiResponse.error(msg);
  // });
  // notifyListeners();
  // }

  Future<void> _handlePermissionDenied(
    BuildContext context,
    PermissionService permissionService,
    String permissionName,
    PermissionResult permissionResult,
  ) async {
    if (permissionResult.isPermanentlyDenied) {
      final bool? shouldOpenSettings = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => PermissionDeniedDialog(
          permissionName: permissionName,
          message:
              'This feature requires $permissionName permission. Please enable it in app settings to continue.',
        ),
      );

      if (shouldOpenSettings == true && context.mounted) {
        await permissionService.openAppSettings();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please enable $permissionName permission and try again',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(permissionResult.message)));
    }
  }
}
