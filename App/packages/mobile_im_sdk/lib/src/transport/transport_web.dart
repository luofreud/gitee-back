/// Web 平台传输层导出.
///
/// 当 `dart.library.html` 可用时,替代 [transport_stub.dart].
/// Web 平台不支持 TCP/UDP,仅提供 WebSocket 与帧编解码.
library transport_web;

export 'frame_codec.dart';
export 'qos_daemon.dart';

// Web 平台的 WebSocket 客户端需使用 HtmlWebSocketChannel,
// 当前 web/mobile_im_sdk_web.dart 仅完成插件注册.
// WebSocket IM 客户端将在后续版本中提供 web 适配.
