import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

void main() {
  group('ByteUtils', () {
    test('utf8 / decodeUtf8 往返', () {
      final Uint8List b = ByteUtils.utf8('你好,Flutter');
      expect(ByteUtils.decodeUtf8(b), '你好,Flutter');
    });

    test('utf8Bytes 返回 List<int>', () {
      expect(ByteUtils.utf8Bytes('hi'), <int>[0x68, 0x69]);
    });

    test('utf8 中文字符正确编码为 3 字节/字', () {
      // '你' = E4 BD A0
      expect(ByteUtils.utf8Bytes('你'), <int>[0xE4, 0xBD, 0xA0]);
    });
  });

  group('IMLogger', () {
    test('setLogger 可注入自定义', () {
      final List<String> logs = <String>[];
      IMLogger.setLogger(_ListLogger(logs));
      IMLogger.i('TAG', 'hello');
      expect(logs, contains(contains('hello')));
      IMLogger.reset();
    });
  });
}

class _ListLogger implements ILogger {
  final List<String> sink;
  _ListLogger(this.sink);
  @override
  void d(String tag, String message) => sink.add('D $tag $message');
  @override
  void i(String tag, String message) => sink.add('I $tag $message');
  @override
  void w(String tag, String message, [Object? error, StackTrace? st]) =>
      sink.add('W $tag $message');
  @override
  void e(String tag, String message, [Object? error, StackTrace? st]) =>
      sink.add('E $tag $message');
}
