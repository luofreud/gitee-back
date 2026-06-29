import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnlineController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  final tabIndex = 0.obs;

  final List<String> tabs = ['在线', '1对1', '问答'];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: tabIndex.value,
    );
    pageController = PageController(initialPage: tabIndex.value);
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    tabIndex.value = index;
    tabController.animateTo(index);
    pageController.jumpToPage(index);
  }
}
