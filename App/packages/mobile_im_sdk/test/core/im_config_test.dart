import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

void main() {
  group('IMConfig', () {
    setUp(() => IMConfig.reset());
    tearDown(() => IMConfig.reset());

    test('register / isRegistered', () {
      expect(IMConfig.isRegistered, isFalse);
      IMConfig.register(appKey: 'k1');
      expect(IMConfig.appKey, 'k1');
      expect(IMConfig.isRegistered, isTrue);
    });

    test('validate 失败:未注册', () {
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = 7901;
      expect(IMConfig.validate(), ErrorCode.clientSdkNoInitialed);
    });

    test('validate 失败:服务端配置缺失', () {
      IMConfig.register(appKey: 'k');
      expect(IMConfig.validate(), ErrorCode.toServerNetInfoNotSetup);
    });

    test('validate 成功', () {
      IMConfig.register(appKey: 'k');
      IMConfig.serverIp = '127.0.0.1';
      IMConfig.serverPort = 7901;
      expect(IMConfig.validate(), 0);
    });

    test('reset 清空所有配置', () {
      IMConfig.register(appKey: 'k');
      IMConfig.serverIp = '1.2.3.4';
      IMConfig.serverPort = 1234;
      IMConfig.debug = true;
      IMConfig.reset();
      expect(IMConfig.appKey, isEmpty);
      expect(IMConfig.serverIp, isEmpty);
      expect(IMConfig.serverPort, 0);
      expect(IMConfig.debug, isFalse);
    });

    test('默认心跳敏感度 5s', () {
      IMConfig.reset();
      expect(IMConfig.senseMode, SenseMode.mode5S);
      expect(IMConfig.senseMode.millis, 5000);
    });

    test('SenseMode.millis 覆盖所有档位', () {
      expect(SenseMode.mode3S.millis, 3000);
      expect(SenseMode.mode10S.millis, 10000);
      expect(SenseMode.mode15S.millis, 15000);
      expect(SenseMode.mode30S.millis, 30000);
      expect(SenseMode.mode60S.millis, 60000);
      expect(SenseMode.mode120S.millis, 120000);
    });
  });
}
