import 'package:flutter/material.dart';
import 'package:freud/pages/splash/widgets/welcome_survey.dart';
import 'package:get/get.dart';

import '../../constants/app_const.dart';
import 'splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SplashController());
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash_bg2.jpg"),
          fit: BoxFit.fitWidth, // 图片填充方式
          alignment: Alignment.topCenter,
        ),
        color: AppConst.PAGE_BACKGROUND_COLOR,
      ),
      child: Obx(() {
        Widget bodyWidget = const SizedBox.shrink();
        if (controller.welcomeSurveyShow.value) {
          bodyWidget = SplashWelcomeSurvey();
        } else {
          bodyWidget = _SplashWelcomeWidget(controller: controller);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white.withAlpha(0),
            actions: controller.welcomeSurveyShow.value
                ? [
                    GestureDetector(
                      onTap: () {
                        controller.goLogin();
                      },
                      child: Text('跳过'),
                    ),
                    const SizedBox(width: AppConst.PAGE_PADDING),
                  ]
                : [],
          ),
          backgroundColor: Colors.transparent,
          body: bodyWidget,
        );
      }),
    );
  }
}

class _SplashWelcomeWidget extends StatelessWidget {
  final SplashController controller;

  const _SplashWelcomeWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Obx(() {
          return AnimatedOpacity(
            opacity: controller.logoOpacity.value,
            duration: const Duration(milliseconds: 1000),
            onEnd: () {
              controller.showWelcomeText();
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic_launcher.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/images/logo_text.png', width: 80),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        }),

        Obx(() {
          if (!controller.welcomeTextShow.value) {
            return const SizedBox.shrink();
          }
          var duration = const Duration(milliseconds: 600);
          return Positioned(
            top: 30,
            child: AnimatedOpacity(
              opacity: controller.welcomeTextHide.value ? 0.0 : 1,
              duration: duration,
              onEnd: () {
                controller.welcomeSurveyShow.value = true;
              },
              child: Column(
                spacing: 5,
                children: [
                  ...controller.textList.asMap().entries.map((item) {
                    var index = item.key;
                    TextStyle textStyle = index == 0
                        ? TextStyle(fontSize: 28, color: Color(0xff0091FF))
                        : TextStyle(fontSize: 16, color: Color(0xff3C5E91));
                    return AnimatedOpacity(
                      opacity: controller.textListIsShow[index] ? 1 : 0,
                      duration: duration,
                      onEnd: () {
                        if (index + 1 < controller.textListIsShow.length) {
                          controller.textListIsShow[index + 1] = true;
                        } else {
                          //显示调查界面
                          Future.delayed(const Duration(milliseconds: 800), () {
                            controller.welcomeTextHide.value = true;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: duration,
                        margin: EdgeInsets.only(bottom: index == 0 ? 15 : 0),
                        transform: Matrix4.translationValues(
                          0,
                          controller.textListIsShow[index] ? 0 : 20,
                          0,
                        ),
                        child: Text(item.value, style: textStyle),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
