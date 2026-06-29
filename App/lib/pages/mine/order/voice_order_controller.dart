import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:freud/api/mine/order_api.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/live/live_connect_record.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class VoiceOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<String> headerNavTabs = ['直播连麦', '语音通话'];
  final navTabIndex = 0.obs;
  late TabController tabController;

  late RefreshController refreshController;
  RxList<LiveConnectRecord> listData = <LiveConnectRecord>[].obs;
  RxBool isLoading = false.obs;

  final orderApi = OrderApi();
  PageRequest req = PageRequest(page: 1, pageSize: 10);

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
    listRefresh();
  }

  @override
  void onClose() {
    tabController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  listRefresh() async {
    listData.clear();
    req.page = 1;
    refreshController.resetFooter();
    await loadMore();
  }

  loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    var data = <String, dynamic>{};
    if (navTabIndex.value == 1) {
      data['itype'] = 2;
    } else {
      data['itype'] = 1;
    }
    var result = await orderApi.imlogPage(
      PageRequest(page: req.page, pageSize: req.pageSize),
      data: data,
    );
    if (result != null) {
      listData.addAll(result.items ?? []);
      req.page = (req.page ?? 1) + 1;
      if (result.totalPages != null && result.totalPages! < (req.page ?? 1)) {
        refreshController.finishLoad(IndicatorResult.noMore, true);
      } else {
        refreshController.finishLoad(IndicatorResult.success, true);
      }
    } else {
      refreshController.finishLoad(IndicatorResult.fail, true);
    }
    isLoading.value = false;
  }

  deleteItem(LiveConnectRecord item) async {
    if (await orderApi.imlogDelete(item.id!)) {
      listData.remove(item);
      ToastUtil.info('删除成功');
    }
  }
}
