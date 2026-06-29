import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

/// 启动一个 UDP 回声 server:把收到的 datagram 字节回送.
Future<RawDatagramSocket> _startUdpEcho(void Function(String) log) async {
  final RawDatagramSocket s = await RawDatagramSocket.bind(
    InternetAddress.loopbackIPv4,
    0,
    reuseAddress: true,
  );
  s.broadcastEnabled = true;
  log('udp echo bound on ${s.port}');
  s.listen((RawSocketEvent e) {
    if (e == RawSocketEvent.read) {
      final Datagram? dg = s.receive();
      if (dg != null) {
        s.send(dg.data, dg.address, dg.port);
      }
    }
  });
  return s;
}

void main() {
  group('UdpImClient 集成', () {
    late RawDatagramSocket echo;
    setUp(() async {
      IMConfig.reset();
      IMConfig.register(appKey: 'k');
      echo = await _startUdpEcho((String m) {/* noop */});
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = echo.port;
      IMConfig.autoReconnect = false;
    });
    tearDown(() async {
      echo.close();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });

    test('connect 成功, state=connected', () async {
      final UdpImClient c = UdpImClient();
      await c.initCore();
      final int rc = await c.connect();
      expect(rc, 0);
      expect(c.state, ConnectionState.connected);
      await c.disconnect();
      await c.releaseCore();
    });

    test('sendMessage 成功', () async {
      final UdpImClient c = UdpImClient();
      await c.initCore();
      await c.connect();
      final int rc = await c.sendText(
        fromUserId: 'u',
        toUserId: 'v',
        content: 'udp-hi',
      );
      expect(rc, 0);
      await c.disconnect();
      await c.releaseCore();
    });

    test('收到回声后 messageStream 有数据', () async {
      final UdpImClient c = UdpImClient();
      final List<IMMessage> recv = <IMMessage>[];
      await c.initCore();
      await c.connect();
      c.messageStream.listen(recv.add);
      await c.sendText(
        fromUserId: 'u',
        toUserId: 'v',
        content: 'echo-please',
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(
          recv.where((IMMessage m) => m.textData == 'echo-please').length,
          greaterThanOrEqualTo(1));
      await c.disconnect();
      await c.releaseCore();
    });

    test('sendBroadcast 不抛异常', () async {
      final UdpImClient c = UdpImClient();
      await c.initCore();
      await c.connect();
      final int rc = await c.sendBroadcast(
        IMMessage.business(
          fromUserId: 'u',
          toUserId: 'ALL',
          content: 'b',
          qos: false,
        ),
      );
      expect(rc, 0);
      await c.disconnect();
      await c.releaseCore();
    });

    test('joinMulticast/leaveMulticast 不抛异常', () async {
      final UdpImClient c = UdpImClient();
      await c.initCore();
      await c.connect();
      c.joinMulticast('224.0.0.1');
      c.leaveMulticast('224.0.0.1');
      await c.disconnect();
      await c.releaseCore();
    });
  });
}
