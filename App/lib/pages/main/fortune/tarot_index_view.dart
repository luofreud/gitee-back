import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:get/get.dart';

import 'tarot_index_controller.dart';

/// 塔罗页面
class TarotIndexPage extends GetView<TarotIndexController> {
  const TarotIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TarotIndexController());
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/tarot_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('智慧牌', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black.withAlpha(0),
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 30,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/tarot_banner.png',
                width: 240,
                height: 110,
              ),
              _TarotPoker(),
              const SizedBox(height: 20),
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  color: Color(0xff3D3042),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffC9AD87).withAlpha(80)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 90,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '准备好了吗？点击抽取开始吧',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffC7AB87),
                        ),
                      ),
                      Text(
                        '摒除杂念，集中精神',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffC7AB87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.TAROT_DRAW);
                },
                child: IconWidget(icon: 'tarot_start.png', size: 96),
              ),
              const SizedBox(height: 20, width: double.infinity),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarotPoker extends StatelessWidget {
  const _TarotPoker({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.rotate(
          angle: 20 * pi / 180,
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(40, 5),
            child: Image.asset(
              'assets/images/tarot_poker.png',
              width: 98,
              height: 154,
            ),
          ),
        ),
        Transform.rotate(
          angle: 10 * pi / 180,
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(25, 2.5),
            child: Image.asset(
              'assets/images/tarot_poker.png',
              width: 98,
              height: 154,
            ),
          ),
        ),
        Transform.rotate(
          angle: -20 * pi / 180,
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(-40, 5),
            child: Image.asset(
              'assets/images/tarot_poker.png',
              width: 98,
              height: 154,
            ),
          ),
        ),
        Transform.rotate(
          angle: -10 * pi / 180,
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(-25, 2.5),
            child: Image.asset(
              'assets/images/tarot_poker.png',
              width: 98,
              height: 154,
            ),
          ),
        ),
        Image.asset('assets/images/tarot_poker.png', width: 98, height: 154),
      ],
    );
  }
}
