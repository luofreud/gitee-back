/// 连接传输层类型.
enum ConnectionType {
  /// TCP 协议,可靠长连接.
  tcp,

  /// UDP 协议,无连接.
  udp,

  /// WebSocket 协议,常用于 Web 互通.
  websocket,
}

/// 字符串与枚举互转(便于序列化与日志).
extension ConnectionTypeX on ConnectionType {
  String get name {
    switch (this) {
      case ConnectionType.tcp:
        return 'TCP';
      case ConnectionType.udp:
        return 'UDP';
      case ConnectionType.websocket:
        return 'WebSocket';
    }
  }

  static ConnectionType fromName(String value) {
    for (final ConnectionType t in ConnectionType.values) {
      if (t.name == value) return t;
    }
    return ConnectionType.tcp;
  }
}

/// 客户端连接状态.
enum ConnectionState {
  /// 未初始化.
  idle,

  /// 正在建立连接.
  connecting,

  /// 已连接.
  connected,

  /// 正在登录.
  logining,

  /// 已登录.
  logged,

  /// 正在登出.
  logouting,

  /// 正在断开.
  disconnecting,

  /// 已断开.
  disconnected,

  /// 被踢下线.
  kicked,
}
