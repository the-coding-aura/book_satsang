import 'app_config.dart';

/// Identifiers for every backend endpoint used by the app.
///
/// Pass a value to [ApiPathHelper.getValue] to resolve the full URL against
/// [AppConfig.apiBaseUrl].
enum ApiPath {
  isUserExist,
  sendOtp,
  resendOtp,
  verifyOtp,
  fetchTaluka,
  fetchDesignation,
  fetchVillage,
  registerMember,
  memberLogin,
  fetchSatsang,
  addSatsang,
  fetchMemberProfile,
  fetchAllMembers,
  refreshToken,
  uploadFile,
  logout,
}

/// Resolves [ApiPath] enum values to fully qualified API URLs.
///
/// URLs are built from [AppConfig.apiBaseUrl] and cannot be instantiated.
class ApiPathHelper {
  ApiPathHelper._();

  /// Returns the absolute URL for the given [path].
  ///
  /// Each [ApiPath] maps to a specific backend route segment.
  static String getValue(ApiPath path) {
    switch (path) {
      case ApiPath.isUserExist:
        return '${AppConfig.apiBaseUrl}/Member/MobileExists';
      case ApiPath.sendOtp:
        return '${AppConfig.apiBaseUrl}/OTP/SendOTP';
      case ApiPath.resendOtp:
        return '${AppConfig.apiBaseUrl}/Auth/ResendOTP';
      case ApiPath.memberLogin:
        return '${AppConfig.apiBaseUrl}/Member/VerifyLogin';
      case ApiPath.fetchSatsang:
        return '${AppConfig.apiBaseUrl}/Satsang/GetSatsang';
      case ApiPath.addSatsang:
        return '${AppConfig.apiBaseUrl.replaceAll(RegExp(r'/api$'), '')}/api/Satsang/AddSatsang';
      case ApiPath.verifyOtp:
        return '${AppConfig.apiBaseUrl}/OTP/VerifyOTP';
      case ApiPath.fetchTaluka:
        return '${AppConfig.apiBaseUrl}/MasterData/GetTalukaMasterData';
      case ApiPath.fetchVillage:
        return '${AppConfig.apiBaseUrl}/MasterData/GetVillageMasterData';
      case ApiPath.uploadFile:
        return '${AppConfig.apiBaseUrl}/FileHandling/UploadFile';
      case ApiPath.fetchDesignation:
        return '${AppConfig.apiBaseUrl}/MasterData/GetDesignationMasterData';
      case ApiPath.registerMember:
        return '${AppConfig.apiBaseUrl}/Member/AddMember';
      case ApiPath.fetchMemberProfile:
        return '${AppConfig.apiBaseUrl}/Member/GetMemberByToken';
      case ApiPath.fetchAllMembers:
        return '${AppConfig.apiBaseUrl.replaceAll(RegExp(r'/api$'), '')}/api/Member/GetAllMembers';
      case ApiPath.refreshToken:
        return '${AppConfig.apiBaseUrl}/Member/GetRefreshToken';
      case ApiPath.logout:
        return '${AppConfig.apiBaseUrl}/Member/VerifyLogout';
    }
  }
}
