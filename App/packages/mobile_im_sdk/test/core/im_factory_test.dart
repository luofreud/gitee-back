import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

void main() {
  group('IMFactory', () {
    setUp(() => IMConfig.reset());
    tearDown(() => IMConfig.reset());

    test('未注册时创建抛出 IMConfigException', () {
      expect(() => IMFactory.create(ConnectionType.tcp),
          throwsA(isA<IMConfigException>()));
    });

    test('IP/Port 缺失时创建抛出', () {
      IMConfig.register(appKey: 'k');
      try {
        IMFactory.create(ConnectionType.tcp);
        fail('应该抛出');
      } on IMConfigException catch (e) {
        expect(e.errorCode, ErrorCode.toServerNetInfoNotSetup);
      }
    });

    test('配置完整时返回对应类型客户端', () {
      IMConfig.register(appKey: 'k');
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = 7901;
      expect(IMFactory.create(ConnectionType.tcp), isA<TcpImClient>());
      expect(IMFactory.create(ConnectionType.udp), isA<UdpImClient>());
      expect(IMFactory.create(ConnectionType.websocket),
          isA<WebSocketImClient>());
    });
  });

  group('ChatBaseEvent 字段可为空', () {
    test('不传任何回调也不抛错', () {
      const ChatBaseEvent ev = ChatBaseEvent();
      expect(ev.onLoginResponse, isNull);
    });
  });
}
