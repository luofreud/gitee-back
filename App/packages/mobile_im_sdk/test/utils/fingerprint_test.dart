/// 单元测试: 验证 [FingerprintGen] 生成的指纹符合 UUID v4 格式 (36 字符串,
/// 第 13 位为 '4', 第 17 位为 8/9/a/b).
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

void main() {
  group('FingerprintGen', () {
    test('生成的指纹长度为 36 字符串', () {
      for (int i = 0; i < 50; i++) {
        final String fp = FingerprintGen.next();
        expect(fp.length, 36,
            reason: 'fp=$fp 长度应为 36, 实际为 ${fp.length}');
      }
    });

    test('生成的标准 UUID v4 格式: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx', () {
      final RegExp re = RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
      for (int i = 0; i < 50; i++) {
        final String fp = FingerprintGen.next();
        expect(re.hasMatch(fp), isTrue,
            reason: 'fp=$fp 不符合 UUID v4 格式');
      }
    });

    test('连续生成的指纹互不相同', () {
      final Set<String> set = <String>{};
      for (int i = 0; i < 200; i++) {
        final String fp = FingerprintGen.next();
        expect(set.contains(fp), isFalse,
            reason: '出现重复 fp=$fp (i=$i)');
        set.add(fp);
      }
    });
  });
}
