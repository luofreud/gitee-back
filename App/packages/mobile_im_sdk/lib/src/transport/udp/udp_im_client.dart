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

/// UDP 客户端实现,对应 MobileIMSDK iOS/Android UDP 端.
class UdpImClient with NetworkMonitorMixin implements IMClient, QosTransport, DispatchDelegate {
  UdpImClient();

  static const String _tag = 'UdpImClient';

  RawDatagramSocket? _socket;
  final FrameParser _parser = FrameParser();
  StreamSubscription<RawSocketEvent>? _sub;

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

  InternetAddress? get localAddress => _socket?.address;
  int get localPort => _socket?.port ?? 0;

  // region ===== IMClient =====

  @override
  ConnectionType get connectionType => ConnectionType.udp;

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
    if (_socket == null) return;
    final IMMessage ack = ProtocalFactory.createRecivedBack(
      fromUserId: fromUserId,
      fingerprint: fingerprint,
    );
    await _sendTo(ack, IMConfig.serverIp, IMConfig.serverPort);
  }

  @override
  bool get isClosed => _stateCtrl.isClosed;

  @override
  void onHeartbeatResponse() {
    _lastHeartbeatResponseMs = DateTime.now().millisecondsSinceEpoch;
  }

  // endregion

  // region ===== 生命周期 =====

  @override
  Future<void> initCore() async {
    IMLogger.i(_tag,
        'initCore: server=${IMConfig.serverIp}:${IMConfig.serverPort} localPort=${IMConfig.localPort}');
    if (_qosEvent != null) {
      _qos.event = _qosEvent;
    }
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
    await _sub?.cancel();
    _sub = null;
    _qos.reset();
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
    try { await _sub?.cancel(); } catch (_) {}
    _sub = null;
    _socket?.close();
    _socket = null;
    final int code = IMConfig.validate();
    if (code != 0) {
      IMLogger.e(_tag, 'connect 配置不合法 $code');
      _emitError(code);
      return code;
    }
    _setState(ConnectionState.connecting);
    try {
      _socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        IMConfig.localPort,
        reuseAddress: true,
      );
    } on SocketException catch (e) {
      IMLogger.e(_tag, 'bind SocketException', e);
      _emitError(ErrorCode.socketBindFailed);
      _setState(ConnectionState.disconnected);
      return ErrorCode.socketBindFailed;
    } catch (e, st) {
      IMLogger.e(_tag, 'bind error', e, st);
      _emitError(ErrorCode.socketCreateFailed);
      _setState(ConnectionState.disconnected);
      return ErrorCode.socketCreateFailed;
    }
    _parser.reset();
    _sub = _socket!.listen(_onEvent, onError: (Object e, StackTrace st) {
      IMLogger.e(_tag, 'socket error', e, st);
      _emitError(ErrorCode.networkInterrupted);
      _baseEvent?.onLinkClose?.call(ErrorCode.networkInterrupted);
    });
    _lastHeartbeatResponseMs = null;
    _setState(ConnectionState.connected);
    IMLogger.i(_tag,
        'bound on ${_socket!.address.address}:${_socket!.port} -> server ${IMConfig.serverIp}:${IMConfig.serverPort}');
    return 0;
  }

  @override
  Future<void> disconnect() async {
    _stopAutoReconnect();
    _stopKeepAlive();
    _stopHeartbeatTimeoutCheck();
    _setState(ConnectionState.disconnecting);
    await _sub?.cancel();
    _sub = null;
    _socket?.close();
    _socket = null;
    _setState(ConnectionState.disconnected);
  }

  @override
  Future<int> sendLogin({required String userId, required String token}) async {
    if (_socket == null) {
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
    final int rc = await _sendTo(login, IMConfig.serverIp, IMConfig.serverPort);
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
    if (_socket == null) return 0;
    _setState(ConnectionState.logouting);
    final IMMessage logout = ProtocalFactory.createPLoginoutInfo(
      _currentUserId ?? '',
    );
    final int rc =
        await _sendTo(logout, IMConfig.serverIp, IMConfig.serverPort);
    _stopKeepAlive();
    _currentUserId = null;
    await disconnect();
    return rc;
  }

  // endregion

  // region ===== 消息收发 =====

  @override
  Future<int> sendMessage(IMMessage msg) async {
    return _sendTo(msg, IMConfig.serverIp, IMConfig.serverPort);
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
    if (fingerprint.isEmpty || _socket == null) return;
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
    return _sendTo(echo, IMConfig.serverIp, IMConfig.serverPort);
  }

  // endregion

  // region ===== QosTransport =====

  @override
  bool get isOnline =>
      _socket != null &&
      (_state == ConnectionState.connected ||
          _state == ConnectionState.logged ||
          _state == ConnectionState.logining);

  @override
  Future<int> sendRaw(IMMessage msg) async {
    return _sendTo(msg, IMConfig.serverIp, IMConfig.serverPort);
  }

  // endregion

  // region ===== 广播/组播 =====

  set broadcastEnabled(bool value) {
    _socket?.broadcastEnabled = value;
  }

  Future<int> sendTo({
    required IMMessage msg,
    required String host,
    required int port,
  }) {
    return _sendTo(msg, host, port);
  }

  Future<int> sendBroadcast(IMMessage msg, {int? port}) {
    return _sendTo(msg, '255.255.255.255', port ?? IMConfig.serverPort);
  }

  void joinMulticast(String group) {
    try {
      _socket?.joinMulticast(InternetAddress(group));
      IMLogger.i(_tag, 'joined multicast group: $group');
    } catch (e) {
      IMLogger.w(_tag, 'joinMulticast($group) failed: $e');
    }
  }

  void leaveMulticast(String group) {
    try {
      _socket?.leaveMulticast(InternetAddress(group));
      IMLogger.i(_tag, 'left multicast group: $group');
    } catch (e) {
      IMLogger.w(_tag, 'leaveMulticast($group) failed: $e');
    }
  }

  // endregion

  // region ===== 内部:编解码+分发 =====

  Future<int> _sendTo(IMMessage msg, String host, int port) async {
    if (_socket == null) {
      _emitError(ErrorCode.brokenConnectToServer);
      return ErrorCode.brokenConnectToServer;
    }
    try {
      final Uint8List frame = FrameCodec.encode(msg);
      _socket!.send(frame, InternetAddress(host), port);
      _qos.trackSent(msg);
      return 0;
    } on SocketException catch (e) {
      IMLogger.e(_tag, 'send SocketException', e);
      _emitError(ErrorCode.commonDataSendFailed);
      return ErrorCode.commonDataSendFailed;
    } catch (e, st) {
      IMLogger.e(_tag, 'send error', e, st);
      _emitError(ErrorCode.commonUnknownError);
      return ErrorCode.commonUnknownError;
    }
  }

  void _onEvent(RawSocketEvent event) {
    if (event != RawSocketEvent.read) return;
    if (_stateCtrl.isClosed) return;
    final Datagram? dg = _socket?.receive();
    if (dg == null) return;
    final List<IMMessage> frames = _parser.feed(dg.data);
    for (final IMMessage m in frames) {
      _dispatchCenter.dispatch(m);
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
    if (_socket == null) return;
    final IMMessage ka = ProtocalFactory.createPKeepAlive(_currentUserId);
    _sendTo(ka, IMConfig.serverIp, IMConfig.serverPort);
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

  String _buildLoginJson(String userId, String token) {
    return '{"loginUserId":"$userId","loginToken":"$token","loginExtra":null}';
  }

  // endregion
}
