/// 简单 UUID v4 风格指纹生成器(对齐 MobileIMSDK iOS/Android
/// `Protocal.genFingerPrint()` 实现: UUID.randomUUID().toString()).
///
/// 不引入第三方依赖, 内部用 [Random.secure].
import 'dart:math';

class FingerprintGen {
  FingerprintGen._();

  static final Random _rand = Random.secure();

  /// 生成一个形如 `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx` 的 36 字符串,
  /// 严格符合 RFC 4122 UUID v4: 总长 36, 5 段 8-4-4-4-12.
  static String next() {
    // a/b/c/d 共同构成 128-bit 随机数: 8+4+4+12+4 bytes = 32 hex
    final int a = _rand.nextInt(0xFFFFFFFF);
    final int b = _rand.nextInt(0xFFFFFFFF);
    final int c = _rand.nextInt(0xFFFFFFFF);
    final int d = _rand.nextInt(0xFFFFFFFF);
    // 第 13 位固定为 '4' (UUID v4 标识), 第 17 位为 8/9/a/b
    final int hi4 = 0x4000 | (_rand.nextInt(0x1000));
    final int lo3 = 0x8000 | (_rand.nextInt(0x4000));

    String hex(int v, int w) {
      final String s = v.toRadixString(16);
      if (s.length >= w) return s.substring(s.length - w);
      return s.padLeft(w, '0');
    }

    final String s1 = hex(a, 8);
    final String s2 = hex(b, 4);
    final String s3 = hex(hi4, 4);
    final String s4 = hex(lo3, 4);
    // s5 = 12 chars: c 的高 32 位(8 字符) + d 的低 16 位(4 字符) 拼接成 12 字符
    final String s5 = hex(c, 8) + hex(d, 4);
    return '$s1-$s2-$s3-$s4-$s5';
  }
}
