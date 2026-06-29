import 'dart:convert';

import '../utils/fingerprint.dart';

/// IM 消息包装(对齐 MobileIMSDK `Protocal`).
///
/// 表示一条客户端↔服务端之间传输的消息.
/// 协议在 TCP/UDP 下采用 [FrameCodec] 编码的 JSON 文本帧;在 WebSocket 下
/// 直接以 JSON 字符串作为消息正文.
class IMMessage {
  /// 协议类型,对应 MobileIMSDK 的 `ProtocalType`.
  /// 客户端→服务端: 0 登录, 1 心跳, 2 业务数据, 3 登出, 4 收到确认(ack), 5 echo
  /// 服务端→客户端: 50 登录响应, 51 心跳响应, 52 错误响应, 53 echo响应, 54 被踢
  final int type;

  /// 消息内容(载荷).统一以字节存储,业务层用 [textData] 取 UTF-8 字符串.
  ///
  /// - 登录/登出/心跳: 通常为空 JSON `{}` 或业务 JSON
  /// - 业务数据: 消息文本 UTF-8 字节
  /// - 登录响应/错误响应/被踢: 服务端下发的子对象 JSON 字节
  final List<int> data;

  /// 消息指纹 ID(对应 Protocal.fp,用于 QoS 去重/确认).
  final String? fingerprint;

  /// 发送方 userId(对应 Protocal.from).
  final String? fromUserId;

  /// 接收方 userId(对应 Protocal.to).
  final String? toUserId;

  /// QoS 标记: true 时等待 ack,失败重传.
  final bool qos;

  /// 时间戳(毫秒,对应 Protocal.sm,默认 -1 表示由服务端填充).
  final int timestamp;

  /// 是否桥接模式(对应 Protocal.bridge,默认 false).
  final bool bridge;

  /// 用户自定义协议类型(对应 Protocal.typeu,默认 -1).
  final int typeu;

  IMMessage({
    required this.type,
    required this.data,
    this.fingerprint,
    this.fromUserId,
    this.toUserId,
    this.qos = false,
    this.bridge = false,
    this.typeu = -1,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  /// 把 data 转成 UTF-8 字符串(便于调试与文本业务).
  String get textData {
    return utf8.decode(data, allowMalformed: true);
  }

  /// 用 [content] 构造一条业务文本消息(type=2,FROM_CLIENT_TYPE_OF_COMMON$DATA).
  ///
  /// 若未传 [fingerprint], 会自动生成 UUID 指纹, 对齐 MobileIMSDK
  /// `Protocal.genFingerPrint()` —— 指纹非空是服务端 QoS 正常转发的关键.
  factory IMMessage.business({
    required String fromUserId,
    required String toUserId,
    required String content,
    bool qos = true,
    String? fingerprint,
    int typeu = -1,
  }) {
    return IMMessage(
      type: 2,
      data: utf8.encode(content),
      fromUserId: fromUserId,
      toUserId: toUserId,
      qos: qos,
      fingerprint: fingerprint ?? (qos ? FingerprintGen.next() : null),
      typeu: typeu,
    );
  }

  /// 用 [bytes] 构造一条业务二进制消息.
  factory IMMessage.businessBinary({
    required String fromUserId,
    required String toUserId,
    required List<int> bytes,
    bool qos = true,
    String? fingerprint,
    int typeu = -1,
  }) {
    return IMMessage(
      type: 2,
      data: bytes,
      fromUserId: fromUserId,
      toUserId: toUserId,
      qos: qos,
      fingerprint: fingerprint ?? (qos ? FingerprintGen.next() : null),
      typeu: typeu,
    );
  }

  /// 序列化为 MobileIMSDK `Protocal` 兼容的 JSON Map.
  ///
  /// 字段名与顺序对齐 Protocal.toBytes() 输出;默认值不会被 jsonEncode 过滤,
  /// 原因:Gson 序列化时会输出所有字段(包括 false / 0 / -1),为保证
  /// 服务端解析时字段类型一致,这里手工构造 Map.
  Map<String, dynamic> toProtocalJson() {
    return <String, dynamic>{
      'bridge': bridge,
      'type': type,
      'dataContent': utf8.decode(data, allowMalformed: true),
      'from': fromUserId ?? '-1',
      'to': toUserId ?? '-1',
      'fp': fingerprint ?? '',
      'QoS': qos,
      'typeu': typeu,
      'sm': timestamp,
    };
  }

  /// 从 MobileIMSDK `Protocal` JSON 反序列化为 [IMMessage].
  ///
  /// 兼容字段缺失(部分老版本 SDK 不下发 bridge/sm)。
  factory IMMessage.fromProtocalJson(Map<String, dynamic> json) {
    final dynamic dc = json['dataContent'];
    final List<int> dataBytes = dc == null
        ? <int>[]
        : utf8.encode(dc.toString());
    return IMMessage(
      type: (json['type'] as num?)?.toInt() ?? 0,
      data: dataBytes,
      fingerprint: (json['fp'] as String?)?.isEmpty == true
          ? null
          : json['fp'] as String?,
      fromUserId: (json['from'] as String?) == '-1'
          ? null
          : json['from'] as String?,
      toUserId: (json['to'] as String?) == '-1'
          ? null
          : json['to'] as String?,
      qos: json['QoS'] as bool? ?? false,
      bridge: json['bridge'] as bool? ?? false,
      typeu: (json['typeu'] as num?)?.toInt() ?? -1,
      timestamp: (json['sm'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// 克隆一条消息(字段值拷贝).
  IMMessage clone() => IMMessage(
        type: type,
        data: List<int>.of(data),
        fingerprint: fingerprint,
        fromUserId: fromUserId,
        toUserId: toUserId,
        qos: qos,
        bridge: bridge,
        typeu: typeu,
        timestamp: timestamp,
      );

  @override
  String toString() {
    return 'IMMessage{type: $type, from: $fromUserId, to: $toUserId, '
        'fp: $fingerprint, qos: $qos, dataLen: ${data.length}}';
  }
}
