import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../../utils/sp_util.dart';
import '../../../widgets/refresh_loadmore.dart';

class DraftListController extends GetxController {
  late RefreshController refreshController;
  final isLoading = false.obs;
  RxList<Map<String, dynamic>> listData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    loadDrafts();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  loadDrafts() async {
    var drafts = await SpUtil.getStorage('drafts');
    if (drafts is List) {
      listData.assignAll(drafts.cast<Map<String, dynamic>>());
    }
    refreshController.finishLoad(IndicatorResult.noMore, true);
  }

  listRefresh() {
    listData.clear();
    refreshController.resetFooter();
    return loadMore();
  }

  loadMore() async {
    await loadDrafts();
    refreshController.finishLoad(IndicatorResult.noMore, true);
  }

  deleteDraft(int index) async {
    listData.removeAt(index);
    await SpUtil.setStorage('drafts', listData.toList());
  }

  clearAll() async {
    listData.clear();
    await SpUtil.removeStorage('drafts');
  }
}
