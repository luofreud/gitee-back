import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class MytipsOrderController extends GetxController {
  late RefreshController refreshController;
  List<int> listData = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
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
    return Future.delayed(Duration(seconds: 5), () {
      listData.addAll(List.generate(10, (index) => length + index));
      isLoading.value = false;
      if (listData.length > 25) {
        refreshController.finishLoad(IndicatorResult.noMore, true);
      }
    });
  }
}
