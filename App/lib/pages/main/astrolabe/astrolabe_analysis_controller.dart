import 'package:flutter/material.dart';
import 'package:freud/api/mine/tool_api.dart';
import 'package:freud/api/xingpan/xingpan_api.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/models/tool/astrocalendar.dart';
import 'package:freud/models/xingpan/xingpan_request.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/sp_util.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class AstrolabeAnalysisController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// 七个星盘标签：合盘、天象、本命、行运、法达、次限、三限
  final tabs = ['合盘', '天象', '本命', '行运', '法达', '次限', '三限', '日返', '月返'];
  late TabController tabController;

  /// 本命盘下的子标签：星座解读、落宫分析、相位解析
  final birthChartTabs = ['星座解读', '落宫分析']; //, '相位解析'
  final birthChartTabStr = '星座解读'.obs;

  /// 根据已有数据动态显示的 tab 列表
  List<String> get availableBirthChartTabs {
    final tabs = <String>[];
    if (xzjdList.isNotEmpty) tabs.add('星座解读');
    if (lgfxList.isNotEmpty) tabs.add('落宫分析');
    return tabs;
  }

  /// 当前选中的档案 ID，从路由参数获取
  int? archiveId;

  /// 加载中状态
  final isLoading = false.obs;

  /// 当前激活的 tab 索引
  final currentChartType = 2.obs;

  /// 错误信息
  final errorMessage = Rxn<String>();

  /// 推运时间
  final transitTime = DateTime.now().obs;

  /// 推运时间间隔类型：年/月/周/日/时/分
  final dateIntervalType = '日'.obs;

  /// 缓存 7 个 tab 的星盘数据 (index → Rx<dynamic>)
  late final chartData = <int, Rx<dynamic>>{
    for (var i = 0; i < tabs.length; i++) i: Rx<dynamic>(null),
  };

  /// 星座解读数据（corpus_list type=1）
  final xzjdList = <dynamic>[].obs;

  /// 落宫分析数据（corpus_list type=4,5）
  final lgfxList = <dynamic>[].obs;

  final _xingpanApi = XingpanApi();

  /// 今日天象日历数据
  final todayCalendarData = <XzAstrocalendar>[].obs;

  /// 档案详情
  final archiveDetail = Rxn<Archive>();

  /// 第二个档案（合盘使用）
  final archive2 = Rxn<Archive>();

  @override
  void onInit() {
    super.onInit();
    archiveId = Get.arguments?['id'] as int?;
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: currentChartType.value,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadChart(2);
    });

    if (archiveId != null) {
      ToolApi().archiveDetail(archiveId!).then((archive) {
        if (archive != null) archiveDetail.value = archive;
      });
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// 按 tab 索引加载星盘数据
  ///
  /// [index]: 0-合盘, 1-天象, 2-本命, 3-行运, 4-法达, 5-次限, 6-三限
  /// [forceReload] 为 true 时跳过缓存强制从 API 拉取
  /// 已有数据或未选择档案时跳过，成功后将数据写入 chartData[index]
  Future<void> loadChart(int index, {bool forceReload = false}) async {
    final tabName = tabs[index];
    if ((tabName == '合盘' || tabName == '日返' || tabName == '月返') &&
        archive2.value == null) {
      await changeArchive();
      return;
    }
    if (!forceReload && chartData[index]?.value != null) {
      _updateCorpus(index);
      return;
    }
    if (archiveId == null) {
      errorMessage.value = '未选择档案';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      var request = XingpanChartRequest(
        archiveId: archiveId,
        transitday: ['天象', '行运', '法达', '次限', '三限'].contains(tabs[index])
            ? CommonUtil.formatDate(transitTime.value)
            : CommonUtil.formatDate(DateTime.now()),
        svgType: '0',
        isCorpus: '1',
      );
      final cached = await SpUtil.getStorage('astrolabe_setting');
      if (cached is Map) {
        if (cached['planetSelectedValues'] != null) {
          request.planets = List<String>.from(cached['planetSelectedValues']);
        }
        if (cached['pointSelectedValues'] != null) {
          request.virtual = List<String>.from(cached['pointSelectedValues']);
        }
        if (cached['asteroidSelectedValues'] != null) {
          request.planetXs = List<String>.from(
            cached['asteroidSelectedValues'],
          );
        }
        if (cached['selectedHouse'] != null) {
          request.hSys = cached['selectedHouse'] as String;
        }
        if (cached['phaseValues'] != null) {
          request.phase = Map<String, String>.from(cached['phaseValues']);
        }
      }
      dynamic result;
      switch (tabs[index]) {
        case '合盘':
          result = await _xingpanApi.composite(request, archive2.value!.id!);
          break;
        case '天象':
        case '行运':
          result = await _xingpanApi.current(request);
          break;
        case '本命':
          result = await _xingpanApi.natal(request);
          break;
        case '法达':
          result = await _xingpanApi.developed(request);
          break;
        case '次限':
          result = await _xingpanApi.transit(request);
          break;
        case '三限':
          result = await _xingpanApi.thirdProgressed(request);
          break;
        case '日返':
          result = await _xingpanApi.solarReturn(request, archive2.value!.id!);
          break;
        case '月返':
          result = await _xingpanApi.lunarReturn(request, archive2.value!.id!);
          break;
      }
      if (result != null) {
        chartData[index]!.value = result;
        _updateCorpus(index);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      ToastUtil.hide();
      isLoading.value = false;
    }
  }

  /// 从指定 tab 的缓存数据中提取文案列表
  void _updateCorpus(int index) {
    final data = chartData[index]?.value;
    if (data == null) return;
    final corpus = data['corpus_list'];
    if (corpus is List) {
      xzjdList.value = corpus.where((e) => e['type'] == 5).toList();
      lgfxList.value = corpus.where((e) => e['type'] == 4).toList()
        ..sort((a, b) => (a['type'] as int).compareTo(b['type'] as int));
      birthChartTabStr.value = availableBirthChartTabs.isNotEmpty
          ? availableBirthChartTabs.first
          : '';
    } else {
      xzjdList.value = [];
      lgfxList.value = [];
    }
  }

  /// 切换 tab
  void changeTab(int index) {
    currentChartType.value = index;
    tabController.animateTo(index);
    loadChart(index);
    if (tabs[index] == '天象') _loadTodayCalendar();
  }

  /// 打开档案选择页，切换档案后重新加载星盘数据
  Future<void> changeArchive() async {
    final tabName = tabs[currentChartType.value];
    final needsTwo = tabName == '合盘' || tabName == '日返' || tabName == '月返';
    final ids = <int>[];
    if (archiveId != null) ids.add(archiveId!);
    if (needsTwo) {
      final id2 = archive2.value?.id;
      if (id2 != null) ids.add(id2);
    }
    final result = await Get.toNamed(
      AppRoutes.ARCHIVE_SELECT,
      arguments: {if (ids.isNotEmpty) 'ids': ids, if (needsTwo) 'num': 2},
    );
    if (result == null) return;

    if (needsTwo && result is List) {
      archiveId = result[0].id;
      archiveDetail.value = result[0];
      archive2.value = result.length > 1 ? result[1] : null;
    } else if (result is Archive) {
      archiveId = result.id;
      archiveDetail.value = result;
      archive2.value = null;
    }

    for (var i = 0; i < tabs.length; i++) chartData[i]!.value = null;
    xzjdList.value = [];
    lgfxList.value = [];
    loadChart(currentChartType.value);
  }

  /// 切换本命盘子标签
  void changeBirthChartTab(String item) {
    birthChartTabStr.value = item;
  }

  /// 格式化当前推运时间
  String get formattedTransitTime =>
      CommonUtil.formatDate(transitTime.value, format: "yyyy-MM-dd hh:mm");

  /// 上一个推运时间
  void previousTransit() => _adjustTransit(-1);

  /// 下一个推运时间
  void nextTransit() => _adjustTransit(1);

  /// 调整推运时间，[multiplier] 为 -1 表示倒退，1 表示前进
  void _adjustTransit(int multiplier) {
    final dt = transitTime.value;
    switch (dateIntervalType.value) {
      case '年':
        transitTime.value = DateTime(
          dt.year + multiplier,
          dt.month,
          dt.day,
          dt.hour,
          dt.minute,
        );
        break;
      case '月':
        transitTime.value = DateTime(
          dt.year,
          dt.month + multiplier,
          dt.day,
          dt.hour,
          dt.minute,
        );
        break;
      case '周':
        transitTime.value = dt.add(Duration(days: 7 * multiplier));
        break;
      case '日':
        transitTime.value = dt.add(Duration(days: multiplier));
        break;
      case '时':
        transitTime.value = dt.add(Duration(hours: multiplier));
        break;
      case '分':
        transitTime.value = dt.add(Duration(minutes: multiplier));
        break;
    }
    _reloadTransitTab();
  }

  /// 推运时间变化时重新加载相关 tab 的星盘数据
  void _reloadTransitTab() {
    final tabName = tabs[currentChartType.value];
    if (['天象', '行运', '法达', '次限', '三限'].contains(tabName)) {
      ToastUtil.loading();
      loadChart(currentChartType.value, forceReload: true);
    }
  }

  /// 获取今日天象日历数据
  void _loadTodayCalendar() async {
    final now = DateTime.now();
    final data = await _xingpanApi.getCalendarByDay(
      year: now.year,
      month: now.month,
      day: now.day,
    );
    if (data != null) {
      todayCalendarData.assignAll(data);
    }
  }
}
