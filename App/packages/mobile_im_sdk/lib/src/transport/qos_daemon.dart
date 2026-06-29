/// QoS 队列(对齐 MobileIMSDK `QoS4SendDaemon` + `QoS4ReciveDaemon`).
///
/// 服务职责:
/// 1. **发送端**:QoS 消息入队等 ack,超时按指数退避重传,达到上限触发 [MessageQoSEvent].
/// 2. **接收端**:按时间 TTL 去重(10 分钟有效,每 5 分钟清理).
import 'dart:async';

import '../core/error_code.dart';
import '../core/im_event.dart';
import '../core/im_message.dart';
import '../utils/im_logger.dart';

/// 一条尚未收到 ack 的发送记录.
class _PendingQoS {
  _PendingQoS(this.message, this.firstSentAtMs)
      : retryCount = 0,
        lastTryAtMs = firstSentAtMs;

  final IMMessage message;
  final int firstSentAtMs;
  int retryCount;
  int lastTryAtMs;
}

/// QoS 行为参数.
class QosOptions {
  const QosOptions({
    this.firstTimeoutMs = 5 * 1000,
    this.maxRetries = 3,
    this.messageValidTimeMs = 10 * 60 * 1000,
    this.cleanupIntervalMs = 5 * 60 * 1000,
    this.justNowGraceMs = 3 * 1000,
  });

  final int firstTimeoutMs;
  final int maxRetries;
  final int messageValidTimeMs;
  final int cleanupIntervalMs;
  final int justNowGraceMs;
}

/// 把"重发一条消息"和"收到一条消息去重"的能力解耦出来,由具体客户端实现.
abstract class QosTransport {
  /// 真正把 [msg] 写入底层连接.
  Future<int> sendRaw(IMMessage msg);

  /// 当前是否仍然处于"已登录"状态(否则停止重传).
  bool get isOnline;
}

class QosDaemon {
  QosDaemon({
    required this.transport,
    this.event,
    this.options = const QosOptions(),
  });

  final QosTransport transport;

  /// 可重新绑定,以支持 [IMClient.qosEvent] 在 [initCore] 之后才赋值的情况.
  // ignore: prefer_final_fields
  MessageQoSEvent? event;
  final QosOptions options;

  static const String _tag = 'QosDaemon';

  /// 调试观察者(对应 MobileIMSDK `setDebugObserver`).
  void Function(String eventType, Map<String, dynamic> details)? onDebug;

  final Map<String, _PendingQoS> _pending = <String, _PendingQoS>{};
  final Map<String, int> _receivedFps = <String, int>{}; // fingerprint -> timestamp
  Timer? _ticker;
  Timer? _cleanupTimer;

  // region ===== 发送端 =====

  /// 把一条 qos 消息入队(调用方在 [_sendRaw] 成功之后调用).
  void trackSent(IMMessage msg) {
    if (!msg.qos) return;
    final String? fp = msg.fingerprint;
    if (fp == null || fp.isEmpty) return;
    _pending[fp] = _PendingQoS(msg, DateTime.now().millisecondsSinceEpoch);
    _ensureTicker();
  }

  /// 收到 ack(type=4)时调用,把对应 fp 从队列移除.
  void markAcked(String fingerprint) {
    final _PendingQoS? p = _pending.remove(fingerprint);
    if (p != null) {
      IMLogger.d(_tag, 'acked fp=$fingerprint');
      event?.onAckReceived?.call(fingerprint);
      event?.onSendSuccess?.call(fingerprint);
    }
  }

  /// 释放某条 fp(供登出/重置时清空).
  void removeTracked(String fingerprint) {
    _pending.remove(fingerprint);
  }

  // endregion

  // region ===== 接收端 =====

  /// 检查 [fingerprint] 是否重复.
  /// 返回 true 表示新消息(应正常派发并发送 ack);
  /// 返回 false 表示已在缓存中(只补发一次 ack,不重复派发).
  bool markReceived(String fingerprint) {
    if (fingerprint.isEmpty) return true;
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (_receivedFps.containsKey(fingerprint)) {
      return false;
    }
    _receivedFps[fingerprint] = now;
    _ensureCleanupTimer();
    return true;
  }

  // endregion

  // region ===== 重传主循环 =====

  void _ensureTicker() {
    if (_ticker != null) return;
    _ticker = Timer.periodic(
      const Duration(milliseconds: 1000),
      (_) => _onTick(),
    );
  }

  Future<void> _onTick() async {
    if (!transport.isOnline) {
      _stopTicker();
      return;
    }
    if (_pending.isEmpty) {
      _stopTicker();
      return;
    }
    final int now = DateTime.now().millisecondsSinceEpoch;
    final List<String> fps = _pending.keys.toList(growable: false);
    final List<String> lostFps = <String>[];

    for (final String fp in fps) {
      if (!transport.isOnline) break;
      final _PendingQoS? p = _pending[fp];
      if (p == null) continue;

      final int wait = p.retryCount == 0
          ? options.firstTimeoutMs
          : options.firstTimeoutMs * (1 << p.retryCount);

      if (now - p.lastTryAtMs < wait) continue;

      // 首次重传至少等 justNowGraceMs,避免网络延迟误重传
      if (p.retryCount == 0 && now - p.firstSentAtMs < options.justNowGraceMs) {
        continue;
      }

      if (p.retryCount >= options.maxRetries) {
        _pending.remove(fp);
        IMLogger.w(_tag, '重传达到上限, fp=$fp 视为发送失败');
        lostFps.add(fp);
        event?.onSendFailed?.call(fp, ErrorCode.commonDataSendFailed);
        continue;
      }

      p.retryCount++;
      p.lastTryAtMs = now;
      IMLogger.i(_tag,
          'QoS 重传第 ${p.retryCount}/${options.maxRetries} 次 fp=$fp');
      await transport.sendRaw(p.message);
    }

    if (lostFps.isNotEmpty) {
      event?.onMessagesLost?.call(lostFps, ErrorCode.commonDataSendFailed);
    }
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  // endregion

  // region ===== 接收端时间驱动清理 =====

  void _ensureCleanupTimer() {
    if (_cleanupTimer != null) return;
    _cleanupTimer = Timer.periodic(
      Duration(milliseconds: options.cleanupIntervalMs),
      (_) => _cleanupReceived(),
    );
  }

  void _cleanupReceived() {
    final int cutoff =
        DateTime.now().millisecondsSinceEpoch - options.messageValidTimeMs;
    final int before = _receivedFps.length;
    _receivedFps.removeWhere((_, int ts) => ts < cutoff);
    final int removed = before - _receivedFps.length;
    if (removed > 0) {
      IMLogger.d(_tag, '清理了 $removed 条接收指纹缓存');
    }
  }

  // endregion

  /// 重置/登出时清空队列.
  void reset() {
    _pending.clear();
    _receivedFps.clear();
    _stopTicker();
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }
}
