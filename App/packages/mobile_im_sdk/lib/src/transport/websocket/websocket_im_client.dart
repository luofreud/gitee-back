import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/connection_type.dart';
import '../../core/error_code.dart';
import '../../core/im_client.dart';
import '../../core/im_config.dart';
import '../../core/im_event.dart';
import '../../core/im_message.dart';
import '../../core/protocal_factory.dart';
import '../../core/user_type_u.dart';
import '../../core/sense_mode.dart';
import '../../utils/im_logger.dart';
import '../../utils/network_monitor_mixin.dart';
import '../dispatch_center.dart';
import '../qos_daemon.dart';

/// WebSocket 客户端实现,对应 MobileIMSDK WebSocket 端.
///
/// 协议载荷格式:JSON 信封:
/// ```json
/// { "t": <type>, "q": <qos>, "f": "<from>", "to": "<to>", "fp": "<fp>", "d": "<data>" }
/// ```
class WebSocketImClient with NetworkMonitorMixin implements IMClient, QosTransport, DispatchDelegate {
  WebSocketImClient();

  static const String _tag = 'WebSocketImClient';

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _keepAliveTimer;
  Timer? _heartbeatTimeoutTimer;
  Timer? _reconnectTimer;
  bool _reconnecting = false;
  static const int _reconnectDelaySec = 3;
  int? _lastHeartbeatResponseMs;

  String? _currentUserId;
  String? _currentToken;
  ConnectionState _state = ConnectionState.idle;
  final StreamController<ConnectionState> _stateCtrl =
      StreamController<ConnectionState>.broadcast();
  final StreamController<IMMessage> _msgCtrl =
      StreamController<IMMessage>.broadcast();
  final StreamController<int> _errCtrl =
      StreamController<int>.broadcast();

  ChatBaseEvent? _baseEvent;
  ChatMessageEvent? _messageEvent;
  MessageQoSEvent? _qosEvent;

  late final QosDaemon _qos = QosDaemon(transport: this);
  late final DispatchCenter _dispatchCenter = DispatchCenter(this);

  // region ===== IMClient =====

  @override
  ConnectionType get connectionType => ConnectionType.websocket;

  @override
  ConnectionState get state => _state;

  @override
  Stream<ConnectionState> get stateStream => _stateCtrl.stream;

  @override
  Stream<IMMessage> get messageStream => _msgCtrl.stream;

  @override
  Stream<int> get errorStream => _errCtrl.stream;

  @override
  bool get isConnected => _state == ConnectionState.connected ||
      _state == ConnectionState.logged ||
      _state == ConnectionState.logining;

  @override
  bool get isLogined => _state == ConnectionState.logged;

  @override
  String? get currentLoginUserId => _currentUserId;

  @override
  set baseEvent(ChatBaseEvent? event) => _baseEvent = event;
  @override
  ChatBaseEvent? get baseEvent => _baseEvent;

  @override
  set messageEvent(ChatMessageEvent? event) => _messageEvent = event;
  @override
  ChatMessageEvent? get messageEvent => _messageEvent;

  @override
  set qosEvent(MessageQoSEvent? event) {
    _qosEvent = event;
    _qos.event = event;
  }

  @override
  MessageQoSEvent? get qosEvent => _qosEvent;

  // endregion

  // region ===== DispatchDelegate =====

  @override
  QosDaemon get qos => _qos;

  @override
  ConnectionState get connectionState => _state;

  @override
  StreamSink<ConnectionState> get stateSink => _stateCtrl.sink;

  @override
  StreamSink<IMMessage> get msgSink => _msgCtrl.sink;

  @override
  StreamSink<int> get errSink => _errCtrl.sink;

  @override
  void setState(ConnectionState next) {
    if (_state == next) return;
    final ConnectionState prev = _state;
    _state = next;
    IMLogger.d(_tag, 'state: $prev -> $next');
    if (!_stateCtrl.isClosed) _stateCtrl.add(next);
  }

  @override
  Future<void> sendAck(String fingerprint, String fromUserId) async {
    if (_channel == null) return;
    await _sendJson(<String, dynamic>{
      't': 4,
      'q': false,
      'f': fromUserId,
      'to': '',
      'fp': fingerprint,
      'd': '',
    });
  }

  @override
  bool get isClosed => _stateCtrl.isClosed;

  @override
  void onHeartbeatResponse() {
    _lastHeartbeatResponseMs = DateTime.now().millisecondsSinceEpoch;
  }

  // endregion

  String get _serverUrl {
    final String ip = IMConfig.serverIp;
    final int port = IMConfig.serverPort;
    final String scheme = IMConfig.ssl ? 'wss' : 'ws';
    return '$scheme://$ip:$port';
  }

