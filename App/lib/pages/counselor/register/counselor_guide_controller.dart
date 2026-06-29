import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounselorGuideController extends GetxController {
  final appBarAlpha = 0.obs;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      final _scrollPosition = scrollController.position.pixels;
      final int _alpha = (_scrollPosition / 140 * 255).toInt();
      appBarAlpha.value = _alpha.clamp(0, 255);
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
