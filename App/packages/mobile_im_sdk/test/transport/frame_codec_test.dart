import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';
import 'package:mobile_im_sdk/src/transport/frame_codec.dart';

void main() {
  group('FrameCodec.encode/decode', () {
    test('编码再解析结果一致', () {
      final IMMessage original = IMMessage(
        type: 4,
        data: utf8.encode('hello'),
        fromUserId: 'u1',
        toUserId: 'u2',
        fingerprint: 'fp-1',
        qos: true,
      );
      final Uint8List frame = FrameCodec.encode(original);
      expect(frame.length, greaterThan(4));
      final FrameParser parser = FrameParser();
      final List<IMMessage> out = parser.feed(frame);
      expect(out.length, 1);
      expect(out[0].type, 4);
      expect(out[0].textData, 'hello');
      expect(out[0].fromUserId, 'u1');
      expect(out[0].fingerprint, 'fp-1');
      expect(out[0].qos, isTrue);
    });

    test('空 userId/fingerprint 也能编码', () {
      final IMMessage m = IMMessage(type: 2, data: <int>[]);
      final Uint8List frame = FrameCodec.encode(m);
      final List<IMMessage> out = FrameParser().feed(frame);
      expect(out.length, 1);
      expect(out[0].type, 2);
      expect(out[0].fromUserId, isNull);
      expect(out[0].fingerprint, isNull);
    });

    test('半包粘包:一次喂半个 frame', () {
      final Uint8List frame = FrameCodec.encode(
        IMMessage(type: 4, data: utf8.encode('abc'), fromUserId: 'u'),
      );
      final FrameParser parser = FrameParser();
      final List<IMMessage> p1 = parser.feed(frame.sublist(0, 3));
      expect(p1, isEmpty);
      final List<IMMessage> p2 = parser.feed(frame.sublist(3));
      expect(p2.length, 1);
      expect(p2[0].textData, 'abc');
    });

    test('粘包:两个 frame 一次喂入', () {
      final Uint8List f1 = FrameCodec.encode(
        IMMessage(type: 4, data: utf8.encode('A')),
      );
      final Uint8List f2 = FrameCodec.encode(
        IMMessage(type: 4, data: utf8.encode('BB')),
      );
      final Uint8List combined = Uint8List(f1.length + f2.length)
        ..setRange(0, f1.length, f1)
        ..setRange(f1.length, f1.length + f2.length, f2);
      final List<IMMessage> out = FrameParser().feed(combined);
      expect(out.length, 2);
      expect(out[0].textData, 'A');
      expect(out[1].textData, 'BB');
    });

    test('非法 bodyLen 会触发 buffer 清理', () {
      final FrameParser parser = FrameParser();
      // 4 字节大端 bodyLen = 0x00FFFFFF(异常大)
      final List<int> fake = <int>[0x00, 0xFF, 0xFF, 0xFF, 0x00];
      final List<IMMessage> out = parser.feed(fake);
      expect(out, isEmpty);
    });

    test('超过 maxBodyLength 抛 StateError', () {
      FrameCodec.maxBodyLength = 10;
      final IMMessage m = IMMessage(
        type: 4,
        data: List<int>.filled(100, 0xAA),
      );
      expect(() => FrameCodec.encode(m), throwsA(isA<StateError>()));
      FrameCodec.maxBodyLength = 6 * 1024; // 恢复
    });

    test('超长 userId 编码后仍能正常解析', () {
      // JSON 帧协议不再限制 userId 长度, 仍然能正常编码/解析
      final String tooLong = List<String>.filled(300, 'a').join();
      final IMMessage m = IMMessage(
        type: 4,
        data: <int>[],
        fromUserId: tooLong,
      );
      final Uint8List frame = FrameCodec.encode(m);
      final List<IMMessage> out = FrameParser().feed(frame);
      expect(out.length, 1);
      expect(out[0].fromUserId, tooLong);
    });
  });
}
