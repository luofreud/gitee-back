import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/utils/utils.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

class MyArchiveController extends GetxController {
  final showTips = true.obs;

  late RefreshController refreshController;
  RxList<Archive> listData = <Archive>[].obs;
  RxBool isLoading = false.obs;
  PageRequest req = PageRequest(page: 1, pageSize: 10);

  @override
  void onInit() {
    super.onInit();

    SpUtil.getStorage('archive_hide_tips').then((res) {
      showTips.value = res != 1;
    });

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

  //隐藏提示
  hideDeleteTips() {
    showTips.value = false;
    SpUtil.setStorage('archive_hide_tips', "1");
  }

  listRefresh() async {
    listData.clear();
    refreshController.resetFooter();
    req.page = 1;
    await listLoadMore();
  }

  listLoadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    var result = await ToolApi().archivePage(req);
    listData.addAll(result?.items ?? []);
    isLoading.value = false;
    if (result?.totalPages == req.page) {
      refreshController.finishLoad(IndicatorResult.noMore, true);
    } else {
      req.page = req.page! + 1;
    }
  }

  archiveDel(int id) async {
    var result = await ToolApi().archiveDelete(id);
    if (result) {
      listData.removeWhere((element) => element.id == id);
      listData.refresh();
      ToastUtil.info('删除成功');
    }
  }
}
