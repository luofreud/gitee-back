import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class TestOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<String> headerNavTabs = ['热门测评', '我的测评'];
  final navTabIndex = 0.obs;
  late TabController tabController;

  List<String> hotTestTypes = ['全部', '年度', '情感', '财富', '职场学业'];
  final testTypeIndex = 0.obs;

  late RefreshController refreshController;
  List<int> listData = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: headerNavTabs.length,
      vsync: this,
      initialIndex: navTabIndex.value,
    );
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  listRefresh() {
    listData.clear();
    refreshController.resetFooter();
    return loadMore();
  }

  loadMore() {
    if (isLoading.value) return;
    int length = listData.length;
    isLoading.value = true;
    return Future.delayed(Duration(seconds: 5), () {
      listData.addAll(List.generate(10, (index) => length + index));
      isLoading.value = false;
      if (listData.length > 25) {
        refreshController.finishLoad(IndicatorResult.noMore, true);
      }
    });
  }
}
