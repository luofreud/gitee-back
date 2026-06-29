import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

void main() {
  group('ErrorCode', () {
    test('对齐 MobileIMSDK 原生错误码常量', () {
      expect(ErrorCode.commonCodeOk, 0);
      expect(ErrorCode.commonNoLogin, 1);
      expect(ErrorCode.commonUnknownError, 2);
      expect(ErrorCode.commonDataSendFailed, 3);
      expect(ErrorCode.commonInvalidProtocal, 4);

      expect(ErrorCode.brokenConnectToServer, 201);
      expect(ErrorCode.badConnectToServer, 202);
      expect(ErrorCode.clientSdkNoInitialed, 203);
      expect(ErrorCode.localNetworkNotWorking, 204);
      expect(ErrorCode.toServerNetInfoNotSetup, 205);

      expect(ErrorCode.responseForUnlogin, 301);
    });

    test('describe 已知码返回非空描述', () {
      expect(ErrorCode.describe(ErrorCode.commonCodeOk), isNotEmpty);
      expect(ErrorCode.describe(ErrorCode.brokenConnectToServer),
          contains('断开'));
      expect(ErrorCode.describe(ErrorCode.clientSdkNoInitialed),
          contains('初始化'));
    });

    test('describe 未知码返回通用占位', () {
      expect(ErrorCode.describe(99999), contains('99999'));
    });
  });
}
