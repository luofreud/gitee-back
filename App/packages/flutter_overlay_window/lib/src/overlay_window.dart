import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/src/models/overlay_position.dart';
import 'package:flutter_overlay_window/src/overlay_config.dart';

/// Flutter Overlay Window Plugin
///
/// This plugin allows Flutter apps to display overlay windows on Android.
/// It provides functionality for creating, managing, and communicating with overlay windows.
class FlutterOverlayWindow {
  FlutterOverlayWindow._();

  // ============================================================
  // 私有变量
  // ============================================================

  /// StreamController 用于 overlayListener（主应用 -> Overlay 消息）
  static final StreamController _controller = StreamController();

  /// StreamController 用于 mainAppListener（Overlay -> 主应用 消息）
  /// 使用 broadcast 模式，支持多个监听器
  static final StreamController<dynamic> _mainAppController =
      StreamController<dynamic>.broadcast();

  /// EventChannel 的订阅对象
  static StreamSubscription? _eventSubscription;

  /// 标记是否已注册消息监听器（防止重复注册）
  static bool _messageListenerRegistered = false;

  // ============================================================
  // Platform Channels
  // ============================================================

  /// MethodChannel 用于主方法调用
  static const MethodChannel _channel = MethodChannel(
    "x-slayer/overlay_channel",
  );

  /// EventChannel 用于从 Overlay 接收消息（Overlay -> 主应用）
  static const EventChannel _eventChannel = EventChannel(
    "x-slayer/overlay_event_channel",
  );

  /// MethodChannel 用于 Overlay 运行时的操作
  static const MethodChannel _overlayChannel = MethodChannel(
    "x-slayer/overlay",
  );

  /// BasicMessageChannel 用于主应用和 Overlay 之间的消息通信
  static const BasicMessageChannel _overlayMessageChannel = BasicMessageChannel(
    "x-slayer/overlay_messenger",
    JSONMessageCodec(),
  );

  /// BasicMessageChannel 用于主应用接收来自 Overlay 的消息
  static BasicMessageChannel _mainAppMessageChannel = BasicMessageChannel(
    "x-slayer/main_app_messenger",
    JSONMessageCodec(),
  );

  /// 显示 Overlay 悬浮窗
  ///
  /// [height] 悬浮窗高度，默认全屏覆盖
  /// [width] 悬浮窗宽度，默认匹配父容器
  /// [alignment] 悬浮窗在屏幕上的对齐位置，默认居中
  /// [visibility] 通知在锁屏上的可见性，默认隐藏
  /// [flag] 悬浮窗标志（可点击、不可点击等），默认不可聚焦
  /// [overlayTitle] 通知标题，默认 "overlay activated"
  /// [overlayContent] 通知内容
  /// [enableDrag] 是否允许拖拽，默认 false
  /// [positionGravity] 拖拽后的吸附位置
  /// [startPosition] 悬浮窗初始位置
  /// [enableSound] 是否播放通知声音，默认 true
  static Future<void> showOverlay({
    int height = WindowSize.fullCover,
    int width = WindowSize.matchParent,
    OverlayAlignment alignment = OverlayAlignment.center,
    NotificationVisibility visibility = NotificationVisibility.visibilitySecret,
    OverlayFlag flag = OverlayFlag.defaultFlag,
    String overlayTitle = "overlay activated",
    String? overlayContent,
    bool enableDrag = false,
    PositionGravity positionGravity = PositionGravity.none,
    OverlayPosition? startPosition,
    bool enableSound = true,
  }) async {
    // 确保 EventChannel 监听已建立（用于接收 Overlay 发送的消息）
    _ensureEventChannelInitialized();

    await _channel.invokeMethod('showOverlay', {
      "height": height,
      "width": width,
      "alignment": alignment.name,
      "flag": flag.name,
      "overlayTitle": overlayTitle,
      "overlayContent": overlayContent,
      "enableDrag": enableDrag,
      "notificationVisibility": visibility.name,
      "positionGravity": positionGravity.name,
      "startPosition": startPosition?.toMap(),
      "enableSound": enableSound,
    });
  }

  /// 确保 EventChannel 监听已建立
  ///
  /// 此方法用于初始化 EventChannel，以便接收来自 Overlay 的消息。
  /// 使用双重检查锁定模式确保只初始化一次。
  static void _ensureEventChannelInitialized() {
    if (_eventSubscription == null) {
      // 只注册一次 BroadcastReceiver
      if (!_messageListenerRegistered) {
        _channel.invokeMethod('registerMessageListener');
        _messageListenerRegistered = true;
      }
      final stream = _eventChannel.receiveBroadcastStream();
      _eventSubscription = stream.listen(
        (message) {
          _mainAppController.add(message);
        },
        onError: (error) {},
        cancelOnError: false,
      );
    }
  }

