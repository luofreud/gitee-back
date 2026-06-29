import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounselorRegController extends GetxController {
  final currentStep = 0.obs;
  late final PageController pageController;

  final applyResultStatus = 0.obs;

  final List serviceTypes = ['星盘', '双人合盘', '骰子', '塔罗', '心理'];
  final List fieldTypes = ['婚姻情感', '心理健康', '运势发展', '学业事业', '学业事业', '正缘桃花'];
  final List styleTypes = ['精准直接', '善解人意', '温柔细腻', '心灵启发', '温暖关怀', '耐心倾听'];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentStep.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void nextStep(int index) {
    currentStep.value = index;
    pageController.jumpToPage(currentStep.value);
  }
}
