import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import 'dice_index_controller.dart';

class DiceIndexPage extends GetView<DiceIndexController> {
  const DiceIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DiceIndexController());
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dice_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('骰子', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black.withAlpha(0),
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 320),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff202A3B).withAlpha(125),
                ),
                padding: const EdgeInsets.all(8),
                child: TextField(
                  maxLines: null,
                  minLines: 5,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '一次只能咨询一个问题，请描述三个月内具体的问题或疑惑~',
                    hintStyle: TextStyle(color: Color(0xff828282)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xff53586E).withAlpha(180),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xff53586E).withAlpha(180),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xff53586E).withAlpha(180),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              Row(
                children: [
                  Obx(() {
                    return CircleCheckbox(
                      value: controller.syncQuestion.value,
                      side: BorderSide(width: 1, color: Color(0xff808080)),
                      fillColor: Colors.transparent,
                      onChanged: (value) {
                        controller.syncQuestion.value = value ?? false;
                      },
                    );
                  }),
                  GestureDetector(
                    onTap: () {
                      controller.syncQuestion.value =
                          !controller.syncQuestion.value;
                    },
                    child: Text(
                      '是否将问题匿名同步到社区',
                      style: TextStyle(fontSize: 12, color: Color(0xff828282)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GradientButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.DICE_DETAIL);
                },
                width: double.infinity,
                height: 40,
                foregroundColor: Color(0xffFFD0A1),
                gradient: LinearGradient(
                  colors: [Color(0xff4D1FAE), Color(0xff22419C)],
                ),
                child: Text('掷骰子'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
