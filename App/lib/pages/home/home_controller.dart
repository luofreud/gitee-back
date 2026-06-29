import 'package:flutter/material.dart';
import 'package:freud/api/article/post_api.dart';
import 'package:freud/api/live/teacher_api.dart';
import 'package:freud/api/mine/tool_api.dart';
import 'package:freud/models/article/article_plate.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/models/user/teacher.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/fortune_service.dart';
import 'package:freud/utils/sp_util.dart';
import 'package:get/get.dart';

import '../../service/notification_service.dart';

class HomeController extends GetxController with StateMixin<int> {
  // 导航栏透明度
  final appBarAlpha = 0.obs;

  // 首页滚动控制器
  final scrollController = ScrollController();

  static const String _cacheKey = 'home_current_archive';

  // 当前占星档案
  final currentArchive = Rx<Archive?>(null);

  // 今日运势数据
  final todayFortune = Rx<Map<String, dynamic>?>(null);

  // 话题板块列表
  final plateList = <ArticlePlate>[].obs;

  // 推荐导师列表
  final teacherList = <Teacher>[].obs;

  final fortuneService = Get.find<FortuneService>();

  @override
  // 初始化：监听滚动位置，加载首页数据
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      final _scrollPosition = scrollController.position.pixels;
      final int _alpha = (_scrollPosition / 100 * 255).toInt();
      appBarAlpha.value = _alpha.clamp(0, 255);
    });
    _loadArchive();
    _loadPlates();
    _loadTeachers();

    _requestNotificationPermission();
  }

  /// 申请通知权限
  Future<void> _requestNotificationPermission() async {
    // 延时 500ms 等页面渲染完成
    if (await SpUtil.getBool('first_permission_done') != true) {
      await Future.delayed(const Duration(milliseconds: 500));
      Get.find<NotificationService>().requestPermissions();
    }
  }

  // 加载占星档案（优先读取缓存）
  Future<void> _loadArchive() async {
    try {
      final cached = await SpUtil.getStorage(_cacheKey);
      if (cached != null) {
        final archive = Archive.fromJson(Map<String, dynamic>.from(cached));
        currentArchive.value = archive;
        if (archive.id != null) {
          todayFortune.value = await fortuneService.loadLuckDay(archive.id!);
        }
        return;
      }
    } catch (_) {}
    final result = await ToolApi().archivePage(
      PageRequest(page: 1, pageSize: 1),
    );
    if (result != null && result.items != null && result.items!.isNotEmpty) {
      final archive = result.items!.first;
      currentArchive.value = archive;
      await SpUtil.setStorage(_cacheKey, archive.toJson());
      if (archive.id != null) {
        todayFortune.value = await fortuneService.loadLuckDay(archive.id!);
      }
    }
  }

  // 跳转选择档案页
  Future<void> onSelectArchive() async {
    final result = await Get.toNamed(AppRoutes.ARCHIVE_SELECT);
    if (result is Archive) {
      currentArchive.value = result;
      await SpUtil.setStorage(_cacheKey, result.toJson());
      if (result.id != null) {
        todayFortune.value = await fortuneService.loadLuckDay(result.id!);
      }
    }
  }

  // 获取前5个话题板块
  Future<void> _loadPlates() async {
    var plates = await PostApi().getPlate(1);
    if (plates != null && plates.isNotEmpty) {
      plateList.assignAll(plates.take(5));
    }
  }

  // 获取前4条置顶推荐导师
  Future<void> _loadTeachers() async {
    var result = await TeacherApi().pageTeacher(
      PageRequest(page: 1, pageSize: 4),
      filters: {'istop': 1},
    );
    if (result != null && result.items != null) {
      teacherList.assignAll(result.items!);
    }
  }

  // 跳转星盘分析页（无档案时先创建）
  Future<void> onNavToAstrolabe() async {
    final archive = currentArchive.value;
    if (archive != null && archive.id != null) {
      Get.toNamed(AppRoutes.ASTROLABE_ANALYSIS, arguments: {'id': archive.id});
    } else {
      final id = await Get.toNamed(AppRoutes.TOOL_ARCHIVEADD);
      if (id != null) {
        Get.toNamed(AppRoutes.ASTROLABE_ANALYSIS, arguments: {'id': id});
      }
    }
  }

  @override
  // 页面销毁时释放滚动控制器
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
