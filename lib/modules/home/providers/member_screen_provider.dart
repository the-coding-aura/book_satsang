import 'package:flutter/material.dart';

import '../../../configs/components/app_flushbar.dart';
import '../../../dependency_injection/locator.dart';
import '../../../network_module/response/api_response.dart';
import '../../../services/auth/auth_service.dart';
import '../models/response_models/member_list_response_model.dart';
import '../repository/home_api_repository.dart';

/// Loads and exposes member list data for [MemberScreen].
class MemberScreenProvider extends ChangeNotifier {
  final HomeApiRepository _homeRepository = getIt<HomeApiRepository>();
  final AuthService _auth = getIt<AuthService>();

  /// Cached authenticated user data for the current session.
  AuthData? userData;

  /// API response wrapper for the member list request.
  ApiResponse<List<MemberData>> memberListRes = ApiResponse.idle();

  /// Loads stored auth data and triggers the initial member list fetch.
  Future<void> assignAuthData(BuildContext context) async {
    userData = await _auth.readAuthData();
    if (context.mounted) {
      await fetchMemberList(context);
    }
  }

  /// Fetches the member list and updates [memberListRes].
  Future<void> fetchMemberList(
    BuildContext context, {
    bool showSuccessMessage = true,
  }) async {
    memberListRes = ApiResponse.loading('Fetching members');
    notifyListeners();

    await _homeRepository
        .fetchAllMembers()
        .then((value) async {
          if (value != null &&
              value.isSuccessful == true &&
              value.data != null) {
            memberListRes = ApiResponse.completed(value.data ?? []);
            if (context.mounted && showSuccessMessage) {
              AppFlushbar.success(
                context,
                message: value.message ?? 'Members fetched successfully.',
              );
            }
          } else {
            final msg = value?.message ?? 'Member fetch failed.';
            memberListRes = ApiResponse.error(msg);
            if (context.mounted) {
              AppFlushbar.error(context, message: msg);
            }
          }
        })
        .onError((error, _) {
          final msg = error.toString();
          memberListRes = ApiResponse.error(msg);
          if (context.mounted) {
            AppFlushbar.error(context, message: msg);
          }
        });

    notifyListeners();
  }
}
