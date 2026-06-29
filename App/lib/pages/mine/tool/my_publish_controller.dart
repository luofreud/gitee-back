import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class MyPublishController extends GetxController {
  late RefreshController refreshController;
  List<Post> listData = <Post>[].obs;
  RxBool isLoading = false.obs;
  PageRequest pageRequest = PageRequest(page: 1, pageSize: 10);

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

  listRefresh() {
    listData.clear();
    refreshController.resetFooter();
    pageRequest.page = 1;
    return listLoadMore();
  }

  listLoadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    var result = await PostApi().postPage(pageRequest);
    if (result != null) {
      listData.addAll(result.items ?? []);
      pageRequest.page = (pageRequest.page ?? 1) + 1;
      if (result.totalPages != null &&
          result.totalPages! < (pageRequest.page ?? 1)) {
        refreshController.finishLoad(IndicatorResult.noMore, true);
      } else {
        refreshController.finishLoad(IndicatorResult.success, true);
      }
    } else {
      refreshController.finishLoad(IndicatorResult.fail, true);
    }
    isLoading.value = false;
  }

  deleteItem(int id) async {
    var result = await PostApi().postDelete(id);
    if (result) {
      listData.removeWhere((e) => e.id == id);
      ToastUtil.success('删除成功');
    } else {
      ToastUtil.error('删除失败');
    }
  }
}
