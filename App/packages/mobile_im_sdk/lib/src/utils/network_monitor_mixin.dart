import 'network_monitor.dart';

/// 混入网络状态监听能力.
///
/// ```dart
/// class MyClient extends Object with NetworkMonitorMixin { ... }
/// ```
mixin NetworkMonitorMixin {
  /// 启动网络监听.
  void startNetworkMonitor({
    required void Function() onNetworkLost,
    required void Function() onNetworkRestored,
  }) {
    NetworkMonitor.instance.onNetworkLost = onNetworkLost;
    NetworkMonitor.instance.onNetworkRestored = onNetworkRestored;
    NetworkMonitor.instance.start();
  }

  /// 停止网络监听.
  void stopNetworkMonitor() {
    NetworkMonitor.instance.stop();
    NetworkMonitor.instance.onNetworkLost = null;
    NetworkMonitor.instance.onNetworkRestored = null;
  }
}
