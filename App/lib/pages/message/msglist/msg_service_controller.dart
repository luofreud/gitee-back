import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class MsgServiceController extends GetxController {
  late RefreshController refreshController;
  final isLoading = false.obs;
  final isNoMore = false.obs;
  List<int> listData = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].obs;

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

  loadMore() {
    if (isLoading.value) return;
    int length = listData.length;
    isLoading.value = true;
    return Future.delayed(Duration(seconds: 2), () {
      listData.addAll(List.generate(10, (index) => length + index));
      isLoading.value = false;
      if (listData.length > 25) {
        isNoMore.value = true;
        refreshController.finishLoad(IndicatorResult.noMore, true);
      }
    });
  }
}
