import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/user/subscribe.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class FollowListController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Tab标题：关注、收藏
  List<String> headerNavTabs = ['关注', '收藏'];

  /// 当前Tab索引：0-关注, 1-收藏
  final navTabIndex = 0.obs;

  /// Tab控制器
  late TabController tabController;

  /// 关注类型筛选：好友、咨询师、话题
  List<String> followTypes = ['好友', '咨询师', '话题'];

  /// 当前关注类型索引
  final followTypeIndex = 0.obs;

  /// 收藏类型筛选：全部、图文、测试
  List<String> collectionTypes = ['全部', '图文', '测试'];

  /// 当前收藏类型索引
  final collectionTypeIndex = 0.obs;

  /// 下拉刷新控制器
  late RefreshController refreshController;

  /// 订阅列表数据（关注/收藏共用）
  RxList<Subscribe> listData = <Subscribe>[].obs;

  /// 是否正在加载
  RxBool isLoading = false.obs;

  /// 搜索关键词
  RxString keyword = ''.obs;

  /// 搜索输入框控制器
  final TextEditingController searchController = TextEditingController();

  /// 用户API实例
  final userApi = UserApi();

  /// 分页请求参数
  PageRequest req = PageRequest(page: 1, pageSize: 10);

  @override
  void onInit() {
    super.onInit();
    // 初始化Tab控制器，默认选中第一个（关注）
    tabController = TabController(
      length: headerNavTabs.length,
      vsync: this,
      initialIndex: navTabIndex.value,
    );
    // 初始化下拉刷新控制器
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    // 监听Tab切换，切换时自动刷新列表数据
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        navTabIndex.value = tabController.index;
        listRefresh();
      }
    });
    // 监听关注类型切换，自动刷新列表
    ever(followTypeIndex, (_) => listRefresh());
    // 首次加载
    listRefresh();
  }

  /// 搜索提交
  onSearchSubmitted() {
    // 获取搜索框文本，触发刷新
    keyword.value = searchController.text;
    listRefresh();
  }

  @override
  void onClose() {
    tabController.dispose();
    refreshController.dispose();
    searchController.dispose();
    super.onClose();
  }

  /// 刷新列表（重置分页）
  listRefresh() async {
    listData.clear();
    req.page = 1;
    refreshController.resetFooter();
    await loadMore();
  }

  /// 加载更多
  loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;
    // 根据当前Tab决定stype
    var stype;
    if (navTabIndex.value == 0) {
      stype = followTypeIndex.value;
    } else {
      // 收藏Tab: 全部/图文=3, 测试=4
      stype = collectionTypeIndex.value == 2 ? 4 : 3;
    }
    var result = await userApi.userSubPage(
      PageRequest(page: req.page, pageSize: req.pageSize),
      stype: stype,
      keyword: keyword.value.isEmpty ? null : keyword.value,
    );
    if (result != null) {
      // 追加数据并翻页
      listData.addAll(result.items ?? []);
      req.page = (req.page ?? 1) + 1;
      // 判断是否还有更多数据
      if (result.totalPages != null && result.totalPages! < (req.page ?? 1)) {
        refreshController.finishLoad(IndicatorResult.noMore, true);
      } else {
        refreshController.finishLoad(IndicatorResult.success, true);
      }
    } else {
      // 请求失败
      refreshController.finishLoad(IndicatorResult.fail, true);
    }
    isLoading.value = false;
  }

  /// 取消关注/收藏
  unfollow(Subscribe item) async {
    // 调用删除接口，移除列表项
    if (await userApi.userSubDel(item.id!)) {
      listData.remove(item);
      ToastUtil.info('已取消收藏');
    }
  }
}
