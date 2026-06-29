import 'package:flutter/material.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/sp_util.dart';
import 'package:get/get.dart';

class FortuneHumanController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final tabs = ['日度', '月度', '年度'];
  final tabIndex = 0.obs;
  late TabController tabController;
  late PageController pageController;

  final currentArchive = Rx<Archive?>(null);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: tabIndex.value,
    );
    pageController = PageController(initialPage: tabIndex.value);
    _loadCachedArchive();
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

  Future<void> _loadCachedArchive() async {
    try {
      final cached = await SpUtil.getStorage('home_current_archive');
      if (cached != null) {
        final archive = Archive.fromJson(Map<String, dynamic>.from(cached));
        currentArchive.value = archive;
      }
    } catch (_) {}
  }

  Future<void> onSelectArchive() async {
    final result = await Get.toNamed(AppRoutes.ARCHIVE_SELECT);
    if (result is Archive && result.id != null) {
      currentArchive.value = result;
    }
  }
}
