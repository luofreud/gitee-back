/// 错误码常量表(对齐 MobileIMSDK iOS `ErrorCode.h` / Android `ErrorCode.java`).
///
/// 建议 0~1024 范围内的错误码作为 IM 核心框架保留,业务层请使用 >1024 的码表示.
class ErrorCode {
  ErrorCode._();

  // region ===== 客户端本地通用编码约定 =====
  /// 一切正常.
  static const int commonCodeOk = 0;

  /// 客户端尚未登录.
  static const int commonNoLogin = 1;

  /// 未知错误.
  static const int commonUnknownError = 2;

  /// 数据发送失败.
  static const int commonDataSendFailed = 3;

  /// 无效的 Protocal 对象.
  static const int commonInvalidProtocal = 4;
  // endregion

  // region ===== 由客户端产生的错误码(2xx) =====
  /// 与服务端的连接已断开.
  static const int brokenConnectToServer = 201;

  /// 与服务端的网络连接失败.
  static const int badConnectToServer = 202;

  /// 客户端 SDK 尚未初始化.
  static const int clientSdkNoInitialed = 203;

  /// 本地网络不可用(未打开).
  static const int localNetworkNotWorking = 204;

  /// 要连接的服务端网络参数未设置.
  static const int toServerNetInfoNotSetup = 205;
  // endregion

  // region ===== 由服务端产生的错误码(3xx) =====
  /// 客户端尚未登录,请重新登录.
  static const int responseForUnlogin = 301;
  // endregion

  // region ===== 业务自定义错误码(>1024) =====

  /// Socket 创建失败.
  static const int socketCreateFailed = 1025;

  /// Socket 绑定失败.
  static const int socketBindFailed = 1026;

  /// 数据发送失败(底层).
  static const int sendFailed = 1027;

  /// 协议解析失败.
  static const int protocalParseFailed = 1028;

  /// 网络中断.
  static const int networkInterrupted = 1029;

  /// 连接超时.
  static const int connectionTimeout = 1030;

  /// SSL/TLS 握手失败.
  static const int sslHandshakeFailed = 1031;
  // endregion

  /// 根据错误码返回可读描述(便于日志展示).
  static String describe(int code) {
    switch (code) {
      case commonCodeOk:
        return '一切正常';
      case commonNoLogin:
        return '客户端尚未登录';
      case commonUnknownError:
        return '未知错误';
      case commonDataSendFailed:
        return '数据发送失败';
      case commonInvalidProtocal:
        return '无效的 Protocal 对象';
      case brokenConnectToServer:
        return '与服务端的连接已断开';
      case badConnectToServer:
        return '与服务端的网络连接失败';
      case clientSdkNoInitialed:
        return '客户端 SDK 尚未初始化';
      case localNetworkNotWorking:
        return '本地网络不可用(未打开)';
      case toServerNetInfoNotSetup:
        return '要连接的服务端网络参数未设置';
      case responseForUnlogin:
        return '客户端尚未登录,请重新登录';
      case socketCreateFailed:
        return 'Socket 创建失败';
      case socketBindFailed:
        return 'Socket 绑定失败';
      case sendFailed:
        return '数据发送失败(底层)';
      case protocalParseFailed:
        return '协议解析失败';
      case networkInterrupted:
        return '网络中断';
      case connectionTimeout:
        return '连接超时';
      case sslHandshakeFailed:
        return 'SSL/TLS 握手失败';
      default:
        return '未知错误码($code)';
    }
  }
}
