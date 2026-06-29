import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());
    return GestureDetector(
      onTap: () => CommonUtil.hideKeyShowUnfocus(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _MobileLogin()),
            _OtherLogin(),
            const SizedBox(height: 100, width: double.infinity),
          ],
        ),
      ),
    );
  }
}

class _MobileLogin extends StatelessWidget {
  const _MobileLogin({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.find();
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              // color: Color(0xffE8E8E8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset('assets/images/ic_launcher.png', width: 70),
            ),
          ),
          Image.asset('assets/images/logo_text.png', width: 90),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF7FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text('+86'),
                SizedBox(
                  height: 20,
                  child: VerticalDivider(color: Color(0xffDAE2E8)),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '请输入手机号',
                      hintStyle: TextStyle(color: Color(0xffA6A6A6)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (text) {
                      controller.mobile.value = text;
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF7FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '请输入验证码',
                      hintStyle: TextStyle(color: Color(0xffA6A6A6)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (text) {
                      controller.captcha.value = text;
                    },
                  ),
                ),
                Obx(() {
                  var text = controller.countdown.value;
                  if (text < controller.countdownDeafult) {
                    return Text(
                      '${text}s',
                      style: TextStyle(color: Color(0xffA6A6A6)),
                    );
                  }
                  return GestureDetector(
                    onTap: controller.getCaptcha,
                    child: Text(
                      '获取验证码',
                      style: TextStyle(color: Color(0xff2A82E4)),
                    ),
                  );
                }),
              ],
            ),
          ),
          Obx(() {
            Function()? onTap;
            if (controller.mobile.isNotEmpty && controller.captcha.isNotEmpty) {
              onTap = controller.doLogin;
            }
            return GradientButton(
              onPressed: onTap,
              width: double.infinity,
              height: 50,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Color(0xffD8D6FF),
              gradient: LinearGradient(
                colors: [Color(0xff4C1FAD), Color(0xff0A2063)],
              ),
              child: Text('登录'),
            );
          }),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, -3),
                child: Transform.scale(
                  scale: 0.9,
                  child: Obx(() {
                    return CircleCheckbox(
                      value: controller.agree.value,
                      onChanged: (check) {
                        controller.agree.value = check ?? false;
                      },
                    );
                  }),
                ),
              ),
              // const SizedBox(width: 3),
              Expanded(
                child: Wrap(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.agree.value = !controller.agree.value;
                      },
                      child: Text('我已阅读并同意', style: TextStyle(fontSize: 12)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.PROTOCOL,
                          parameters: {'type': 'service'},
                        );
                      },
                      child: Text(
                        '《用户服务协议》',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff2A82E4),
                        ),
                      ),
                    ),
                    Text('和', style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.PROTOCOL,
                          parameters: {'type': 'privacy'},
                        );
                      },
                      child: Text(
                        '《隐私协议》',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff2A82E4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 其它方式登录
class _OtherLogin extends StatelessWidget {
  const _OtherLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          children: [
            SizedBox(width: 40, child: const Divider(color: Color(0xffA6A6A6))),
            Text('其它方式登录', style: const TextStyle(color: Color(0xffA6A6A6))),
            SizedBox(width: 40, child: const Divider(color: Color(0xffA6A6A6))),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: const Color(0xffF7FAFC),
                radius: 18,
                child: Image.asset('assets/icons/icon_wechat.png', width: 22),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: const Color(0xffF7FAFC),
                radius: 18,
                child: Image.asset('assets/icons/icon_qq.png', width: 22),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: const Color(0xffF7FAFC),
                radius: 18,
                child: CircleAvatar(
                  backgroundColor: const Color(0xffE63535),
                  radius: 13,
                  foregroundColor: Colors.white,
                  child: Text(
                    '身份\n认证',
                    style: TextStyle(
                      fontSize: 9,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
