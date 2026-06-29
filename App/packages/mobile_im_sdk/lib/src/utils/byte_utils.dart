import 'dart:convert' as convert;
import 'dart:typed_data';

/// 字节流工具.
class ByteUtils {
  ByteUtils._();

  /// 把字符串编码为 UTF-8 字节.
  static Uint8List utf8(String s) =>
      Uint8List.fromList(convert.utf8.encode(s));

  /// 兼容旧代码:把字符串转成 `List<int>` 形式的 UTF-8 字节.
  static List<int> utf8Bytes(String s) => convert.utf8.encode(s);

  /// 字节流转字符串(UTF-8,容错).
  static String decodeUtf8(List<int> bytes, {bool allowMalformed = true}) {
    return convert.utf8.decode(bytes, allowMalformed: allowMalformed);
  }
}
