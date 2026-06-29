import 'package:flutter/material.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

import '../widgets/log_console.dart';

/// 通用 IM 演示页脚手架(TCP/UDP/WebSocket 共用同一份 UI 逻辑).
///
/// 业务层调用 [buildClient] 工厂方法得到 IM 客户端实例,后续步骤统一.
abstract class BaseImDemoPage extends StatefulWidget {
  final String title;
  final ConnectionType connectionType;

  /// MobileIMSDK 服务端该协议对应的默认端口.
  /// UDP: 7901, TCP: 8901, WebSocket: 3000.
  final String defaultPort;

  const BaseImDemoPage({
    Key? key,
    required this.title,
    required this.connectionType,
    required this.defaultPort,
  }) : super(key: key);
}

abstract class BaseImDemoPageState<T extends BaseImDemoPage> extends State<T> {
  final TextEditingController _ipCtrl =
      TextEditingController(text: '192.168.1.90');

  /// MobileIMSDK 服务端默认端口:
  ///   UDP: 7901 / TCP: 8901 / WebSocket: 3000.
  /// 由 [BaseImDemoPage.defaultPort] 提供,不同协议页面的默认端口不同.
  final TextEditingController _portCtrl;

  BaseImDemoPageState()
      : _portCtrl = TextEditingController(text: '7901');

  final TextEditingController _uidCtrl = TextEditingController(text: 'user1');
  final TextEditingController _tokenCtrl =
      TextEditingController(text: 'token123');
  final TextEditingController _toUidCtrl =
      TextEditingController(text: 'user2');
  final TextEditingController _msgCtrl =
      TextEditingController(text: 'Hello from Flutter!');

  final GlobalKey<LogConsoleState> _logKey = GlobalKey<LogConsoleState>();

  IMClient? client;

  /// 由子类返回具体客户端实现.
  IMClient createClient();

  void log(String msg) {
    _logKey.currentState?.append(msg);
  }

  @override
  void initState() {
    super.initState();
    // 同步 widget 的默认端口(子类在构造时已传入)
    _portCtrl.text = widget.defaultPort;
    client = createClient();
    _bindEvents(client!);
    log('已创建 ${widget.connectionType.name} 客户端实例');
  }

  void _bindEvents(IMClient c) {
    c.baseEvent = ChatBaseEvent(
      onLoginResponse: (int code) {
        log('登录响应: $code (${ErrorCode.describe(code)})');
      },
      onLinkClose: (int code) {
        log('连接关闭: $code (${ErrorCode.describe(code)})');
      },
      onKickout: (PKickoutInfo ki) {
        log('被踢下线: code=${ki.code} msg=${ki.reason}');
      },
      onReconnecting: (int attempt, int max) {
        log('正在重连: $attempt / $max');
      },
    );
    c.messageEvent = ChatMessageEvent(
      onRecieveMessage: (String fp, String from, String content, int type) {
        log('<< 收消息 fp=$fp from=$from: $content');
      },
      onErrorResponse: (int code, String msg) {
        log('!! 错误响应: $code - $msg');
      },
    );
    c.qosEvent = MessageQoSEvent(
      onAckReceived: (String fp) {
        log('ACK 收到: $fp');
      },
      onSendFailed: (String fp, int code) {
        log('发送失败: fp=$fp code=$code');
      },
    );
  }

  @override
  void dispose() {
    client?.releaseCore();
    _ipCtrl.dispose();
    _portCtrl.dispose();
    _uidCtrl.dispose();
    _tokenCtrl.dispose();
    _toUidCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _doConnect() async {
    if (client == null) return;
    IMConfig.register(appKey: 'demo-app-key');
    IMConfig.serverIp = _ipCtrl.text.trim();
    IMConfig.serverPort = int.tryParse(_portCtrl.text.trim()) ?? 0;
    IMConfig.debug = true;
    IMConfig.autoReconnect = true;
    IMConfig.senseMode = SenseMode.mode5S;

    log('--> 连接到 ${IMConfig.serverIp}:${IMConfig.serverPort}');
    final int code = await client!.connect();
    if (code == 0) {
      log('连接成功');
    } else {
      log('连接失败: ${ErrorCode.describe(code)} ($code)');
    }
  }

  Future<void> _doDisconnect() async {
    log('--> 断开连接');
    await client?.disconnect();
  }

  Future<void> _doLogin() async {
    if (client == null) return;
    log('--> 发送登录 userId=${_uidCtrl.text}');
    final int code =
        await client!.sendLogin(userId: _uidCtrl.text, token: _tokenCtrl.text);
    log('登录结果: $code (${ErrorCode.describe(code)})');
  }

  Future<void> _doLogout() async {
    if (client == null) return;
    log('--> 登出');
    await client!.sendLogout();
  }

  Future<void> _doSend() async {
    if (client == null) return;
    log(
        '--> 发送消息 to=${_toUidCtrl.text}: ${_msgCtrl.text}');
    final int code = await client!.sendText(
      fromUserId: _uidCtrl.text,
      toUserId: _toUidCtrl.text,
      content: _msgCtrl.text,
    );
    log('发送结果: $code (${ErrorCode.describe(code)})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _section('服务端配置'),
          _row(<Widget>[
            Expanded(
              child: TextField(
                controller: _ipCtrl,
                decoration: const InputDecoration(
                  labelText: 'IP',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _portCtrl,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          _row(<Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: _doConnect,
                child: const Text('连接'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _doDisconnect,
                child: const Text('断开'),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _section('登录 / 注销'),
          _row(<Widget>[
            Expanded(
              child: TextField(
                controller: _uidCtrl,
                decoration: const InputDecoration(
                  labelText: 'userId',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _tokenCtrl,
                decoration: const InputDecoration(
                  labelText: 'token',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          _row(<Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: _doLogin,
                child: const Text('登录'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: _doLogout,
                child: const Text('登出'),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _section('消息收发'),
          TextField(
            controller: _toUidCtrl,
            decoration: const InputDecoration(
              labelText: '目标 userId',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _msgCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '消息内容',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _doSend,
            icon: const Icon(Icons.send),
            label: const Text('发送消息'),
          ),
          const SizedBox(height: 16),
          LogConsole(key: _logKey),
        ],
      ),
    );
  }

  Widget _section(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
      );

  Widget _row(List<Widget> children) => Row(children: children);
}
