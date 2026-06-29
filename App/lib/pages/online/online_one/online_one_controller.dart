import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

import '../../../api/live/teacher_api.dart';
import '../../../models/base/page_request.dart';
import '../../../models/user/teacher.dart';
import '../../../widgets/refresh_loadmore.dart';

class OnlineOneController extends GetxController {
  late RefreshController refreshController;

  final isLoading = false.obs;
  RxList<Teacher> listData = <Teacher>[].obs;
  final req = PageRequest(page: 1, pageSize: 10);

  final filterActiveKey = ''.obs;
  final List filterList = [
    {
      "key": "zy",
      "title": "专业",
      "values": [
        {"key": "xp", "title": "星盘"},
        {"key": "hp", "title": "和盘"},
        {"key": "tl", "title": "塔罗"},
      ],
    },
    {
      "key": "jn",
      "title": "技能",
      "values": [
        {"key": "pt", "title": "普通"},
        {"key": "zj", "title": "中级"},
        {"key": "gj", "title": "高级"},
        {"key": "zs", "title": "资深"},
      ],
    },
    {
      "key": "zl",
      "title": "资历",
      "values": [
        {"key": "yi", "title": "一年"},
        {"key": "san", "title": "三年"},
        {"key": "wu", "title": "五年"},
        {"key": "wnys", "title": "五年以上"},
      ],
    },
  ];

  final filterOrder = [
    {"key": "", "title": "默认排序"},
    {"key": "doubtnum", "title": "好评排序"},
    {"key": "oliveprice", "title": "价格排序"},
  ];

  final filterQuery = {"zy": "", "jn": "", "zl": "", "order": ""};

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
    req.page = 1;
    return loadMore();
  }

  loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    switch (filterQuery["order"]) {
      case "":
        req.field = null;
        req.order = null;
        break;
      case "doubtnum":
        req.field = "doubtnum";
        req.order = "desc";
        break;
      case "oliveprice":
        req.field = "oliveprice";
        req.order = "asc";
        break;
    }
    var result = await TeacherApi().pageTeacher(
      req,
      filters: _buildFilterParams(),
    );
    listData.addAll(result?.items ?? []);
    isLoading.value = false;
    if (result?.totalPages == req.page) {
      refreshController.finishLoad(IndicatorResult.noMore, true);
    } else {
      req.page = req.page! + 1;
    }
  }

  Map<String, dynamic> _buildFilterParams() {
    final params = <String, dynamic>{};
    final zy = filterQuery["zy"] ?? "";
    if (zy.isNotEmpty) params["tags"] = zy;
    final jn = filterQuery["jn"] ?? "";
    if (jn.isNotEmpty) params["level"] = jn;
    final zl = filterQuery["zl"] ?? "";
    if (zl.isNotEmpty) params["year"] = zl;
    return params;
  }

  void setFilter(String key, String value) {
    filterQuery[key] = value;
    listRefresh();
  }
}
