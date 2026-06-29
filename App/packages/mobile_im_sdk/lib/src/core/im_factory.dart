import '../transport/tcp/tcp_im_client.dart';
import '../transport/udp/udp_im_client.dart';
import '../transport/websocket/websocket_im_client.dart';
import '../utils/im_logger.dart';
import 'connection_type.dart';
import 'im_client.dart';
import 'im_config.dart';
import 'im_message.dart';

/// IM 客户端工厂(对应 MobileIMSDK `IMClientManager`).
///
/// 业务层通过 [IMFactory.create] 选择传输层,后续操作无感知.
class IMFactory {
  IMFactory._();

  /// 创建 IM 客户端实例.
  ///
  /// [type] 指定传输类型,默认 TCP.
  /// 在创建前会自动调用 [IMConfig.validate] 检查配置,异常时抛出 [IMConfigException].
  static IMClient create([ConnectionType type = ConnectionType.tcp]) {
    final int code = IMConfig.validate();
    if (code != 0) {
      IMLogger.e('IMFactory', '配置未通过校验: code=$code');
      throw IMConfigException(code);
    }
    switch (type) {
      case ConnectionType.tcp:
        return TcpImClient();
      case ConnectionType.udp:
        return UdpImClient();
      case ConnectionType.websocket:
        return WebSocketImClient();
    }
  }

  /// 释放所有引用(对应 iOS 端 `releaseMobileIMSDK`).
  static Future<void> shutdownAll(List<IMClient> clients) async {
    for (final IMClient c in clients) {
      await c.releaseCore();
    }
    IMConfig.reset();
    IMLogger.i('IMFactory', '所有 IM 客户端已释放');
  }
}

/// 配置异常(对应 MobileIMSDK `ErrorCode.clientSdkNoInitialed` 等).
class IMConfigException implements Exception {
  final int errorCode;
  IMConfigException(this.errorCode);

  @override
  String toString() => 'IMConfigException(code=$errorCode)';
}

/// 辅助扩展:为 [IMMessage] 注入 MobileIMSDK 风格的消息类型常量(对齐 `ProtocalType`).
extension IMMessageType on IMMessage {
  // ----- 客户端→服务端 -----
  /// FROM_CLIENT_TYPE_OF_LOGIN = 0
  static const int fromClientTypeLogin = 0;
  /// FROM_CLIENT_TYPE_OF_KEEP$ALIVE = 1
  static const int fromClientTypeKeepAlive = 1;
  /// FROM_CLIENT_TYPE_OF_COMMON$DATA = 2
  static const int fromClientTypeCommonData = 2;
  /// FROM_CLIENT_TYPE_OF_LOGOUT = 3
  static const int fromClientTypeLogout = 3;
  /// FROM_CLIENT_TYPE_OF_RECIVED = 4(QoS 收到确认)
  static const int fromClientTypeRecieved = 4;
  /// FROM_CLIENT_TYPE_OF_ECHO = 5
  static const int fromClientTypeEcho = 5;

  // ----- 服务端→客户端 -----
  /// FROM_SERVER_TYPE_OF_RESPONSE$LOGIN = 50
  static const int fromServerTypeOfResponseLogin = 50;
  /// FROM_SERVER_TYPE_OF_RESPONSE$KEEP$ALIVE = 51
  static const int fromServerTypeOfResponseKeepAlive = 51;
  /// FROM_SERVER_TYPE_OF_RESPONSE$FOR$ERROR = 52
  static const int fromServerTypeOfResponseForError = 52;
  /// FROM_SERVER_TYPE_OF_RESPONSE$ECHO = 53
  static const int fromServerTypeOfResponseEcho = 53;
  /// FROM_SERVER_TYPE_OF_KICKOUT = 54
  static const int fromServerTypeOfKickout = 54;
}