  // region ===== 生命周期 =====

  @override
  Future<void> initCore() async {
    IMLogger.i(_tag,
        'initCore: url=$_serverUrl ssl=${IMConfig.ssl} autoReconnect=${IMConfig.autoReconnect}');
    if (_qosEvent != null) {
      _qos.event = _qosEvent;
    }
    _setState(ConnectionState.idle);
    startNetworkMonitor(
      onNetworkLost: () {
        IMLogger.w(_tag, 'network lost, closing socket');
        _channel?.sink.close();
        _setState(ConnectionState.disconnected);
      },
      onNetworkRestored: () {
        IMLogger.i(_tag, 'network restored, starting daemon');
        if (_state == ConnectionState.disconnected) {
          _startAutoReconnect();
        }
      },
    );
  }

  @override
  Future<void> releaseCore() async {
    stopNetworkMonitor();
    await disconnect();
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    _heartbeatTimeoutTimer?.cancel();
    _heartbeatTimeoutTimer = null;
    _stopAutoReconnect();
    _qos.reset();
    await _stateCtrl.close();
    await _msgCtrl.close();
    await _errCtrl.close();
    IMLogger.i(_tag, 'releaseCore done');
  }

  // endregion

  // region ===== 连接控制 =====

  @override
  Future<int> connect() async {
    try { await _channel?.sink.close(ws_status.normalClosure); } catch (_) {}
    try { await _sub?.cancel(); } catch (_) {}
    _channel = null;
    _sub = null;
    final int code = IMConfig.validate();
    if (code != 0) {
      _emitError(code);
      return code;
    }
    _setState(ConnectionState.connecting);
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(_serverUrl),
        pingInterval: const Duration(seconds: 10),
        connectTimeout: IMConfig.connectTimeout,
      );
      await _channel!.ready;
    } on SocketException catch (e) {
      IMLogger.e(_tag, 'connect SocketException', e);
      _emitError(ErrorCode.badConnectToServer);
      _setState(ConnectionState.disconnected);
      return ErrorCode.badConnectToServer;
    } on TimeoutException {
      IMLogger.e(_tag, 'connect timeout');
      _emitError(ErrorCode.connectionTimeout);
      _setState(ConnectionState.disconnected);
      return ErrorCode.connectionTimeout;
    } on WebSocketChannelException catch (e) {
      IMLogger.e(_tag, 'connect WebSocketChannelException', e);
      _emitError(ErrorCode.sslHandshakeFailed);
      _setState(ConnectionState.disconnected);
      return ErrorCode.sslHandshakeFailed;
    } catch (e, st) {
      IMLogger.e(_tag, 'connect error', e, st);
      _emitError(ErrorCode.badConnectToServer);
      _setState(ConnectionState.disconnected);
      return ErrorCode.badConnectToServer;
    }

    _sub = _channel!.stream.listen(
      _onData,
      onError: (Object e, StackTrace st) {
        IMLogger.e(_tag, 'ws error', e, st);
        _emitError(ErrorCode.brokenConnectToServer);
        _baseEvent?.onLinkClose?.call(ErrorCode.brokenConnectToServer);
        _setState(ConnectionState.disconnected);
        _startAutoReconnect();
      },
      onDone: () {
        IMLogger.w(_tag, 'ws done');
        if (_state == ConnectionState.connecting) return;
        if (_state == ConnectionState.connected ||
            _state == ConnectionState.logged) {
          _baseEvent?.onLinkClose?.call(ErrorCode.brokenConnectToServer);
          _emitError(ErrorCode.brokenConnectToServer);
        }
        _setState(ConnectionState.disconnected);
        _startAutoReconnect();
      },
      cancelOnError: false,
    );

    _lastHeartbeatResponseMs = null;
    _setState(ConnectionState.connected);
    IMLogger.i(_tag, 'connected: $_serverUrl');
    return 0;
  }

  @override
  Future<void> disconnect() async {
    _stopAutoReconnect();
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    _heartbeatTimeoutTimer?.cancel();
    _heartbeatTimeoutTimer = null;
    _qos.reset();
    _setState(ConnectionState.disconnecting);
    try {
      await _sub?.cancel();
      await _channel?.sink.close(ws_status.normalClosure);
    } catch (e) {
      IMLogger.w(_tag, 'disconnect error', e);
    }
    _sub = null;
    _channel = null;
    _setState(ConnectionState.disconnected);
  }

  @override
  Future<int> sendLogin({required String userId, required String token}) async {
    if (_channel == null) {
      _emitError(ErrorCode.brokenConnectToServer);
      return ErrorCode.brokenConnectToServer;
    }
    _currentUserId = userId;
    _currentToken = token;
    _setState(ConnectionState.logining);

    final String loginInfo = '{"loginUserId":"$userId","loginToken":"$token","loginExtra":null}';
    final int rc = await _sendJson({
      't': 0,
      'q': false,
      'f': userId,
      'to': '',
      'fp': '',
      'd': loginInfo,
    });
    if (rc == 0) {
      _startKeepAlive();
      _startHeartbeatTimeoutCheck();
    } else {
      _setState(ConnectionState.connected);
    }
    return rc;
  }

  @override
  Future<int> sendLogout() async {
    if (_channel == null) return 0;
    _setState(ConnectionState.logouting);
    final int rc = await _sendJson({
      't': 3,
      'q': false,
      'f': _currentUserId ?? '',
      'to': '',
      'fp': '',
      'd': '',
    });
    _stopKeepAlive();
    _currentUserId = null;
    await disconnect();
    return rc;
  }

  // endregion

  // region ===== 消息收发 =====

  @override
  Future<int> sendMessage(IMMessage msg) async {
    final int rc = await _sendJson(_encode(msg));
    if (rc == 0) {
      _qos.trackSent(msg);
    }
    return rc;
  }

  @override
  Future<int> sendText({
    required String fromUserId,
    required String toUserId,
    required String content,
    bool qos = true,
    UserTypeU typeu = UserTypeU.privateMessage,
    String? fingerprint,
  }) {
    return sendMessage(ProtocalFactory.createCommonData(
      content: content,
      fromUserId: fromUserId,
      toUserId: toUserId,
      qos: qos,
      typeu: typeu.value,
      fingerprint: fingerprint,
    ));
  }

  @override
  Future<int> sendBytes({
    required String fromUserId,
    required String toUserId,
    required List<int> bytes,
    bool qos = true,
    UserTypeU typeu = UserTypeU.privateMessage,
    String? fingerprint,
  }) {
    return sendMessage(ProtocalFactory.createCommonBinaryData(
      bytes: bytes,
      fromUserId: fromUserId,
      toUserId: toUserId,
      qos: qos,
      typeu: typeu.value,
      fingerprint: fingerprint,
    ));
  }

  @override
  void ackMessage(String fingerprint) {
    if (fingerprint.isEmpty || _channel == null) return;
    unawaited(sendAck(fingerprint, _currentUserId ?? '-1'));
  }

  @override
  Future<int> sendEcho({required String content}) async {
    return _sendJson(<String, dynamic>{
      't': 5,
      'q': false,
      'f': _currentUserId ?? '',
      'to': '',
      'fp': '',
      'd': content,
    });
  }

  // endregion

  // region ===== QosTransport =====

  @override
  bool get isOnline =>
      _channel != null &&
      (_state == ConnectionState.connected ||
          _state == ConnectionState.logged ||
          _state == ConnectionState.logining);

  @override
  Future<int> sendRaw(IMMessage msg) async {
    return sendMessage(msg);
  }

  // endregion

  // region ===== 内部:编解码+序列化+分发 =====

  Map<String, dynamic> _encode(IMMessage m) {
    final String? dataStr = utf8.decode(m.data, allowMalformed: true);
    return <String, dynamic>{
      't': m.type,
      'q': m.qos,
      'f': m.fromUserId ?? '',
      'to': m.toUserId ?? '',
      'fp': m.fingerprint ?? '',
      'd': dataStr,
    };
  }

  IMMessage _decode(Map<String, dynamic> j) {
    final int type = (j['t'] as num?)?.toInt() ?? 0;
    final bool qos = (j['q'] as bool?) ?? false;
    final String from = (j['f'] as String?) ?? '';
    final String to = (j['to'] as String?) ?? '';
    final String fp = (j['fp'] as String?) ?? '';
    final dynamic d = j['d'];
    final List<int> data = d is String
        ? utf8.encode(d)
        : (d is List ? List<int>.from(d) : <int>[]);
    return IMMessage(
      type: type,
      data: data,
      qos: qos,
      fromUserId: from.isEmpty ? null : from,
      toUserId: to.isEmpty ? null : to,
      fingerprint: fp.isEmpty ? null : fp,
    );
  }

  Future<int> _sendJson(Map<String, dynamic> json) async {
    if (_channel == null) {
      _emitError(ErrorCode.brokenConnectToServer);
      return ErrorCode.brokenConnectToServer;
    }
    try {
      _channel!.sink.add(jsonEncode(json));
      return 0;
    } catch (e, st) {
      IMLogger.e(_tag, 'send error', e, st);
      _emitError(ErrorCode.commonDataSendFailed);
      return ErrorCode.commonDataSendFailed;
    }
  }

  void _onData(dynamic data) {
    if (_stateCtrl.isClosed) return;
    if (data is String) {
      try {
        final dynamic decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          _dispatchCenter.dispatch(_decode(decoded));
        }
      } catch (e, st) {
        IMLogger.e(_tag, 'json parse error', e, st);
        _emitError(ErrorCode.protocalParseFailed);
      }
    } else if (data is List<int>) {
      if (data.isEmpty) return;
      final int type = data[0] & 0xFF;
      _dispatchCenter.dispatch(IMMessage(
        type: type == 0 ? 2 : type,
        data: data.sublist(1),
        qos: false,
      ));
    } else {
      IMLogger.w(_tag, 'unknown ws frame type: ${data.runtimeType}');
    }
  }

  // endregion

  // region ===== 心跳 =====

  void _startKeepAlive() {
    _stopKeepAlive();
    _keepAliveTimer = Timer.periodic(
      Duration(milliseconds: IMConfig.senseMode.millis),
      (_) => _sendKeepAlive(),
    );
  }

  void _stopKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
  }

  void _sendKeepAlive() {
    if (_channel == null) return;
    _sendJson({
      't': 1,
      'q': false,
      'f': _currentUserId ?? '',
      'to': '',
      'fp': '',
      'd': '',
    });
  }

  // endregion

  // region ===== 心跳超时检测 =====

  void _startHeartbeatTimeoutCheck() {
    _stopHeartbeatTimeoutCheck();
    _lastHeartbeatResponseMs = null;
    _heartbeatTimeoutTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _checkHeartbeatTimeout(),
    );
  }

  void _stopHeartbeatTimeoutCheck() {
    _heartbeatTimeoutTimer?.cancel();
    _heartbeatTimeoutTimer = null;
  }

  void _checkHeartbeatTimeout() {
    if (_lastHeartbeatResponseMs == null) return;
    final int elapsed =
        DateTime.now().millisecondsSinceEpoch - _lastHeartbeatResponseMs!;
    final int timeoutMs =
        IMConfig.senseMode.millis + _heartbeatTimeoutExtra();
    if (elapsed > timeoutMs) {
      IMLogger.w(_tag, 'heartbeat timeout, force disconnect');
      _baseEvent?.onLinkClose?.call(ErrorCode.networkInterrupted);
      _channel?.sink.close(ws_status.goingAway);
      _setState(ConnectionState.disconnected);
      _startAutoReconnect();
    }
  }

  int _heartbeatTimeoutExtra() {
    switch (IMConfig.senseMode) {
      case SenseMode.mode3S:
        return 2000;
      case SenseMode.mode5S:
        return 3000;
      default:
        return 5000;
    }
  }

  // endregion

  // region ===== AutoReLoginDaemon =====

  @override
  void stopAutoReconnect() {
    _stopAutoReconnect();
  }

  void _startAutoReconnect() {
    if (!IMConfig.autoReconnect) return;
    if (_reconnecting) return;
    _reconnecting = true;
    IMLogger.i(_tag, 'AutoReLoginDaemon started');
    _doReconnect();
  }

  void _stopAutoReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnecting = false;
    IMLogger.i(_tag, 'AutoReLoginDaemon stopped');
  }

  void _doReconnect() {
    if (!_reconnecting) return;
    if (!IMConfig.autoReconnect) return;
    _reconnectTimer?.cancel();
    final int delay = _reconnectDelaySec;
    IMLogger.i(_tag, 'reconnect after ${delay}s');
    _baseEvent?.onReconnecting?.call(0, 0);
    _reconnectTimer = Timer(Duration(seconds: delay), () async {
      if (!_reconnecting) return;
      try {
        final int rc = await connect();
        if (rc != 0) {
          _doReconnect();
          return;
        }
        if (_currentUserId != null && _currentToken != null) {
          final int loginRc = await sendLogin(
            userId: _currentUserId!,
            token: _currentToken!,
          );
          if (loginRc != 0) {
            _doReconnect();
            return;
          }
          await Future.delayed(const Duration(milliseconds: 500));
          if (_state != ConnectionState.logged) {
            _doReconnect();
            return;
          }
        }
      } catch (e, st) {
        IMLogger.e(_tag, '_doReconnect error', e, st);
        _doReconnect();
      }
    });
  }

  // endregion

  // region ===== 工具方法 =====

  void _setState(ConnectionState next) {
    if (_state == next) return;
    final ConnectionState prev = _state;
    _state = next;
    IMLogger.d(_tag, 'state: $prev -> $next');
    if (!_stateCtrl.isClosed) _stateCtrl.add(next);
  }

  void _emitError(int code) {
    IMLogger.w(_tag, 'error: ${ErrorCode.describe(code)} ($code)');
    if (!_errCtrl.isClosed) _errCtrl.add(code);
  }

  // endregion
}

