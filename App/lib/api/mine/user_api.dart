import 'package:freud/utils/request_util.dart';

import '../../models/base/base_response.dart';
import '../../models/base/page_request.dart';
import '../../models/base/page_response.dart';
import '../../models/user/login_request.dart';
import '../../models/user/login_response.dart';
import '../../models/user/subscribe.dart';
import '../../models/user/userinfo.dart';

class UserApi {
  ///获取登录验证码
  // Future<Captcha?> getCaptcha() async {
  //   var res = await RequestUtil.getInstance().get("/appXzUser/captcha");
  //   if (res?.code != 200) return null;
  //   var resJson = BaseRes<Captcha>.fromJson(
  //     res?.data,
  //     (result) => Captcha.fromJson(result),
  //   );
  //   if (resJson.code == 200) {
  //     return resJson.result;
  //   }
  //   return null;
  // }

  ///帐号密码登录
  Future<LoginResponse?> login(LoginRequest loginReq) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/loginPhone",
      data: loginReq.toJson(),
      showLoad: true,
      loadText: "登录中...",
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse<LoginResponse>.fromJson(
      res?.data,
      (result) => LoginResponse.fromJson(result),
    );
    return resJson.result;
  }

  /// 退出登录
  Future<bool> logout() async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/logout",
      showError: false,
    );
    if (res?.code != 200) return false;
    await TokenUtil.clear();
    return true;
  }

  /// 注销用户，删除用户账号
  Future<bool> delete() async {
    var res = await RequestUtil.getInstance().delete("/appXzUser/use");
    if (res?.code != 200) return false;
    await TokenUtil.clear();
    return true;
  }

  ///获取当前登录用户信息
  Future<Userinfo?> getUserInfo() async {
    var res = await RequestUtil.getInstance().get("/appXzUser/userInfo");
    if (res?.code != 200) return null;
    var resJson = BaseResponse<Userinfo>.fromJson(
      res?.data,
      (result) => Userinfo.fromJson(result),
    );
    return resJson.result;
  }

  Future<bool> updateUserNick(dynamic data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/editNick",
      data: data,
      showLoad: true,
    );
    if (res?.code != 200) return false;
    return true;
  }

  Future<bool> updateUserSex(dynamic data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/editSex",
      data: data,
      showLoad: true,
    );
    if (res?.code != 200) return false;
    return true;
  }

  Future<bool> updateUserSign(dynamic data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/editSignature",
      data: data,
      showLoad: true,
    );
    if (res?.code != 200) return false;
    return true;
  }

  Future<bool> updateUserBirthday(dynamic data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/editBirthday",
      data: data,
      showLoad: true,
    );
    if (res?.code != 200) return false;
    return true;
  }

  Future<bool> updateUserAddress(dynamic data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/editAddress",
      data: data,
      showLoad: true,
    );
    if (res?.code != 200) return false;
    return true;
  }

  Future<bool> updateUserNowAddress(dynamic data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/editNowAddress",
      data: data,
      showLoad: true,
    );
    if (res?.code != 200) return false;
    return true;
  }

  Future<bool> updateUserAvatar(dynamic data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/editAvatar",
      data: data,
      showLoad: true,
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 分页查询关注列表
  Future<PageData<Subscribe>?> userSubPage(
    PageRequest req, {
    int? uid,
    int? corrid,
    int? stype,
    String? keyword,
  }) async {
    var data = req.toJson();
    if (uid != null) data['uid'] = uid;
    if (corrid != null) data['corrid'] = corrid;
    if (stype != null) data['stype'] = stype;
    if (keyword != null) data['keyword'] = keyword;
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/userSubPage",
      data: data,
    );
    if (res?.code != 200) return null;
    var resJson = PageResponse<Subscribe>.fromJson(
      res?.data,
      (data) => Subscribe.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 关注
  Future<bool> userSubAdd(Map<String, dynamic> data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/userSubAdd",
      data: data,
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 取消关注
  Future<bool> userSubDel(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzUser/userSubDel",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }
}
