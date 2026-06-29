import 'package:flutter/material.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

import '../widgets/log_console.dart';

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({Key? key}) : super(key: key);

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final TextEditingController _urlCtrl =
      TextEditingController(text: 'ws://192.168.1.90:3000/ws');
  final TextEditingController _uidCtrl =
      TextEditingController(text: 'user1');
  final TextEditingController _tokenCtrl =
      TextEditingController(text: 'token123');
  final TextEditingController _toUidCtrl =
      TextEditingController(text: 'user2');
  final TextEditingController _msgCtrl =
      TextEditingController(text: 'Hello WebSocket!');

  final GlobalKey<LogConsoleState> _logKey = GlobalKey<LogConsoleState>();
  WebSocketImClient? _ws;

  void log(String m) => _logKey.currentState?.append(m);

  @override
  void initState() {
    super.initState();
    _ws = WebSocketImClient();
    _ws!.baseEvent = ChatBaseEvent(
      onLoginResponse: (int code) => log('登录响应: $code'),
      onLinkClose: (int code) => log('连接关闭: $code'),
      onKickout: (PKickoutInfo ki) => log('被踢: code=${ki.code} msg=${ki.reason}'),
      onReconnecting: (int a, int m) => log('重连: $a/$m'),
    );
    _ws!.messageEvent = ChatMessageEvent(
      onRecieveMessage: (String fp, String from, String content, int type) =>
          log('<< 收消息 fp=$fp from=$from: $content'),
      onErrorResponse: (int code, String msg) => log('!! 错误 $code: $msg'),
    );
  }

  @override
  void dispose() {
    _ws?.releaseCore();
    _urlCtrl.dispose();
    _uidCtrl.dispose();
    _tokenCtrl.dispose();
    _toUidCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Uri _parseUrl() {
    String s = _urlCtrl.text.trim();
    if (!s.contains('://')) s = 'ws://$s';
    return Uri.parse(s);
  }

  Future<void> _connect() async {
    final Uri u = _parseUrl();
    IMConfig.register(appKey: 'demo-app-key');
    IMConfig.serverIp = u.host;
    IMConfig.serverPort = u.hasPort ? u.port : (u.scheme == 'wss' ? 443 : 80);
    IMConfig.ssl = u.scheme == 'wss';
    IMConfig.debug = true;
    log('--> 连接 WebSocket $u');
    final int code = await _ws!.connect();
    log('connect: ${ErrorCode.describe(code)} ($code)');
  }

  Future<void> _disconnect() async {
    await _ws?.disconnect();
    log('已断开');
  }

  Future<void> _login() async {
    final int code = await _ws!.sendLogin(
        userId: _uidCtrl.text, token: _tokenCtrl.text);
    log('login: $code');
  }

  Future<void> _sendText() async {
    final int code = await _ws!.sendText(
      fromUserId: _uidCtrl.text,
      toUserId: _toUidCtrl.text,
      content: _msgCtrl.text,
    );
    log('send text: $code');
  }

  Future<void> _sendBytes() async {
    final List<int> bytes = _msgCtrl.text.codeUnits;
    final int code = await _ws!.sendBytes(
      fromUserId: _uidCtrl.text,
      toUserId: _toUidCtrl.text,
      bytes: bytes,
    );
    log('send bytes(len=${bytes.length}): $code');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSocket 演示')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text('WebSocket URL',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _urlCtrl,
            decoration: const InputDecoration(
              labelText: 'ws://host:port/path',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _connect,
                  child: const Text('连接'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _disconnect,
                  child: const Text('断开'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('登录', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
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
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _login, child: const Text('登录')),
          const SizedBox(height: 16),
          const Text('消息收发',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
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
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: '消息',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _sendText,
                  icon: const Icon(Icons.text_fields),
                  label: const Text('文本'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _sendBytes,
                  icon: const Icon(Icons.memory),
                  label: const Text('二进制'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LogConsole(key: _logKey),
        ],
      ),
    );
  }
}
