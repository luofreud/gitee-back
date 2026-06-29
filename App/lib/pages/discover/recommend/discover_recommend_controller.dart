import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/article/article_plate.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

class DiscoverRecommendController extends GetxController {
  late RefreshController refreshController;
  RxList<Post> listData = <Post>[].obs;
  RxList<ArticlePlate> hotTopics = <ArticlePlate>[].obs;
  RxBool isLoading = false.obs;
  PageRequest req = PageRequest(page: 1, pageSize: 10);

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    listRefresh();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  listRefresh() async {
    listData.clear();
    req.page = 1;
    refreshController.resetFooter();
    await loadMore();
    await _loadHotTopics();
  }

  loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    var result = await PostApi().postPage(req);
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

  _loadHotTopics() async {
    var data = await PostApi().pagePlate(
      PageRequest(page: 1, pageSize: 4, field: 'count', order: 'desc'),
      filters: {'ltype': 1},
    );
    if (data?.items != null) {
      hotTopics.value = data!.items!;
    }
  }
}
