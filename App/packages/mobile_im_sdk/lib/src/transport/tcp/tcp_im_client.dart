import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../../core/connection_type.dart';
import '../../core/error_code.dart';
import '../../core/im_client.dart';
import '../../core/im_config.dart';
import '../../core/im_event.dart';
import '../../core/im_message.dart';
import '../../core/protocal_factory.dart';
import '../../core/user_type_u.dart';
import '../../core/sense_mode.dart';
import '../../utils/byte_utils.dart';
import '../../utils/im_logger.dart';
import '../../utils/network_monitor_mixin.dart';
import '../dispatch_center.dart';
import '../frame_codec.dart';
import '../qos_daemon.dart';

/// TCP 客户端实现,对应 MobileIMSDK iOS/Android TCP 端.
class TcpImClient with NetworkMonitorMixin implements IMClient, QosTransport, DispatchDelegate {
  TcpImClient();

  static const String _tag = 'TcpImClient';

  Socket? _socket;
  final FrameParser _parser = FrameParser();

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
  ConnectionType get connectionType => ConnectionType.tcp;

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
    final IMMessage ack = ProtocalFactory.createRecivedBack(
      fromUserId: fromUserId,
      fingerprint: fingerprint,
    );
    await _sendRaw(ack);
  }

  // endregion

  // region ===== 生命周期 =====

  @override
  Future<void> initCore() async {
    IMLogger.i(_tag,
        'initCore: ip=${IMConfig.serverIp} port=${IMConfig.serverPort} ssl=${IMConfig.ssl}');
    _setState(ConnectionState.idle);
    startNetworkMonitor(
      onNetworkLost: () {
        IMLogger.w(_tag, 'network lost, closing socket');
        _socket?.close();
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
    await _stateCtrl.close();
    await _msgCtrl.close();
    await _errCtrl.close();
    IMLogger.i(_tag, 'releaseCore done');
  }

  // endregion

  // region ===== 连接控制 =====

  @override
  Future<int> connect() async {
    try { await _socket?.close(); } catch (_) {}
    _socket = null;
    final int code = IMConfig.validate();
    if (code != 0) {
      IMLogger.e(_tag, 'connect 配置不合法 $code');
      _emitError(code);
      return code;
    }
    _setState(ConnectionState.connecting);
    try {
      _socket = await Socket.connect(
        IMConfig.serverIp,
        IMConfig.serverPort,
        timeout: IMConfig.connectTimeout,
      );
    } on SocketException catch (e) {
      IMLogger.e(_tag, 'connect SocketException', e);
      _setState(ConnectionState.disconnected);
      _emitError(ErrorCode.badConnectToServer);
      return ErrorCode.badConnectToServer;
    } on TimeoutException {
      IMLogger.e(_tag, 'connect timeout');
      _setState(ConnectionState.disconnected);
      _emitError(ErrorCode.connectionTimeout);
      return ErrorCode.connectionTimeout;
    }

    _socket!.listen(
      _onData,
      onError: _onSocketError,
      onDone: _onSocketDone,
      cancelOnError: false,
    );
    _parser.reset();
    _lastHeartbeatResponseMs = null;
    _setState(ConnectionState.connected);
    IMLogger.i(
        _tag, 'connected to ${IMConfig.serverIp}:${IMConfig.serverPort}');
    return 0;
  }

  @override
  Future<void> disconnect() async {
    _stopAutoReconnect();
    _stopKeepAlive();
    _stopHeartbeatTimeoutCheck();
    _qos.reset();
    _setState(ConnectionState.disconnecting);
    try {
      await _socket?.flush();
      await _socket?.close();
    } catch (e) {
      IMLogger.w(_tag, 'disconnect error', e);
    }
    _socket = null;
    _setState(ConnectionState.disconnected);
  }

  @override
  Future<int> sendLogin({required String userId, required String token}) async {
    if (state != ConnectionState.connected) {
      IMLogger.w(_tag, 'sendLogin but state=$state');
      _emitError(ErrorCode.brokenConnectToServer);
      return ErrorCode.brokenConnectToServer;
    }
    _currentUserId = userId;
    _currentToken = token;
    _setState(ConnectionState.logining);

    final String loginInfo = _buildLoginJson(userId, token);
    final IMMessage login = IMMessage(
      type: 0,
      data: ByteUtils.utf8Bytes(loginInfo),
      fromUserId: userId,
      qos: false,
      bridge: true,
    );
    final int rc = await _sendRaw(login);
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
    if (_socket == null) {
      _stopKeepAlive();
      _currentUserId = null;
      return 0;
    }
    _setState(ConnectionState.logouting);
    final IMMessage logout = ProtocalFactory.createPLoginoutInfo(
      _currentUserId ?? '',
    );
    final int rc = await _sendRaw(logout);
    _stopKeepAlive();
    _currentUserId = null;
    await disconnect();
    return rc;
  }

  // endregion

  // region ===== 消息收发 =====

  @override
  Future<int> sendMessage(IMMessage msg) async {
    if (state == ConnectionState.idle ||
        state == ConnectionState.disconnected) {
      IMLogger.w(_tag, 'sendMessage but state=$state');
      _emitError(ErrorCode.brokenConnectToServer);
      return ErrorCode.brokenConnectToServer;
    }
    return _sendRaw(msg);
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
    if (fingerprint.isEmpty) return;
    unawaited(sendAck(fingerprint, _currentUserId ?? '-1'));
  }

  @override
  Future<int> sendEcho({required String content}) {
    final IMMessage echo = IMMessage(
      type: 5,
      data: ByteUtils.utf8Bytes(content),
      fromUserId: _currentUserId,
      qos: false,
    );
    return _sendRaw(echo);
  }

  // endregion

  // region ===== QosTransport =====

  @override
  bool get isOnline =>
      _state == ConnectionState.connected ||
      _state == ConnectionState.logining ||
      _state == ConnectionState.logged;

  @override
  Future<int> sendRaw(IMMessage msg) => _sendRaw(msg);

  // endregion

  // region ===== 内部:编解码+分发 =====

  Future<int> _sendRaw(IMMessage msg) {
    try {
      final Uint8List frame = FrameCodec.encode(msg);
      _socket!.add(frame);
      _qos.trackSent(msg);
      return Future<int>.value(0);
    } on SocketException catch (e) {
      IMLogger.e(_tag, '_sendRaw SocketException', e);
      _emitError(ErrorCode.commonDataSendFailed);
      return Future<int>.value(ErrorCode.commonDataSendFailed);
    } catch (e, st) {
      IMLogger.e(_tag, '_sendRaw error', e, st);
      _emitError(ErrorCode.commonUnknownError);
      return Future<int>.value(ErrorCode.commonUnknownError);
    }
  }

  void _onData(List<int> chunk) {
    final List<IMMessage> frames = _parser.feed(chunk);
    for (final IMMessage m in frames) {
      _dispatchCenter.dispatch(m);
    }
  }

  void _onSocketError(Object e, StackTrace st) {
    IMLogger.e(_tag, 'socket error', e, st);
    _emitError(ErrorCode.brokenConnectToServer);
    _baseEvent?.onLinkClose?.call(ErrorCode.brokenConnectToServer);
    _setState(ConnectionState.disconnected);
    _startAutoReconnect();
  }

  void _onSocketDone() {
    IMLogger.w(_tag, 'socket done (remote closed)');
    if (_state == ConnectionState.connecting) return;
    if (_state == ConnectionState.logged ||
        _state == ConnectionState.connected) {
      _baseEvent?.onLinkClose?.call(ErrorCode.brokenConnectToServer);
      _emitError(ErrorCode.brokenConnectToServer);
    }
    _setState(ConnectionState.disconnected);
    _startAutoReconnect();
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
    if (_socket == null) return;
    final IMMessage ka = ProtocalFactory.createPKeepAlive(_currentUserId);
    _sendRaw(ka);
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
    final int timeoutMs = IMConfig.senseMode.millis +
        _heartbeatTimeoutExtra();
    if (elapsed > timeoutMs) {
      IMLogger.w(_tag, 'heartbeat timeout, force disconnect');
      _baseEvent?.onLinkClose?.call(ErrorCode.networkInterrupted);
      _socket?.close();
      _setState(ConnectionState.disconnected);
      _startAutoReconnect();
    }
  }

  int _heartbeatTimeoutExtra() {
    // 对应原生: mode3S->2s, 其余+5s 左右
    switch (IMConfig.senseMode) {
      case SenseMode.mode3S:
        return 2000;
      case SenseMode.mode5S:
        return 3000;
      default:
        return 5000;
    }
  }

  @override
  bool get isClosed => _stateCtrl.isClosed;

  @override
  void onHeartbeatResponse() {
    _lastHeartbeatResponseMs = DateTime.now().millisecondsSinceEpoch;
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

  String _buildLoginJson(String userId, String token) {
    return '{"loginUserId":"$userId","loginToken":"$token","loginExtra":null}';
  }

  // endregion
}