  /// 检查是否已授予悬浮窗权限
  static Future<bool> isPermissionGranted() async {
    try {
      return await _channel.invokeMethod<bool>('checkPermission') ?? false;
    } on PlatformException catch (error) {
      log("$error");
      return Future.value(false);
    }
  }

  /// 请求悬浮窗权限
  ///
  /// 将打开系统悬浮窗设置页面，用户授权后返回 true
  static Future<bool?> requestPermission() async {
    try {
      return await _channel.invokeMethod<bool?>('requestPermission');
    } on PlatformException catch (error) {
      log("Error requestPermession: $error");
      rethrow;
    }
  }

  /// 关闭悬浮窗（如果正在显示）
  static Future<bool?> closeOverlay() async {
    final bool? _res = await _channel.invokeMethod('closeOverlay');
    return _res;
  }

  /// 向 Overlay 发送消息（主应用 -> Overlay）
  ///
  /// [data] 要发送的数据，可以是任意可序列化类型
  static Future shareData(dynamic data) async {
    return await _overlayMessageChannel.send(data);
  }

  /// 监听来自主应用的消息（Overlay 端使用）
  ///
  /// 返回一个 Stream，主应用发送的消息会通过此 Stream 传递
  static Stream<dynamic> get overlayListener {
    _overlayMessageChannel.setMessageHandler((message) async {
      _controller.add(message);
      return message;
    });
    return _controller.stream;
  }

  /// 监听来自 Overlay 的消息（主应用端使用）
  ///
  /// 返回一个 Stream，Overlay 发送的消息会通过此 Stream 传递。
  ///
  /// **重要**：建议在应用启动时调用一次即可，不需要多次调用。
  /// 可以在主应用的根 Widget 的 initState 中调用。
  static Stream<dynamic> get mainAppListener {
    // 初始化 EventChannel（如果尚未初始化）
    _ensureEventChannelInitialized();
    return _mainAppController.stream;
  }

  /// 从 Overlay 发送消息到主应用（Overlay 端使用）
  ///
  /// [data] 要发送的数据，可以是任意可序列化类型
  ///
  /// 返回 true 表示发送成功
  static Future<bool> shareDataToMain(dynamic data) async {
    final bool? _res = await _channel.invokeMethod<bool?>('sendToMainApp', {
      'data': data,
    });
    return _res ?? false;
  }

  /// 更新悬浮窗标志（在悬浮窗运行时）
  static Future<bool?> updateFlag(OverlayFlag flag) async {
    final bool? _res = await _overlayChannel.invokeMethod<bool?>('updateFlag', {
      'flag': flag.name,
    });
    return _res;
  }

  /// 更新悬浮窗大小
  static Future<bool?> resizeOverlay(
    int width,
    int height,
    bool enableDrag,
  ) async {
    final bool? _res = await _overlayChannel.invokeMethod<bool?>(
      'resizeOverlay',
      {'width': width, 'height': height, 'enableDrag': enableDrag},
    );
    return _res;
  }

  /// 更新悬浮窗位置
  ///
  /// [position] 新的位置
  ///
  /// 返回 true 表示更新成功
  static Future<bool?> moveOverlay(OverlayPosition position) async {
    final bool? _res = await _channel.invokeMethod<bool?>(
      'moveOverlay',
      position.toMap(),
    );
    return _res;
  }

  /// 获取当前悬浮窗位置
  ///
  /// 返回当前悬浮窗的位置
  static Future<OverlayPosition> getOverlayPosition() async {
    final Map<Object?, Object?>? _res = await _channel.invokeMethod(
      'getOverlayPosition',
    );
    return OverlayPosition.fromMap(_res);
  }

  /// 打开主应用并可传递参数
  ///
  /// [arguments] 可以是 String（路由名称）或 Map（多个参数）
  ///   - String: "/home" - 跳转到指定路由
  ///   - Map: {"route": "/home", "id": 123, "name": "test"} - 传递多个参数
  ///
  /// 返回 true 表示打开成功
  static Future<bool> openApp({dynamic arguments}) async {
    final bool? _res = await _channel.invokeMethod<bool?>('openApp', {
      'arguments': arguments,
    });
    return _res ?? false;
  }

  /// 检查当前悬浮窗是否处于活跃状态
  static Future<bool> isActive() async {
    final bool? _res = await _channel.invokeMethod<bool?>('isOverlayActive');
    return _res ?? false;
  }

  /// 释放资源
  ///
  /// 关闭 StreamController 和取消 EventChannel 订阅
  static void disposeOverlayListener() {
    _controller.close();
    // 不再关闭 _mainAppController，因为它是 broadcast 模式
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}
