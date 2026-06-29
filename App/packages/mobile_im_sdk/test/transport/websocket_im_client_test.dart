import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

/// 用 dart:io HttpServer 启动一个最小的 WebSocket echo 服务.
Future<HttpServer> _startWsEcho(void Function(String) log) async {
  final HttpServer server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    0,
  );
  log('ws echo bound on ${server.port}');
  server.transform(WebSocketTransformer()).listen((WebSocket ws) {
    ws.listen((dynamic data) {
      if (data is String) {
        try {
          final Map<String, dynamic> j = jsonDecode(data) as Map<String, dynamic>;
          ws.add(jsonEncode(<String, dynamic>{
            't': j['t'] ?? 2,
            'q': j['q'] ?? false,
            'f': j['f'] ?? '',
            'to': j['f'] ?? '',
            'fp': j['fp'] ?? '',
            'd': j['d'] ?? '',
          }));
        } catch (_) {
          ws.add(data);
        }
      } else if (data is List<int>) {
        ws.add(data);
      }
    }, onDone: ws.close);
  });
  return server;
}

void main() {
  group('WebSocketImClient 集成', () {
    late HttpServer server;
    setUp(() async {
      IMConfig.reset();
      IMConfig.register(appKey: 'k');
      server = await _startWsEcho((String m) {/* noop */});
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = server.port;
      IMConfig.autoReconnect = false;
    });
    tearDown(() async {
      await server.close(force: true);
    });

    test('connect 成功', () async {
      final WebSocketImClient c = WebSocketImClient();
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = server.port;
      await c.initCore();
      // 用底层 IO 通道(因为我们的 connect 走 IMConfig.serverIp/serverPort,路径无 /)
      final int rc = await c.connect();
      expect(rc, 0);
      await c.disconnect();
      await c.releaseCore();
    });

    test('收到回声后 messageStream 收到 4-type 消息', () async {
      final WebSocketImClient c = WebSocketImClient();
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = server.port;
      final List<IMMessage> recv = <IMMessage>[];
      await c.initCore();
      await c.connect();
      c.messageStream.listen(recv.add);
      final int rc = await c.sendText(
        fromUserId: 'u',
        toUserId: 'v',
        content: 'ws-hi',
      );
      expect(rc, 0);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      // ws echo 服务把 type=4 回送
      expect(recv.where((IMMessage m) => m.textData == 'ws-hi').length,
          greaterThanOrEqualTo(1));
      await c.disconnect();
      await c.releaseCore();
    });

    test('sendBytes 走二进制路径不抛错', () async {
      final WebSocketImClient c = WebSocketImClient();
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = server.port;
      await c.initCore();
      await c.connect();
      final int rc = await c.sendBytes(
        fromUserId: 'u',
        toUserId: 'v',
        bytes: <int>[1, 2, 3, 4],
      );
      expect(rc, 0);
      await c.disconnect();
      await c.releaseCore();
    });

    test('releaseCore 后再次 connect 仍可工作', () async {
      final WebSocketImClient c = WebSocketImClient();
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = server.port;
      await c.initCore();
      await c.connect();
      await c.disconnect();
      await c.releaseCore();
      // 重新创建一个实例,避免 stream closed 问题
      final WebSocketImClient c2 = WebSocketImClient();
      await c2.initCore();
      final int rc = await c2.connect();
      expect(rc, 0);
      await c2.disconnect();
      await c2.releaseCore();
    });
  });
}
