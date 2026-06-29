import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/api/live/live_api.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import '../../../models/live/live_room.dart';
import '../../../models/live/live_room_page_request.dart';

class OnlineMainController extends GetxController {
  late RefreshController refreshController;
  final liveApi = LiveApi();

  final isLoading = false.obs;
  List<LiveRoom> liveRoomList = <LiveRoom>[].obs;
  List<LiveRoom> topLiveRoomList = <LiveRoom>[].obs;
  final page = 1.obs;
  final total = 0.obs;
  final pageSize = 10;

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
      "key": "zt",
      "title": "状态",
      "values": [
        {"key": "lmz", "title": "连麦中"},
        {"key": "kx", "title": "空闲"},
      ],
    },
  ];
  final filterQuery = {"zy": "", "jn": "", "zt": ""};

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    listRefresh();
    loadTopLiveRooms();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void loadTopLiveRooms() async {
    var request = LiveRoomPageRequest(page: 1, pageSize: 10);
    var result = await liveApi.getTopLiveRoomList(request);
    if (result?.result?.items != null) {
      topLiveRoomList.clear();
      topLiveRoomList.addAll(result!.result!.items ?? []);
    }
  }

  listRefresh() async {
    liveRoomList.clear();
    page.value = 1;
    refreshController.resetFooter();
    loadTopLiveRooms();
    return loadMore();
  }

  loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;

    var request = LiveRoomPageRequest(page: page.value, pageSize: pageSize);

    var result = await liveApi.getLiveRoomList(request);

    if (result?.result?.items != null) {
      liveRoomList.addAll(result!.result!.items!);
      total.value = result.result!.total ?? 0;

      if (liveRoomList.length >= total.value) {
        refreshController.finishLoad(IndicatorResult.noMore, true);
      }
    } else {
      refreshController.finishLoad(IndicatorResult.noMore, true);
    }

    isLoading.value = false;
    page.value++;
  }
}
