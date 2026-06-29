import 'package:freud/api/im/im_message.dart';
import 'package:freud/api/live/teacher_api.dart';
import 'package:freud/models/user/login_request.dart';
import 'package:freud/models/user/teacher.dart';
import 'package:freud/models/user/userinfo.dart';
import 'package:freud/service/im_service.dart';
import 'package:freud/utils/token_util.dart';
import 'package:get/get.dart';

import '../api/mine/user_api.dart';

class UserService extends GetxService {
  //是否登录
  bool isLogin = false;

  //用户信息
  final Rx<Userinfo?> userinfo = Rx<Userinfo?>(null);

  //导师信息（仅 utype==1 时有值）
  final Rx<Teacher?> teacherInfo = Rx<Teacher?>(null);

  @override
  void onInit() {
    super.onInit();
    //初始化
    isLogin = false;
  }

  ///
  /// 登录
  Future<bool> login(LoginRequest loginReq) async {
    final loginRes = await UserApi().login(loginReq);
    if (loginRes != null) {
      await getUserInfo();
      isLogin = true;
    }
    return isLogin;
  }

  ///
  /// 登出
  Future logout() async {
    await UserApi().logout();
    final im = Get.find<ImService>();
    await im.sendLogout();
    im.dispose();
    isLogin = false;
    userinfo.value = null;
    teacherInfo.value = null;
  }

  ///
  /// 获取用户信息
  Future<Userinfo?> getUserInfo() async {
    final userInfo = await UserApi().getUserInfo();
    if (userInfo != null) {
      isLogin = true;
      userinfo.value = userInfo;
      if (userInfo.utype == 1) {
        teacherInfo.value = await TeacherApi().teacherDetail(uid: userInfo.id);
      }
      await _initIm(userInfo);
    }
    return userinfo.value;
  }

  ///
  /// 初始化 IM 连接
  /// 获取 IM 服务器配置，比较地址变化后建立连接
  Future<void> _initIm(Userinfo userInfo) async {
    final config = await ImMessageApi().getServerConfig();
    if (config == null) return;

    final host = config['host'] as String?;
    final port = (config['tcpPort'] as num?)?.toInt();
    if (host == null || port == null) return;

    final im = Get.find<ImService>();
    if (im.isInitialized) {
      if (im.serverIp == host && im.serverPort == port) return;
      await im.sendLogout();
      im.dispose();
    }

    await im.init(serverIp: host, serverPort: port);
    final token = await TokenUtil.getToken();
    await im.connectAndLogin(
      userId: userInfo.id?.toString() ?? '',
      token: token,
    );
  }
}
