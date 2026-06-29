import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

class MallChangeController extends GetxController {
  // 顶部tab容器高度
  final double kHeaderContainerHeight = 210.0;

  // 顶部tab高度
  final double kHeaderTabsHeight = 56.0;
  final kAppbarHeight = 90.0.obs;
  final appBarAlpha = 0.obs;
  late ScrollController scrollController;

  List<String> typeTabs = ['权益区', '实物区', '魔力区', '特权区'];

  late RefreshController refreshController;
  List<int> listData = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(() {
      var offset =
          kHeaderContainerHeight -
          (kHeaderTabsHeight / 2) -
          kAppbarHeight.value;
      appBarAlpha.value = (scrollController.offset / offset * 255)
          .toInt()
          .clamp(0, 255);
    });

    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  listLoadMore() {
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
