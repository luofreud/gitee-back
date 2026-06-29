import 'dart:convert';
import 'dart:typed_data';

import '../core/im_message.dart';
import '../utils/im_logger.dart';

/// TCP/UDP 帧编解码器(对齐 MobileIMSDK `TCPFrameCodec` + `Protocal.toBytes`).
///
/// 协议格式:
/// ```
/// +--------+--------+
/// | 4 byte |   N    |
/// +--------+--------+
/// | length |  body  |
/// +--------+--------+
/// ```
///
/// - `length`: 4 字节大端,body 字节数(上限 6KB,与原 SDK 一致)
/// - `body`:   UTF-8 编码的 JSON 字符串,内容是 `Protocal` 对象的字段集合
///
/// WebSocket 不走此编解码器(直接发 JSON 文本帧).
class FrameCodec {
  /// 单帧 body 最大长度,默认 6 * 1024 字节.
  static int maxBodyLength = 6 * 1024;

  /// 把 [msg] 编码为可发送字节流(4 字节大端长度 + UTF-8 JSON).
  static Uint8List encode(IMMessage msg) {
    final String json = jsonEncode(msg.toProtocalJson());
    final List<int> body = utf8.encode(json);
    if (body.length > maxBodyLength) {
      throw StateError('单帧 body 超过 maxBodyLength=$maxBodyLength,实际 ${body.length}');
    }
    final ByteData header = ByteData(4);
    header.setUint32(0, body.length, Endian.big);

    final Uint8List out = Uint8List(4 + body.length);
    out.setRange(0, 4, header.buffer.asUint8List());
    out.setRange(4, 4 + body.length, body);
    return out;
  }

  /// 把 [json] 字符串(纯 body 部分)编码为可发送字节流.
  /// 主要用于直接发送服务端约定的子对象 JSON(例如 PLoginInfo)。
  static Uint8List encodeRawJson(String json) {
    final List<int> body = utf8.encode(json);
    if (body.length > maxBodyLength) {
      throw StateError('单帧 body 超过 maxBodyLength=$maxBodyLength,实际 ${body.length}');
    }
    final ByteData header = ByteData(4);
    header.setUint32(0, body.length, Endian.big);
    final Uint8List out = Uint8List(4 + body.length);
    out.setRange(0, 4, header.buffer.asUint8List());
    out.setRange(4, 4 + body.length, body);
    return out;
  }
}

/// TCP/UDP 粘包/拆包解析器(状态机).
///
/// 调用方每次喂入新到的字节,内部累积,返回已解析的完整消息列表.
/// 半包会保留在内部,下次 [feed] 续上.
class FrameParser {
  final List<int> _buffer = <int>[];
  final List<IMMessage> _out = <IMMessage>[];

  void reset() {
    _buffer.clear();
    _out.clear();
  }

  /// 喂入新字节,返回本次解析出的完整消息.
  ///
  /// 每次调用只返回 *本次新增* 的消息(已解析的不重复).
  List<IMMessage> feed(List<int> chunk) {
    _out.clear();
    _buffer.addAll(chunk);
    while (_tryParse()) {}
    return List<IMMessage>.unmodifiable(_out);
  }

  bool _tryParse() {
    if (_buffer.length < 4) return false;
    final ByteData bd = ByteData.sublistView(
      Uint8List.fromList(_buffer),
      0,
      4,
    );
    final int bodyLen = bd.getUint32(0, Endian.big);
    if (bodyLen < 2 || bodyLen > FrameCodec.maxBodyLength) {
      IMLogger.w(
          'FrameParser', '非法 bodyLen=$bodyLen,丢弃 ${_buffer.length} 字节');
      _buffer.clear();
      return false;
    }
    if (_buffer.length < 4 + bodyLen) return false; // 半包,继续等

    final int totalLen = 4 + bodyLen;
    final String json =
        utf8.decode(_buffer.sublist(4, totalLen), allowMalformed: true);

    try {
      final dynamic decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) {
        _out.add(IMMessage.fromProtocalJson(decoded));
      } else {
        IMLogger.w('FrameParser', '顶层不是 JSON 对象: $json');
      }
    } catch (e) {
      IMLogger.w('FrameParser', 'JSON 解析失败: $e, body=$json');
    }
    _buffer.removeRange(0, totalLen);
    return true;
  }
}
