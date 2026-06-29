import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

void main() {
  group('IMMessage', () {
    test('business 工厂构造文本消息(type=2)', () {
      final IMMessage m = IMMessage.business(
        fromUserId: 'u1',
        toUserId: 'u2',
        content: 'hello',
        qos: true,
        fingerprint: 'fp-1',
      );
      expect(m.type, 2);
      expect(m.textData, 'hello');
      expect(m.fromUserId, 'u1');
      expect(m.toUserId, 'u2');
      expect(m.qos, isTrue);
      expect(m.fingerprint, 'fp-1');
    });

    test('businessBinary 工厂构造二进制消息', () {
      final IMMessage m = IMMessage.businessBinary(
        fromUserId: 'u1',
        toUserId: 'u2',
        bytes: <int>[1, 2, 3, 4],
      );
      expect(m.data, <int>[1, 2, 3, 4]);
      expect(m.type, 2);
    });

    test('默认 timestamp 近似当前毫秒', () {
      final int before = DateTime.now().millisecondsSinceEpoch;
      final IMMessage m = IMMessage(type: 0, data: <int>[]);
      final int after = DateTime.now().millisecondsSinceEpoch;
      expect(m.timestamp, greaterThanOrEqualTo(before));
      expect(m.timestamp, lessThanOrEqualTo(after));
    });

    test('toString 不抛异常', () {
      final IMMessage m = IMMessage(type: 4, data: <int>[]);
      expect(m.toString(), contains('IMMessage'));
    });

    test('business 默认 qos=true 时自动生成 UUID v4 指纹', () {
      final IMMessage m = IMMessage.business(
        fromUserId: 'u1',
        toUserId: 'u2',
        content: 'hi',
      );
      expect(m.fingerprint, isNotNull);
      expect(m.fingerprint!.length, 36,
          reason: '服务端 QoS 要求 fp 是 UUID v4 36 字符串');
      expect(
          RegExp(
                  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
              .hasMatch(m.fingerprint!),
          isTrue);
    });

    test('business 连续生成的两条消息指纹互不相同', () {
      final IMMessage m1 = IMMessage.business(
          fromUserId: 'u', toUserId: 'v', content: 'a');
      final IMMessage m2 = IMMessage.business(
          fromUserId: 'u', toUserId: 'v', content: 'b');
      expect(m1.fingerprint, isNot(m2.fingerprint));
    });

    test('business qos=false 时不生成指纹', () {
      final IMMessage m = IMMessage.business(
        fromUserId: 'u',
        toUserId: 'v',
        content: 'hi',
        qos: false,
      );
      expect(m.fingerprint, anyOf(isNull, isEmpty));
    });
  });

  group('ConnectionType', () {
    test('name 正确映射', () {
      expect(ConnectionType.tcp.name, 'TCP');
      expect(ConnectionType.udp.name, 'UDP');
      expect(ConnectionType.websocket.name, 'WebSocket');
    });

    test('fromName 反向映射', () {
      expect(ConnectionTypeX.fromName('TCP'), ConnectionType.tcp);
      expect(ConnectionTypeX.fromName('UDP'), ConnectionType.udp);
      expect(ConnectionTypeX.fromName('WebSocket'), ConnectionType.websocket);
      expect(ConnectionTypeX.fromName('UNKNOWN'), ConnectionType.tcp);
    });
  });
}
