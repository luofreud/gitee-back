import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

class QaSquareController extends GetxController {
  late RefreshController refreshController;
  final listData = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final List<Map<String, dynamic>> _mockData = [
    {
      'icon': 'assets/images/home_nav_xp.png',
      'category': '星盘',
      'title': '你肯定会中这几条星座分析',
      'askCount': 123,
    },
    {
      'icon': 'assets/images/home_nav_xp.png',
      'category': '星盘',
      'title': '这些性格的星座是最好避开的',
      'askCount': 89,
    },
    {
      'icon': 'assets/images/home_nav_xp.png',
      'category': '骰子',
      'title': '测测你星盘基础知识掌握多少',
      'askCount': 256,
    },
    {
      'icon': 'assets/images/home_nav_xp.png',
      'category': '塔罗',
      'title': '做这些事情可以让你财运更好哦',
      'askCount': 67,
    },
    {
      'icon': 'assets/images/home_nav_xp.png',
      'category': '合盘',
      'title': '年运测算，看看你的2026年运势如何',
      'askCount': 312,
    },
    {
      'icon': 'assets/images/home_nav_xp.png',
      'category': '星盘',
      'title': '十二星座谁最擅长隐藏自己的情绪',
      'askCount': 45,
    },
    {
      'icon': 'assets/images/home_nav_xp.png',
      'category': '骰子',
      'title': '最近三个月你的财运走势预测',
      'askCount': 178,
    },
    {
      'icon': 'assets/images/home_nav_xp.png',
      'category': '塔罗',
      'title': '这段感情是否值得继续坚持下去',
      'askCount': 234,
    },
  ];

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

  Future<void> listRefresh() async {
    listData.clear();
    refreshController.resetFooter();
    await loadMore();
  }

  Future<void> loadMore() async {
    if (isLoading.value) return;
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    listData.addAll(_mockData);

    // refreshController.finishLoad(IndicatorResult.noMore, true);
    isLoading.value = false;
  }
}
