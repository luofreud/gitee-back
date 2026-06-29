import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

class RevenueRecordController extends GetxController {
  late RefreshController refreshController;
  final isLoading = false.obs;
  final isNoMore = false.obs;
  List listData = [
    {
      "type": "month",
      "data": {"month": "2026年3月", "total": 1000},
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    listData.addAll(
      List.generate(10, (index) {
        return {"type": "data", "data": index + 1};
      }).toList(),
    );
  }

  @override
  void onClose() {
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
    return Future.delayed(Duration(seconds: 2), () {
      listData.add({
        "type": "month",
        "data": {"month": "2026年4月", "total": 1000},
      });
      listData.addAll(
        List.generate(10, (index) {
          return {"type": "data", "data": index + 1};
        }).toList(),
      );
      isLoading.value = false;
      if (listData.length > 25) {
        isNoMore.value = true;
        refreshController.finishLoad(IndicatorResult.noMore, true);
      }
    });
  }
}
