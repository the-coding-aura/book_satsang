import 'package:book_satsang/modules/drawer/repository/drawer_repository.dart';
import 'package:book_satsang/modules/home/repository/home_repository.dart';
import 'package:book_satsang/modules/login/repository/login_api_repository.dart';
import 'package:book_satsang/modules/login/repository/login_http_api_repository.dart';
import 'package:book_satsang/modules/login/repository/login_mock_api_repository.dart';
import 'package:book_satsang/modules/master/repository/master_repository.dart';
import 'package:book_satsang/modules/otp/repository/otp_api_repository.dart';
import 'package:book_satsang/modules/otp/repository/otp_http_api_repository.dart';
import 'package:book_satsang/modules/otp/repository/otp_mock_api_repository.dart';
import 'package:book_satsang/modules/registeration/repository/register_repository.dart';
import 'package:book_satsang/network_module/network/app_environment.dart';
import 'package:book_satsang/network_module/network/base_api_services.dart';
import 'package:book_satsang/network_module/network/mock_api_services.dart';
import 'package:book_satsang/network_module/network/network_api_services.dart';
import 'package:book_satsang/services/auth/auth_service.dart';
import 'package:get_it/get_it.dart';

import '../services/access/file_upload_service.dart';
import '../services/access/permission_service.dart';

/// Global service locator instance for dependency injection.
final GetIt getIt = GetIt.instance;

/// Registers application-wide services and repositories with [getIt].
///
/// Selects mock or live API implementations based on [AppEnvironment.isMock].
void setupLocator() {
  if (AppEnvironment.isMock) {
    getIt.registerLazySingleton<BaseApiServices>(MockApiServices.new);
    getIt.registerLazySingleton<LoginApiRepository>(LoginMockApiRepository.new);
    getIt.registerLazySingleton<OTPApiRepository>(OTPMockApiRepository.new);
    getIt.registerLazySingleton<HomeApiRepository>(HomeMockApiRepository.new);
    getIt.registerLazySingleton<RegisterApiRepository>(
      RegisterMockApiRepository.new,
    );
    getIt.registerLazySingleton<MasterApiRepository>(
      MasterMockApiRepository.new,
    );
    getIt.registerLazySingleton<DrawerApiRepository>(
      DrawerMockApiRepository.new,
    );
  } else {
    getIt.registerLazySingleton<BaseApiServices>(NetworkApiServices.new);
    getIt.registerLazySingleton<LoginApiRepository>(LoginHttpApiRepository.new);
    getIt.registerLazySingleton<OTPApiRepository>(OTPHttpApiRepository.new);
    getIt.registerLazySingleton<HomeApiRepository>(HomeHttpApiRepository.new);
    getIt.registerLazySingleton<RegisterApiRepository>(
      RegisterHttpApiRepository.new,
    );
    getIt.registerLazySingleton<MasterApiRepository>(
      MasterHttpApiRepository.new,
    );
    getIt.registerLazySingleton<DrawerApiRepository>(
      DrawerHttpApiRepository.new,
    );
  }
  getIt.registerLazySingleton(AuthService.new);
  getIt.registerLazySingleton(FileUploadService.new);
  getIt.registerLazySingleton(PermissionService.new);
}
