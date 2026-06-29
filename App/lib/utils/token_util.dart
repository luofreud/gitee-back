import '../constants/app_const.dart';
import 'sp_util.dart';

class TokenUtil {
  static const String _tokenKey = "accessToken";
  static const String _refreshTokenKey = "refreshToken";

  static const String _apiBaseUrlKey = "apiBaseUrl";
  static String? _apiBaseUrl;

  ///当前设置的自定义服务器地址
  static String? get apiBaseUrl => _apiBaseUrl;

  static Future init() async {
    _apiBaseUrl = await SpUtil.getStorage(_apiBaseUrlKey) ?? "";
  }

  ///设置token
  static setToken({String? accessToken, String? refreshToken}) {
    if (accessToken != null && accessToken.isNotEmpty) {
      SpUtil.setStorage(_tokenKey, accessToken, encrypt: true);
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      SpUtil.setStorage(_refreshTokenKey, refreshToken, encrypt: true);
    }
  }

  ///获取token
  static Future<String> getToken() async {
    return await SpUtil.getStorage(_tokenKey, encrypt: true) ?? '';
  }

  ///获取刷新token
  static Future<String> getRefreshToken() async {
    return await SpUtil.getStorage(_refreshTokenKey, encrypt: true) ?? '';
  }

  ///清除token
  static Future clear() async {
    await SpUtil.removeStorage(_tokenKey);
    await SpUtil.removeStorage(_refreshTokenKey);
  }

  ///设置服务器地址
  static Future setServer(String url) async {
    await SpUtil.setStorage(_apiBaseUrlKey, url);
    _apiBaseUrl = url;
  }

  ///获取服务器地址，如果未自定义设置，则返回系统默认地址
  static String getServer() {
    return _apiBaseUrl == null || _apiBaseUrl!.isEmpty
        ? AppConst.API_BASE_URL
        : _apiBaseUrl!;
  }
}
