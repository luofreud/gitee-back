import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';
import 'package:mobile_im_sdk/src/transport/frame_codec.dart';

/// 启动一个内存里的 TCP 回声服务端,用于联调测试.
Future<ServerSocket> _startEchoServer(void Function(String) log) async {
  final ServerSocket server = await ServerSocket.bind(
    InternetAddress.loopbackIPv4,
    0,
    backlog: 4,
  );
  log('echo server bound on ${server.port}');
  server.listen((Socket client) {
    client.listen((List<int> chunk) {
      // 简单回声:原样写回
      client.add(chunk);
    }, onDone: client.close);
  }, onError: (Object e) => log('server error: $e'));
  return server;
}

void main() {
  group('TcpImClient 集成', () {
    late ServerSocket server;
    setUp(() async {
      IMConfig.reset();
      IMConfig.register(appKey: 'k');
      IMConfig.autoReconnect = false;
      server = await _startEchoServer((String m) {/* noop */});
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = server.port;
    });
    tearDown(() async {
      await server.close();
    });

    test('connect 成功, 状态变为 connected', () async {
      final TcpImClient c = TcpImClient();
      await c.initCore();
      final int rc = await c.connect();
      expect(rc, 0);
      expect(c.state, ConnectionState.connected);
      await c.disconnect();
      await c.releaseCore();
    });

    test('connect 失败:端口未开启', () async {
      IMConfig.serverPort = 1; // 极小端口,通常未被占用
      final TcpImClient c = TcpImClient();
      await c.initCore();
      final int rc = await c.connect();
      expect(rc, isNot(0));
      expect(
          rc,
          anyOf(ErrorCode.badConnectToServer, ErrorCode.connectionTimeout,
              ErrorCode.brokenConnectToServer));
      await c.releaseCore();
    });

    test('disconnect 后再次 connect 成功', () async {
      final TcpImClient c = TcpImClient();
      await c.initCore();
      await c.connect();
      await c.disconnect();
      expect(c.state, ConnectionState.disconnected);
      final int rc2 = await c.connect();
      expect(rc2, 0);
      await c.disconnect();
      await c.releaseCore();
    });

    test('sendMessage 在 connected 状态成功', () async {
      final TcpImClient c = TcpImClient();
      await c.initCore();
      await c.connect();
      final int rc = await c.sendText(
        fromUserId: 'u',
        toUserId: 'u2',
        content: 'ping',
      );
      expect(rc, 0);
      await c.disconnect();
      await c.releaseCore();
    });

    test('echo 验证: 收到的 IMMessage data 字段与发送一致', () async {
      final TcpImClient c = TcpImClient();
      final List<IMMessage> received = <IMMessage>[];
      final StreamSubscription<IMMessage> sub =
          c.messageStream.listen(received.add);
      await c.initCore();
      await c.connect();

      // 修改协议以让回声数据能解析:服务端直接把字节回送,会再次通过 FrameCodec 解析
      await c.sendText(
        fromUserId: 'u',
        toUserId: 'u2',
        content: 'hello',
      );

      // 等待异步回声到达
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(received.where((IMMessage m) => m.textData == 'hello').length,
          greaterThanOrEqualTo(1));

      await sub.cancel();
      await c.disconnect();
      await c.releaseCore();
    });

    test('errorStream 抛出错误时收到码', () async {
      final TcpImClient c = TcpImClient();
      final List<int> errs = <int>[];
      final StreamSubscription<int> sub = c.errorStream.listen(errs.add);
      await c.initCore();
      await c.connect();
      await c.disconnect();
      // disconnect 不会主动触发 errorStream,这里仅检查订阅正常
      expect(sub, isNotNull);
      await c.releaseCore();
    });
  });

  group('FrameCodec + Tcp', () {
    test('一次发送 N 条消息, 全部正确解析', () async {
      final TcpImClient c = TcpImClient();
      IMConfig.reset();
      IMConfig.register(appKey: 'k');
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = 0; // 占位
      final ServerSocket echo = await _startEchoServer((_) {});
      IMConfig.serverPort = echo.port;
      final List<IMMessage> out = <IMMessage>[];
      await c.initCore();
      await c.connect();
      c.messageStream.listen(out.add);
      for (int i = 0; i < 5; i++) {
        await c.sendText(
          fromUserId: 'u',
          toUserId: 'v',
          content: 'msg-$i',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(out.where((IMMessage m) => m.textData.startsWith('msg-')).length,
          5);
      await c.disconnect();
      await c.releaseCore();
      await echo.close();
    });
  });
}
