import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/api/mine/tool_api.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

class ArchiveSelectController extends GetxController {
  late RefreshController refreshController;
  final isLoading = false.obs;
  RxList<Archive> listData = <Archive>[].obs;
  PageRequest req = PageRequest(page: 1, pageSize: 20);
  String keyword = '';

  int? requiredCount;
  final selectedIds = <int>[].obs;

  bool get isMultiSelect => requiredCount != null && requiredCount! > 1;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      requiredCount = args['num'] as int?;
      final rawIds = args['ids'];
      if (rawIds is List) selectedIds.addAll(rawIds.whereType<int>());
    }
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
  }

  loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    var data = req.toJson();
    if (keyword.isNotEmpty) data['keyword'] = keyword;
    var result = await ToolApi().archivePage(req, filters: data);
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

  onSearchSubmitted(String value) {
    keyword = value;
    listRefresh();
  }

  void toggleSelection(Archive archive) {
    final id = archive.id;
    if (id == null) return;
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      if (isMultiSelect &&
          requiredCount != null &&
          selectedIds.length >= requiredCount!)
        return;
      selectedIds.add(id);
    }
    print(isMultiSelect);
    print(selectedIds.length);
    if (!isMultiSelect) Get.back(result: archive);
  }

  void confirmSelection() {
    final selected = listData
        .where((a) => a.id != null && selectedIds.contains(a.id))
        .toList();
    Get.back(result: selected);
  }
}
