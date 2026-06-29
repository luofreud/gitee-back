// MobileIMSDK Flutter 插件 - 集成测试
//
// 覆盖跨组件联动场景:
//  1) TCP: connect -> login -> echo -> reconnect-after-server-restart
//  2) UDP: connect -> send -> receive echo -> close
//  3) WebSocket: connect -> send text -> receive echo -> close
//  4) IMFactory: 创建不同传输的客户端
//  5) 状态机: connect/connected/disconnect/disconnected 转换
//
// 注意: 集成测试不依赖真实服务器, 内部起一个回声服务.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

import 'test_helpers.dart';

void main() {
  group('集成测试: 跨组件联动', () {
    setUp(() {
      IMConfig.reset();
      IMConfig.register(appKey: 'integration-app-key');
    });

    test('TCP: 完整 connect -> login -> 业务消息 echo', () async {
      final MockTcpServer srv = await MockTcpServer.start(
        onFrame: (List<int> data, MockTcpClient peer) async {
          // 模拟 MobileIMSDK 服务端: 对登录响应 + 对业务消息回送
          final List<IMMessage> msgs = FrameParser().feed(data);
          for (final IMMessage m in msgs) {
            if (m.type == IMMessageType.fromClientTypeLogin) {
              // 服务端用 type=50(fromServerTypeOfResponseLogin) + JSON code 字段回复
              final String resp = jsonEncode(<String, dynamic>{
                'code': 0,
                'user_id': m.fromUserId ?? '',
                'firstLoginTime': DateTime.now().millisecondsSinceEpoch,
              });
              await peer.send(FrameCodec.encode(IMMessage(
                type: IMMessageType.fromServerTypeOfResponseLogin,
                data: utf8.encode(resp),
                fromUserId: 'server',
                toUserId: m.fromUserId,
                fingerprint: 'fp-login',
              )));
            } else {
              // 业务消息原样 echo(type 保持 2)
              await peer.send(FrameCodec.encode(m));
            }
          }
        },
      );
      addTearDown(srv.close);

      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = srv.port;

      final TcpImClient c = TcpImClient();
      int? loginCode;
      c.baseEvent = ChatBaseEvent(onLoginResponse: (int code) => loginCode = code);
      final List<IMMessage> received = <IMMessage>[];
      c.messageStream.listen(received.add);

      await c.initCore();
      final int rc = await c.connect();
      expect(rc, 0);
      expect(c.state, ConnectionState.connected);

      final int loginRc = await c.sendLogin(userId: 'u1', token: 't1');
      expect(loginRc, 0);

      // 等登录回包
      await waitFor(() => loginCode == 0, timeout: const Duration(seconds: 2));
      expect(c.state, ConnectionState.logged);

      // 发业务消息
      final int sendRc = await c.sendText(
        fromUserId: 'u1',
        toUserId: 'u2',
        content: 'integration-tcp-hi',
      );
      expect(sendRc, 0);

      // 等 echo
      await waitFor(
        () => received.any((IMMessage m) => m.textData == 'integration-tcp-hi'),
        timeout: const Duration(seconds: 2),
      );
      expect(received.where((IMMessage m) => m.textData == 'integration-tcp-hi').length,
          greaterThanOrEqualTo(1));

      await c.releaseCore();
    });

    test('UDP: connect -> send -> 收到 echo', () async {
      final RawDatagramSocket echo = await bindUdpEcho();
      addTearDown(() => echo.close());

      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = echo.port;

      final UdpImClient c = UdpImClient();
      final List<IMMessage> received = <IMMessage>[];
      c.messageStream.listen(received.add);

      await c.initCore();
      final int rc = await c.connect();
      expect(rc, 0);

      await c.sendText(fromUserId: 'u1', toUserId: 'u2', content: 'integration-udp-hi');
      await waitFor(
        () => received.any((IMMessage m) => m.textData == 'integration-udp-hi'),
        timeout: const Duration(seconds: 2),
      );
      expect(c.state, ConnectionState.connected);

      await c.releaseCore();
    });

    test('WebSocket: connect -> send text -> 收到 echo', () async {
      final HttpServer srv = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      srv.transform(WebSocketTransformer()).listen((WebSocket ws) {
        ws.listen((dynamic data) {
          // 收到什么就回什么(字符串 frame)
          if (data is String) {
            // 简单回送
            ws.add(data);
          }
        });
      });
      addTearDown(() => srv.close(force: true));

      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = srv.port;

      final WebSocketImClient c = WebSocketImClient();
      final List<IMMessage> received = <IMMessage>[];
      c.messageStream.listen(received.add);

      await c.initCore();
      final int rc = await c.connect();
      expect(rc, 0);
      expect(c.isConnected, isTrue);

      await c.sendText(fromUserId: 'u1', toUserId: 'u2', content: 'integration-ws-hi');
      await waitFor(
        () => received.isNotEmpty,
        timeout: const Duration(seconds: 2),
      );

      await c.releaseCore();
    });

    test('IMFactory: 按 type 字段创建不同传输的客户端', () async {
      // IMFactory 内部会校验 IP/Port,这里随便设置以通过校验
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = 12345;
      final TcpImClient t = IMFactory.create(ConnectionType.tcp) as TcpImClient;
      final UdpImClient u = IMFactory.create(ConnectionType.udp) as UdpImClient;
      final WebSocketImClient w =
          IMFactory.create(ConnectionType.websocket) as WebSocketImClient;
      expect(t, isA<TcpImClient>());
      expect(u, isA<UdpImClient>());
      expect(w, isA<WebSocketImClient>());
      await t.releaseCore();
      await u.releaseCore();
      await w.releaseCore();
    });

    test('状态机: 合法/非法转换被正确处理', () async {
      final TcpImClient c = TcpImClient();
      expect(c.state, ConnectionState.idle);
      // 还没有 connect 之前 sendLogin 应该被拦截
      final int rcNoConn = await c.sendLogin(userId: 'u', token: 't');
      expect(rcNoConn, isNot(0));
      await c.releaseCore();
    });

    test('TCP 断线重连: 服务端关闭后,autoReconnect 时尝试重连', () async {
      // 使用一个会主动关闭连接的 echo 服务
      final MockTcpServer srv = await MockTcpServer.start(
        onFrame: (List<int> data, MockTcpClient peer) async {
          // 不回任何东西
        },
      );
      addTearDown(srv.close);

      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = srv.port;
      IMConfig.autoReconnect = true;

      final TcpImClient c = TcpImClient();
      await c.initCore();
      await c.connect();
      expect(c.isConnected, isTrue);

      // 主动关闭服务端,触发 socket done
      await srv.killAll();
      await waitFor(() => !c.isConnected, timeout: const Duration(seconds: 1));
      expect(c.isConnected, isFalse);

      // 重新启动 server
      final MockTcpServer srv2 = await MockTcpServer.start(
        onFrame: (List<int> data, MockTcpClient peer) async {
          // 简单 echo
          await peer.send(data);
        },
      );
      IMConfig.serverPort = srv2.port;
      addTearDown(srv2.close);

      // 等待自动重连(指数退避: 2s, 4s, 8s ...),给足时间
      await waitFor(() => c.isConnected, timeout: const Duration(seconds: 6));
      expect(c.isConnected, isTrue);

      await c.releaseCore();
    });
    test('TCP: 服务端下发的 ack 把 fp 放在 dataContent 时仍能正确摘除队列', () async {
      // 真实 MobileIMSDK 服务端在收到对端的 PReceivedC 之后, 把 ack 投回原发送方时,
      // 顶层 fp 字段为 null, 原始指纹放在 dataContent (UTF-8 字符串). 客户端必须
      // 从 dataContent 解出 fp, 否则 QoS 队列会反复重传.
      final List<String> serverAcks = <String>[];
      final MockTcpServer srv = await MockTcpServer.start(
        onFrame: (List<int> data, MockTcpClient peer) async {
          final List<IMMessage> msgs = FrameParser().feed(data);
          for (final IMMessage m in msgs) {
            if (m.type == IMMessageType.fromClientTypeLogin) {
              final String resp = jsonEncode(<String, dynamic>{
                'code': 0,
                'user_id': m.fromUserId ?? '',
              });
              await peer.send(FrameCodec.encode(IMMessage(
                type: IMMessageType.fromServerTypeOfResponseLogin,
                data: utf8.encode(resp),
                fingerprint: 'fp-login',
              )));
            } else if (m.type == IMMessageType.fromClientTypeCommonData) {
              // 模拟对端: 用 type=4 (FROM_CLIENT_TYPE_OF_RECIEVED) 回送 ack,
              // fp=null, dataContent=原始 fp 字符串(对齐 MobileIMSDK 服务端行为)
              final String fp = m.fingerprint ?? '';
              serverAcks.add(fp);
              await peer.send(FrameCodec.encode(IMMessage(
                type: IMMessageType.fromClientTypeRecieved,
                data: utf8.encode(fp),
                fromUserId: m.toUserId,
                toUserId: m.fromUserId,
                fingerprint: null, // 关键: 服务端不下发顶层 fp
                qos: false,
              )));
            }
          }
        },
      );
      addTearDown(srv.close);

      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = srv.port;

      final TcpImClient c = TcpImClient();
      final List<String> ackedFp = <String>[];
      c.qosEvent = MessageQoSEvent(
        onAckReceived: (String fp) => ackedFp.add(fp),
      );
      await c.initCore();
      await c.connect();
      await c.sendLogin(userId: 'u1', token: 't1');
      await c.sendText(fromUserId: 'u1', toUserId: 'u2', content: 'qos-msg');
      // 给 QoS 摘除和 ticker 一点时间(摘除是同步的, 这里只 wait 一帧)
      await waitFor(() => ackedFp.isNotEmpty, timeout: const Duration(seconds: 1));
      expect(ackedFp, isNotEmpty,
          reason: '服务端把 fp 放在 dataContent 时, 客户端必须能正确解析并 ack');
      expect(ackedFp.length, 1);
      expect(ackedFp.first.length, 36, reason: '应为 UUID v4 36 字符串');
      await c.releaseCore();
    });
  });
}

// region ===== UDP echo helper =====

Future<RawDatagramSocket> bindUdpEcho() async {
  final RawDatagramSocket s = await RawDatagramSocket.bind(
    InternetAddress.loopbackIPv4,
    0,
  );
  s.listen((RawSocketEvent ev) {
    if (ev == RawSocketEvent.read) {
      final Datagram? dg = s.receive();
      if (dg != null) {
        s.send(dg.data, dg.address, dg.port);
      }
    }
  });
  return s;
}

// endregion

// region ===== Reused helpers (avoid duplicate defs with unit tests) =====

Future<bool> waitFor(
  bool Function() cond, {
  Duration timeout = const Duration(seconds: 2),
  Duration step = const Duration(milliseconds: 20),
}) async {
  final DateTime deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (cond()) return true;
    await Future<void>.delayed(step);
  }
  return cond();
}

// endregion
