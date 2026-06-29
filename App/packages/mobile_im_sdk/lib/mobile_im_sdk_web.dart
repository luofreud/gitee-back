import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// MobileIMSDK Flutter 插件的 Web 平台桩.
///
/// Web 平台不支持 `dart:io`,因此 TCP/UDP 不可用.
/// 此桩仅确保插件注册,实际通信需使用 WebSocket.
class MobileImSdkWeb {
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'mobile_im_sdk',
      StandardMethodCodec(),
      registrar.messenger,
    );
    channel.setMethodCallHandler((MethodCall call) async => null);
  }
}
