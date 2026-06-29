import 'dart:async';
import 'dart:convert';

import '../core/connection_type.dart';
import '../core/error_code.dart';
import '../core/im_config.dart';
import '../core/p_error_response.dart';
import '../core/p_login_info_response.dart';
import '../core/im_event.dart';
import '../core/im_factory.dart' show IMMessageType;
import '../core/im_message.dart';
import '../core/p_kickout_info.dart';
import '../core/protocal_factory.dart';
import '../utils/im_logger.dart';
import 'qos_daemon.dart';

/// 回调接口:解耦 DispatchCenter 与具体传输层.
///
/// 各 client(TCP/UDP/WS) 实现此接口,DispatchCenter 调用其方法完成实际 I/O.
abstract class DispatchDelegate {
  String? get currentLoginUserId;
  QosDaemon get qos;
  ChatBaseEvent? get baseEvent;
  ChatMessageEvent? get messageEvent;
  MessageQoSEvent? get qosEvent;
  StreamSink<ConnectionState> get stateSink;
  StreamSink<IMMessage> get msgSink;
  StreamSink<int> get errSink;

  /// 当前连接状态(供 DispatchCenter 判断是否在登录中).
  ConnectionState get connectionState;

  /// 发送 ack 回给服务端
  Future<void> sendAck(String fingerprint, String fromUserId);

  /// 更新连接状态,供 DispatchCenter 在 kicked 等场景调用.
  void setState(ConnectionState next);

  /// 心跳响应到达(供 DispatchCenter 在收到 type=51 时调用,用于超时检测).
  void onHeartbeatResponse();

  /// 登录成功时停止自动重连守护进程.
  void stopAutoReconnect();

  bool get isClosed;
}

/// 统一消息分发中心.
///
/// 消除 TCP/UDP/WS 三份重复的 _dispatch 和 _handleLoginResponse.
class DispatchCenter {
  final DispatchDelegate _delegate;

  DispatchCenter(this._delegate);

  static const String _tag = 'DispatchCenter';

  /// 分发一条消息
  void dispatch(IMMessage m) {
    if (_delegate.isClosed) return;
    IMLogger.d(_tag,
        'recv: type=${m.type} fp=${m.fingerprint} data=${m.textData}');

    switch (m.type) {
      case IMMessageType.fromServerTypeOfResponseLogin:
        _handleLoginResponse(m);
        break;

      case IMMessageType.fromServerTypeOfResponseKeepAlive:
        _delegate.qosEvent?.onAckReceived?.call(m.fromUserId ?? '');
        _delegate.onHeartbeatResponse();
        break;

      case IMMessageType.fromServerTypeOfResponseForError:
        final PErrorResponse? err = ProtocalFactory.parsePErrorResponse(m.textData);
        final int code = err?.errorCode ?? ErrorCode.commonUnknownError;
        final String msg = err?.errorMsg ?? m.textData;
        _delegate.messageEvent?.onErrorResponse?.call(code, msg);
        _delegate.errSink.add(code);
        break;

      case IMMessageType.fromServerTypeOfResponseEcho:
        _delegate.msgSink.add(m);
        break;

      case IMMessageType.fromServerTypeOfKickout:
        _delegate.setState(ConnectionState.kicked);
        final PKickoutInfo? ki = ProtocalFactory.parsePKickoutInfo(m.textData);
        if (ki != null) {
          _delegate.baseEvent?.onKickout?.call(ki);
        } else {
          _delegate.baseEvent?.onKickoutLegacy?.call(m.textData);
        }
        break;

      case IMMessageType.fromClientTypeCommonData:
        _handleCommonData(m);
        break;

      case IMMessageType.fromClientTypeRecieved:
        _handleAck(m);
        break;

      default:
        _delegate.msgSink.add(m);
    }
  }

  /// 统一解析登录响应,返回 code.
  int handleLoginResponse(IMMessage m) {
    int code = ErrorCode.commonUnknownError;
    final String text = m.textData.trim();

    if (text.startsWith('{') || text.startsWith('[')) {
      try {
        final dynamic parsed = jsonDecode(text);
        if (parsed is Map<String, dynamic>) {
          final dynamic raw = parsed['code'];
          if (raw is num) {
            code = raw.toInt();
          } else if (raw is String) {
            code = int.tryParse(raw) ?? ErrorCode.commonUnknownError;
          } else {
            code = ErrorCode.commonUnknownError;
          }
        } else {
          code = ErrorCode.commonCodeOk;
        }
      } catch (_) {
        code = ErrorCode.commonUnknownError;
      }
    } else if (text.startsWith('OK')) {
      code = ErrorCode.commonCodeOk;
    } else if (text.startsWith('-')) {
      code = int.tryParse(text) ?? ErrorCode.commonUnknownError;
    } else {
      code = ErrorCode.commonCodeOk;
    }

    if (text.startsWith('{')) {
      final PLoginInfoResponse? resp =
          ProtocalFactory.parsePLoginInfoResponse(text);
      if (resp != null) {
        IMConfig.firstLoginTime = resp.firstLoginTime;
      }
    }

    IMLogger.i(_tag, 'login response code=$code data=$text');
    _delegate.baseEvent?.onLoginResponse?.call(code);
    return code;
  }

  // region ===== 内部方法 =====

  void _handleLoginResponse(IMMessage m) {
    final int code = handleLoginResponse(m);
    if (code == 0) {
      _delegate.stopAutoReconnect();
      _delegate.setState(ConnectionState.logged);
    } else {
      _delegate.setState(ConnectionState.disconnected);
    }
  }

  void _handleCommonData(IMMessage m) {
    if (m.qos && (m.fingerprint?.isNotEmpty ?? false)) {
      if (!_delegate.qos.markReceived(m.fingerprint!)) {
        unawaited(
            _delegate.sendAck(m.fingerprint!, _delegate.currentLoginUserId ?? '-1'));
        return;
      }
    }

    _delegate.messageEvent?.onRecieveMessage?.call(
      m.fingerprint ?? '',
      m.fromUserId ?? '',
      m.textData,
      m.typeu,
    );
    _delegate.messageEvent?.onRecieveMessageBytes?.call(
      m.fingerprint ?? '',
      m.fromUserId ?? '',
      m.data,
      m.typeu,
    );

    if (m.qos && m.fingerprint != null && m.fingerprint!.isNotEmpty) {
      unawaited(
          _delegate.sendAck(m.fingerprint!, _delegate.currentLoginUserId ?? '-1'));
    }

    _delegate.msgSink.add(m);
  }

  void _handleAck(IMMessage m) {
    final String? ackFp = ProtocalFactory.extractAckFingerprint(m);
    if (ackFp != null && ackFp.isNotEmpty) {
      _delegate.qos.markAcked(ackFp);
    }
  }

  // endregion
}
