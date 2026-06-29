import 'sense_mode.dart';

/// IM 全局配置(对齐 MobileIMSDK `ConfigEntity`).
///
/// 使用静态字段,所有客户端实例共享同一份配置.
class IMConfig {
  IMConfig._();

  /// 已注册的 AppKey(为空表示未注册).
  static String _appKey = '';
  static String get appKey => _appKey;

  /// 注册应用 AppKey(对应 MobileIMSDK `ConfigEntity.registerWithAppKey`).
  static void register({required String appKey}) {
    _appKey = appKey;
  }

  /// 是否已经注册.
  static bool get isRegistered => _appKey.isNotEmpty;

  /// 用户首次登录时间(由服务端下发,0 表示未知).
  static int firstLoginTime = 0;

  /// 释放注册信息(对应 `releaseMobileIMSDK` 流程).
  static void reset() {
    _appKey = '';
    serverIp = '';
    serverPort = 0;
    localPort = 0;
    senseMode = SenseMode.mode5S;
    ssl = false;
    autoReconnect = true;
    debug = false;
    connectTimeout = const Duration(seconds: 10);
    sendTimeout = const Duration(seconds: 10);
    receiveTimeout = const Duration(seconds: 30);
    firstLoginTime = 0;
  }

  // region ===== 服务端连接信息 =====

  /// 服务端 IP.
  static String serverIp = '';

  /// 服务端端口.
  static int serverPort = 0;

  /// 本地发送与监听端口(0 表示由系统自动分配,对应 `setLocalSendAndListeningPort:-1`).
  static int localPort = 0;

  // endregion

  // region ===== 心跳与协议 =====

  /// 心跳敏感度.
  static SenseMode senseMode = SenseMode.mode5S;

  /// 是否开启 SSL/TLS.
  static bool ssl = false;

  /// 断线后是否自动重连(对应 `setAutoReLogin`).
  static bool autoReconnect = true;

  // endregion

  // region ===== 调试与超时 =====

  /// 是否开启 DEBUG 日志.
  static bool debug = false;

  /// 连接超时时间.
  static Duration connectTimeout = const Duration(seconds: 10);

  /// 单次发送超时.
  static Duration sendTimeout = const Duration(seconds: 10);

  /// 接收超时(心跳判定).
  static Duration receiveTimeout = const Duration(seconds: 30);

  // endregion

  /// 校验配置合法性;若返回错误码 ≠ 0 则表示配置不合法.
  ///
  /// - [ErrorCode.toServerNetInfoNotSetup] 服务端 ip/port 未设置
  /// - [ErrorCode.clientSdkNoInitialed] 尚未调用 [register]
  static int validate() {
    if (!isRegistered) {
      return 203; // ForC_CLIENT_SDK_NO_INITIALED
    }
    if (serverIp.isEmpty || serverPort <= 0) {
      return 205; // ForC_TO_SERVER_NET_INFO_NOT_SETUP
    }
    return 0;
  }
}
