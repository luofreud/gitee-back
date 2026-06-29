import 'package:flutter/material.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

import '../widgets/log_console.dart';

/// UDP 演示页(对齐 MobileIMSDK Android/iOS UDP 接口).
///
/// 包含单播、广播、组播三种发送模式.
class UdpPage extends StatefulWidget {
  const UdpPage({Key? key}) : super(key: key);

  @override
  State<UdpPage> createState() => _UdpPageState();
}

class _UdpPageState extends State<UdpPage> {
  final TextEditingController _ipCtrl = TextEditingController(text: '192.168.1.90');
  final TextEditingController _portCtrl = TextEditingController(text: '7901');
  final TextEditingController _uidCtrl = TextEditingController(text: 'user1');
  final TextEditingController _tokenCtrl =
      TextEditingController(text: 'token123');
  final TextEditingController _toUidCtrl =
      TextEditingController(text: 'user2');
  final TextEditingController _msgCtrl =
      TextEditingController(text: 'Hello UDP!');
  final TextEditingController _groupCtrl =
      TextEditingController(text: '224.0.0.1');

  final GlobalKey<LogConsoleState> _logKey = GlobalKey<LogConsoleState>();
  UdpImClient? _udp;

  void log(String msg) => _logKey.currentState?.append(msg);

  @override
  void initState() {
    super.initState();
    _udp = UdpImClient();
    _bindEvents(_udp!);
  }

  void _bindEvents(UdpImClient c) {
    c.baseEvent = ChatBaseEvent(
      onLoginResponse: (int code) => log('登录响应: $code'),
      onLinkClose: (int code) => log('连接关闭: $code'),
      onKickout: (PKickoutInfo ki) => log('被踢: code=${ki.code} msg=${ki.reason}'),
    );
    c.messageEvent = ChatMessageEvent(
      onRecieveMessage: (String fp, String from, String content, int type) =>
          log('<< 收消息 fp=$fp from=$from: $content'),
      onErrorResponse: (int code, String msg) => log('!! 错误 $code: $msg'),
    );
  }

  @override
  void dispose() {
    _udp?.releaseCore();
    _ipCtrl.dispose();
    _portCtrl.dispose();
    _uidCtrl.dispose();
    _tokenCtrl.dispose();
    _toUidCtrl.dispose();
    _msgCtrl.dispose();
    _groupCtrl.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    IMConfig.register(appKey: 'demo-app-key');
    IMConfig.serverIp = _ipCtrl.text.trim();
    IMConfig.serverPort = int.tryParse(_portCtrl.text.trim()) ?? 0;
    IMConfig.debug = true;
    log('--> 绑定 UDP 本地端口 (bind any:0)');
    final int code = await _udp!.connect();
    log('connect: ${ErrorCode.describe(code)} ($code), local=${_udp!.localPort}');
  }

  Future<void> _disconnect() async {
    await _udp?.disconnect();
    log('已关闭 UDP socket');
  }

  Future<void> _login() async {
    log('--> 登录');
    final int code = await _udp!.sendLogin(
        userId: _uidCtrl.text, token: _tokenCtrl.text);
    log('login: $code');
  }

  Future<void> _logout() async {
    await _udp?.sendLogout();
  }

  Future<void> _send() async {
    final int code = await _udp!.sendText(
      fromUserId: _uidCtrl.text,
      toUserId: _toUidCtrl.text,
      content: _msgCtrl.text,
    );
    log('send(单播): $code');
  }

  Future<void> _sendBroadcast() async {
    log('--> 发送广播消息 (255.255.255.255:${IMConfig.serverPort})');
    final int code = await _udp!.sendBroadcast(
      IMMessage.business(
        fromUserId: _uidCtrl.text,
        toUserId: 'ALL',
        content: _msgCtrl.text,
        qos: false,
      ),
    );
    log('broadcast send: $code');
  }

  void _joinMulticast() {
    _udp?.joinMulticast(_groupCtrl.text.trim());
    log('--> 加入组播: ${_groupCtrl.text}');
  }

  void _leaveMulticast() {
    _udp?.leaveMulticast(_groupCtrl.text.trim());
    log('--> 离开组播: ${_groupCtrl.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UDP 演示')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text('服务端配置',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
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
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _connect,
                  child: const Text('绑定 (connect)'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _disconnect,
                  child: const Text('关闭'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('登录 / 登出',
              style: TextStyle(fontWeight: FontWeight.w600)),
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
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('登录'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _logout,
                  child: const Text('登出'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('消息收发(单播)',
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
                  onPressed: _send,
                  icon: const Icon(Icons.send),
                  label: const Text('单播'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _sendBroadcast,
                  icon: const Icon(Icons.podcasts),
                  label: const Text('广播'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('组播(对齐 MobileIMSDK UDP 接口)',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _groupCtrl,
            decoration: const InputDecoration(
              labelText: '组播地址 (224.0.0.0/4)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _joinMulticast,
                  child: const Text('加入组播'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _leaveMulticast,
                  child: const Text('离开组播'),
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
