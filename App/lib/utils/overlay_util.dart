import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_floating/flutter_floating.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class OverlayMainWidget extends StatefulWidget {
  const OverlayMainWidget({super.key});

  @override
  State<OverlayMainWidget> createState() => _OverlayMainWidgetState();
}

class _OverlayMainWidgetState extends State<OverlayMainWidget> {
  String _route = '';
  String _title = '';
  String _avatar = '';
  dynamic arguments;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      debugPrint("窗口收到消息: $event");
      handleMessage(event);
    });
  }

  handleMessage(dynamic message) {
    try {
      final overlayMessage = OverlayMessage.fromString(message);
      if (overlayMessage.route != null && overlayMessage.route!.isNotEmpty) {
        _route = overlayMessage.route ?? '';
      }
      if (overlayMessage.title != null && overlayMessage.title!.isNotEmpty) {
        _title = overlayMessage.title ?? '';
      }
      if (overlayMessage.avatar != null && overlayMessage.avatar!.isNotEmpty) {
        _avatar = overlayMessage.avatar ?? '';
      }
      arguments = overlayMessage.arguments;
      setState(() {});
    } catch (e) {
      debugPrint("解析消息失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(100),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () async {
          // 悬浮窗发送消息到主应用
          if (Platform.isIOS) {
            floatingManager.getFloating('live_mini_window').close();
            Get.toNamed(AppRoutes.LIVE_ROOM);
          } else {
            //  普通用户进入/live/room   导师进入/counselor/live/room
            if (_route.isNotEmpty) {
              FlutterOverlayWindow.shareDataToMain(
                OverlayMessage(route: _route, arguments: arguments).toString(),
              );
            }
            FlutterOverlayWindow.closeOverlay();
            FlutterOverlayWindow.openApp();
          }
        },
        child: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 4),
                Icon(Icons.arrow_back, size: 10, color: Colors.white),
                Text(
                  '回到直播间',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: CircleAvatar(
                radius: 30,
                foregroundImage: _avatar.isEmpty ? null : NetworkImage(_avatar),
              ),
            ),
            Text(
              _title ?? '',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class OverlayUtil {
  static Widget overlayWidget() {
    return Material(color: Colors.transparent, child: OverlayMainWidget());
  }

  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? content,
    String? overlayRoute,
    String? overlayTitle,
    String? overlayAvatar,
    dynamic arguments,
  }) async {
    if (Platform.isIOS) {
      var floating = floatingManager.createFloating(
        "live_mini_window",
        FloatingOverlay(
          overlayWidget(),
          slideType: FloatingEdgeType.onRightAndTop,
          params: FloatingParams(
            snapToEdgeSpace: 20,
            enablePositionCache: false,
          ),
          right: 20,
          top: 100,
        ),
      );
      floating.open(context);
      return true;
    } else {
      if (await FlutterOverlayWindow.isActive()) return true;
      bool status = await FlutterOverlayWindow.isPermissionGranted();
      if (!status) {
        status = await FlutterOverlayWindow.requestPermission() ?? false;
      }
      if (!status) {
        ToastUtil.info('请授权悬浮窗权限');
        return false;
      }
      //获取当前设备的屏幕像素分辨率
      final devicePixelRatio = View.of(context).devicePixelRatio;
      //弹窗的尺寸是以像素为单位的，所以要在flutter尺寸的基础上乘以像素分辨率
      await FlutterOverlayWindow.showOverlay(
        height: (devicePixelRatio * 120).toInt(),
        width: (devicePixelRatio * (80 + 30)).toInt(),
        enableDrag: true,
        visibility: NotificationVisibility.visibilityPublic,
        overlayTitle: title ?? AppConst.APP_NAME,
        overlayContent: content ?? "",
        alignment: OverlayAlignment.topRight,
        positionGravity: PositionGravity.auto,
        //自动吸附边缘
        startPosition: OverlayPosition.fromMap({"x": 0.0, "y": 100.0}),
        enableSound: false, //是否开启提示音
      );
      if (overlayRoute != null ||
          overlayTitle != null ||
          overlayAvatar != null) {
        sendMessage(
          OverlayMessage(
            route: overlayRoute,
            title: overlayTitle,
            avatar: overlayAvatar,
            arguments: arguments,
          ),
        );
      }
      return true;
    }
  }

  static Future<dynamic> sendMessage(OverlayMessage message) async {
    return await FlutterOverlayWindow.shareData(message.toString());
  }

  static void hide() {
    if (Platform.isIOS) {
      floatingManager.getFloating('live_mini_window').close();
    } else {
      FlutterOverlayWindow.disposeOverlayListener();
      FlutterOverlayWindow.closeOverlay();
    }
  }
}

class OverlayMessage {
  final String? route;
  final String? title;
  final String? avatar;
  final dynamic? arguments;

  OverlayMessage({this.route, this.title, this.avatar, this.arguments});

  factory OverlayMessage.fromString(String message) {
    final json = jsonDecode(message);
    return OverlayMessage(
      route: json['route'],
      title: json['title'],
      avatar: json['avatar'],
      arguments: json['arguments'],
    );
  }

  @override
  String toString() {
    return jsonEncode({
      'route': route,
      'title': title,
      'avatar': avatar,
      'arguments': arguments,
    });
  }
}

enum OverlayMessageType { route, title, avatar }
