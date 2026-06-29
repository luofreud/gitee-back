import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/article/article_plate.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class TopicListController extends GetxController {
  late RefreshController refreshController;
  final isLoading = false.obs;
  final isNoMore = false.obs;
  final keyword = ''.obs;
  final listData = <ArticlePlate>[].obs;
  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    loadMore();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  listRefresh() {
    _page = 1;
    listData.clear();
    isNoMore.value = false;
    refreshController.resetFooter();
    return loadMore();
  }

  search(String value) {
    keyword.value = value;
    _page = 1;
    listData.clear();
    isNoMore.value = false;
    loadMore();
  }

  loadMore() async {
    if (isLoading.value || isNoMore.value) return;
    isLoading.value = true;
    var filters = <String, dynamic>{'ltype': 1};
    if (keyword.isNotEmpty) filters['keyword'] = keyword.value;
    var data = await PostApi().pagePlate(
      PageRequest(page: _page, pageSize: 10),
      filters: filters,
    );
    if (data != null && data.items != null) {
      listData.addAll(data.items!);
      if (data.hasNextPage == false) {
        isNoMore.value = true;
        refreshController.finishLoad(IndicatorResult.noMore, true);
      } else {
        refreshController.finishLoad(IndicatorResult.success, true);
      }
    }
    _page++;
    isLoading.value = false;
  }
}
