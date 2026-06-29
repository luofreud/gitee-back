import 'package:freud/models/user/login_request.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/sp_util.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  int countdownDeafult = 10;
  final mobile = "".obs;
  final captcha = "".obs;
  final agree = false.obs;
  late final countdown = countdownDeafult.obs;
  bool getCaptchaIng = false;
  bool captchaFutureCancel = false;

  @override
  void onInit() async {
    super.onInit();
    agree.value = await SpUtil.containsKey('user_agreement');
  }

  /// 执行登录逻辑
  doLogin() async {
    // TODO: 登录
    CommonUtil.hideKeyShowUnfocus();
    if (!agree.value) {
      ToastUtil.info('请阅读协议并勾选同意');
      return;
    }
    SpUtil.setStorage('user_agreement', '1');
    final loginRes = await Get.find<UserService>().login(
      LoginRequest(phone: mobile.value, code: captcha.value),
    );
    if (loginRes) {
      Get.offAllNamed(AppRoutes.MAIN);
    } else {
      // ToastUtil.info('验证码错误');
    }
  }

  /// 获取验证码
  getCaptcha() {
    // TODO: 获取验证码
    if (getCaptchaIng) {
      return;
    }
    if (mobile.value.isEmpty) {
      ToastUtil.info('请输入手机号码');
      return;
    }
    CommonUtil.hideKeyShowUnfocus();
    getCaptchaIng = true;
    // 模拟耗时
    Future.delayed(Duration(milliseconds: 500), () {
      getCaptchaIng = false;
      _captchaCountdown();
    });
  }

  /// 验证码倒计时
  _captchaCountdown() {
    if (countdown.value <= 0) {
      countdown.value = countdownDeafult;
      return;
    }
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!captchaFutureCancel) {
        countdown.value--;
        _captchaCountdown();
      }
    });
  }

  @override
  void onClose() {
    captchaFutureCancel = true;
    super.onClose();
  }
}
