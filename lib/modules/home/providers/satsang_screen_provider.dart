import 'package:flutter/material.dart';

import '../../../configs/components/app_flushbar.dart';
import '../../../dependency_injection/locator.dart';
import '../../../network_module/response/api_response.dart';
import '../../../services/auth/auth_service.dart';
import '../models/request_models/satsang_list_request_model.dart';
import '../models/response_models/satsang_list_response_model.dart';
import '../repository/home_api_repository.dart';

/// Loads and exposes satsang list data for [SatsangScreen].
///
/// Reads auth context and fetches paginated satsang entries from the API.
class SatsangScreenProvider extends ChangeNotifier {
  final HomeApiRepository _homeRepository = getIt<HomeApiRepository>();
  final AuthService _auth = getIt<AuthService>();

  /// Cached authenticated user data for the current session.
  AuthData? userData;

  /// Loads stored auth data and triggers the initial satsang list fetch.
  ///
  /// No-op fetch when the widget is no longer mounted.
  Future assignAUthData(BuildContext context) async {
    userData = await _auth.readAuthData();
    if (context.mounted) {
      await fetchSatsangList(context);
    }
  }

  /// API response wrapper for the satsang list request.
  ApiResponse<List<SatsangData>> satsangListRes = ApiResponse.idle();

  /// Fetches the satsang list and updates [satsangListRes].
  ///
  /// Shows success or error feedback via [AppFlushbar] when mounted.
  Future<void> fetchSatsangList(BuildContext context) async {
    satsangListRes = ApiResponse.loading("Fetching satsangList");
    notifyListeners();

    await _homeRepository
        .fetchSansangList(
          SatsangListRequestModel(pageNumber: 1, pageSize: 20).toJson(),
        )
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            satsangListRes = ApiResponse.completed(value.data ?? []);
            if (context.mounted) {
              AppFlushbar.success(
                context,
                message: value.message ?? "Satsang fetched successfully.",
              );
            }
          } else {
            final msg = value?.message ?? 'Satsang fetch failed.';
            satsangListRes = ApiResponse.error(msg);
            if (context.mounted) {
              AppFlushbar.error(context, message: msg);
            }
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          satsangListRes = ApiResponse.error(msg);
          if (context.mounted) {
            AppFlushbar.error(context, message: msg);
          }
        });

    notifyListeners();
  }
}
