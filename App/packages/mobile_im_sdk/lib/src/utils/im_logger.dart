/// 通用日志接口(便于在不同环境注入不同实现).
abstract class ILogger {
  void d(String tag, String message);
  void i(String tag, String message);
  void w(String tag, String message, [Object? error, StackTrace? stack]);
  void e(String tag, String message, [Object? error, StackTrace? stack]);
}

/// 默认日志输出实现,基于 `developer.log` / `print`.
class ConsoleLogger implements ILogger {
  final bool verbose;
  ConsoleLogger({this.verbose = true});

  void _emit(String level, String tag, String message,
      [Object? error, StackTrace? stack]) {
    final StringBuffer sb = StringBuffer();
    sb.write('[$level] $tag | $message');
    if (error != null) sb.write(' | err=$error');
    if (stack != null) sb.write('\n$stack');
    // ignore: avoid_print
    print(sb.toString());
  }

  @override
  void d(String tag, String message) {
    if (verbose) _emit('D', tag, message);
  }

  @override
  void i(String tag, String message) {
    _emit('I', tag, message);
  }

  @override
  void w(String tag, String message, [Object? error, StackTrace? stack]) {
    _emit('W', tag, message, error, stack);
  }

  @override
  void e(String tag, String message, [Object? error, StackTrace? stack]) {
    _emit('E', tag, message, error, stack);
  }
}

/// 全局日志单例(对应 MobileIMSDK `ClientCoreSDK.setENABLED_DEBUG`).
class IMLogger {
  IMLogger._();

  static ILogger _instance = ConsoleLogger();
  static ILogger get instance => _instance;

  /// 注入自定义实现(测试时常用).
  static void setLogger(ILogger logger) {
    _instance = logger;
  }

  /// 恢复默认.
  static void reset() {
    _instance = ConsoleLogger();
  }

  static void d(String tag, String message) => _instance.d(tag, message);
  static void i(String tag, String message) => _instance.i(tag, message);
  static void w(String tag, String message,
          [Object? error, StackTrace? stack]) =>
      _instance.w(tag, message, error, stack);
  static void e(String tag, String message,
          [Object? error, StackTrace? stack]) =>
      _instance.e(tag, message, error, stack);
}
