import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:freud/utils/overlay_util.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final navItems = [
    {
      "label": "首页",
      "icon": "assets/nav/home0.png",
      "activeIcon": "assets/nav/home1.png",
    },
    {
      "label": "发现",
      "icon": "assets/nav/discover0.png",
      "activeIcon": "assets/nav/discover1.png",
    },
    {
      "label": "在线",
      "icon": "assets/nav/online0.png",
      "activeIcon": "assets/nav/online1.png",
    },
    {
      "label": "消息",
      "icon": "assets/nav/message0.png",
      "activeIcon": "assets/nav/message1.png",
    },
    {
      "label": "我的",
      "icon": "assets/nav/mine0.png",
      "activeIcon": "assets/nav/mine1.png",
    },
  ];
  final navIndex = 0.obs;
  late final pageController;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: navIndex.value);

    /// 监听来自悬浮窗的消息
    _subscription?.cancel();
    FlutterOverlayWindow.disposeOverlayListener();
    _subscription = FlutterOverlayWindow.mainAppListener.listen((message) {
      // 处理接收到的消息
      debugPrint("app收到消息: $message");
      handleOverlayMessage(message);
    });
  }

  handleOverlayMessage(dynamic message) {
    try {
      final overlayMessage = OverlayMessage.fromString(message);
      if (overlayMessage.route != null && overlayMessage.route!.isNotEmpty) {
        Get.toNamed(overlayMessage.route!, arguments: overlayMessage.arguments);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    _subscription?.cancel();
    FlutterOverlayWindow.disposeOverlayListener();
    super.onClose();
  }

  void changeNavIndex(int index) {
    navIndex.value = index;
  }
}
