/// 心跳敏感度模式(对齐 MobileIMSDK `ConfigEntity.SenseMode`).
///
/// 用于控制客户端向服务端发送 keep-alive 心跳包的频率.
enum SenseMode {
  /// 3 秒.
  mode3S,

  /// 5 秒(默认).
  mode5S,

  /// 10 秒.
  mode10S,

  /// 15 秒.
  mode15S,

  /// 30 秒.
  mode30S,

  /// 60 秒.
  mode60S,

  /// 120 秒.
  mode120S,
}

extension SenseModeX on SenseMode {
  /// 心跳间隔毫秒数.
  int get millis {
    switch (this) {
      case SenseMode.mode3S:
        return 3000;
      case SenseMode.mode5S:
        return 5000;
      case SenseMode.mode10S:
        return 10000;
      case SenseMode.mode15S:
        return 15000;
      case SenseMode.mode30S:
        return 30000;
      case SenseMode.mode60S:
        return 60000;
      case SenseMode.mode120S:
        return 120000;
    }
  }

  /// 对应的连接超时毫秒数(对齐 MobileIMSDK iOS/Android).
  ///
  /// 超过此时间未收到服务端心跳响应即判定连接断开.
  int get timeoutMillis {
    switch (this) {
      case SenseMode.mode3S:
        return 5000;
      case SenseMode.mode5S:
        return 8000;
      case SenseMode.mode10S:
        return 15000;
      case SenseMode.mode15S:
        return 20000;
      case SenseMode.mode30S:
        return 35000;
      case SenseMode.mode60S:
        return 65000;
      case SenseMode.mode120S:
        return 125000;
    }
  }
}
