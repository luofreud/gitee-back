import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService extends GetxService with WidgetsBindingObserver {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 是否在前台（由 WidgetsBindingObserver 追踪）
  final isForeground = true.obs;

  /// 初始化通知插件，注册 Android/iOS 配置和点击回调
  static Future<NotificationService> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    return NotificationService();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isForeground.value = state == AppLifecycleState.resumed;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// 通知点击回调，解析 payload 中的 uid 和 name 并跳转到聊天页
  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || !payload.startsWith('chat:')) return;
    final parts = payload.split(':');
    if (parts.length < 3) return;
    final uid = int.tryParse(parts[1]) ?? 0;
    final name = parts.sublist(2).join(':');
    Get.toNamed(AppRoutes.CHAT, arguments: {'uid': uid, 'name': name});
  }

  /// 显示 IM 消息通知（前台/后台均生效，Android 以 heads-up 横幅弹出）
  /// [uid] 发送方用户 ID，用于点击后跳转
  /// [name] 发送方昵称，作为通知标题
  /// [body] 消息预览文本
  Future<void> showMessageNotification({
    required int uid,
    required String name,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'im_message_channel',
      'IM 消息',
      channelDescription: '即时通讯消息通知',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _plugin.show(
      id: id,
      title: name,
      body: body,
      payload: 'chat:$uid:$name',
      notificationDetails: details,
    );
  }

  /// 第一次权限申请是否已完成（SpUtil key）
  static const _firstPermissionDoneKey = 'first_permission_done';

  /// 请求 Android 通知权限（兼容 Android 5~14+）。
  /// 返回 true 表示用户已允许通知。
  Future<bool> requestPermissions() async {
    try {
      if (!Platform.isAndroid) return false;

      // 检查是否是首次执行权限申请
      final isFirstTime =
          !((await SpUtil.getBool(_firstPermissionDoneKey)) ?? false);

      // 先检查当前权限状态
      var status = await Permission.notification.status;

      if (status.isDenied) {
        if (isFirstTime) {
          // === 首次：走正常请求流程 ===
          status = await Permission.notification.request();

          if (status.isGranted) {
            await SpUtil.setBool(_firstPermissionDoneKey, true);
            return true;
          } else if (status.isPermanentlyDenied) {
            //用户选择了"拒绝并不再询问"，需要引导用户去系统设置中开启
            final shouldOpen = await _showPermissionGuide();
            if (shouldOpen) await openAppSettings();
            final retryStatus = await Permission.notification.status;
            if (retryStatus.isGranted) {
              await SpUtil.setBool(_firstPermissionDoneKey, true);
              return true;
            }
          } else {
            // 发送静默通知尝试触发系统权限弹窗
            await _trySilentNotification();
            final retryStatus = await Permission.notification.status;
            if (retryStatus.isGranted) {
              await SpUtil.setBool(_firstPermissionDoneKey, true);
              return true;
            }
            if (retryStatus.isPermanentlyDenied) {
              final shouldOpen = await _showPermissionGuide();
              if (shouldOpen) await openAppSettings();
            }
          }
        } else {
          // === 非首次：直接引导去系统设置 ===
          final shouldOpen = await _showPermissionGuide();
          if (shouldOpen) await openAppSettings();
          final retryStatus = await Permission.notification.status;
          if (retryStatus.isGranted) {
            await SpUtil.setBool(_firstPermissionDoneKey, true);
            return true;
          }
        }
      } else if (status.isGranted) {
        await SpUtil.setBool(_firstPermissionDoneKey, true);
        return true;
      } else if (status.isPermanentlyDenied) {
        // 权限被永久拒绝，引导用户前往设置;
        final shouldOpen = await _showPermissionGuide();
        if (shouldOpen) await openAppSettings();
      } else {
        debugPrint('通知权限状态为: $status');
      }
      // 执行到此处说明权限未授予，记录标记（确保第二次不走首次流程）
      await SpUtil.setBool(_firstPermissionDoneKey, true);
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 检查通知权限状态。
  /// 已有通知权限返回 true，否则返回 false。
  Future<bool> hasPermission() async {
    try {
      if (!Platform.isAndroid) return false;
      return await Permission.notification.status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// 弹出底部引导框，用户确认后跳转系统设置
  Future<bool> _showPermissionGuide() async {
    try {
      final result = await showModalBottomSheet<bool>(
        context: Get.overlayContext!,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: const Icon(Icons.notifications_none, size: 32)),
              const SizedBox(height: 16),
              const Text(
                '需要发送通知权限',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '通知权限用于消息提醒，立即前往到系统设置中开启通知功能',
                style: TextStyle(fontSize: 14, color: Color(0xff999999)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: const Text(
                      '取消',
                      style: TextStyle(color: Color(0xff135cee), fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(width: 1, color: Color(0xffefefef)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: const Text(
                      '去设置',
                      style: TextStyle(color: Color(0xff135cee), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// 发送一条静默通知（无声音/震动），尝试触发系统通知权限弹窗
  Future<void> _trySilentNotification() async {
    try {
      const silentDetails = AndroidNotificationDetails(
        'silent_permission_channel',
        '通知权限',
        channelDescription: '申请通知权限用于消息提醒',
        importance: Importance.min,
        priority: Priority.min,
        playSound: false,
        enableVibration: false,
      );
      await _plugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: '',
        body: '',
        notificationDetails: NotificationDetails(android: silentDetails),
      );
    } catch (_) {}
  }
}
