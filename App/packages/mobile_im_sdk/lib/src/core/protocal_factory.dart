import 'dart:convert';

import 'im_message.dart';
import 'p_error_response.dart';
import 'p_kickout_info.dart';
import 'p_login_info.dart';
import 'p_login_info_response.dart';

/// 协议工厂(对齐 MobileIMSDK `ProtocalFactory`).
///
/// 集中管理所有协议对象的创建与解析,消除散落在各 client 中的重复代码.
class ProtocalFactory {
  ProtocalFactory._();

  // region ===== 创建协议 =====

  /// 创建登录请求.
  static IMMessage createPLoginInfo(PLoginInfo info) => IMMessage(
        type: 0,
        data: utf8.encode(jsonEncode(info.toJson())),
        fromUserId: info.loginUserId,
        qos: false,
        bridge: true,
      );

  /// 创建登出请求.
  static IMMessage createPLoginoutInfo(String userId) => IMMessage(
        type: 3,
        data: utf8.encode(''),
        fromUserId: userId,
        qos: false,
      );

  /// 创建心跳包.
  static IMMessage createPKeepAlive(String? fromUserId) => IMMessage(
        type: 1,
        data: utf8.encode(''),
        fromUserId: fromUserId,
        qos: false,
      );

  /// 创建业务数据.
  static IMMessage createCommonData({
    required String content,
    required String fromUserId,
    required String toUserId,
    bool qos = true,
    int typeu = -1,
    String? fingerprint,
  }) =>
      IMMessage.business(
        fromUserId: fromUserId,
        toUserId: toUserId,
        content: content,
        qos: qos,
        typeu: typeu,
        fingerprint: fingerprint,
      );

  /// 创建二进制业务数据.
  static IMMessage createCommonBinaryData({
    required List<int> bytes,
    required String fromUserId,
    required String toUserId,
    bool qos = true,
    int typeu = -1,
    String? fingerprint,
  }) =>
      IMMessage.businessBinary(
        fromUserId: fromUserId,
        toUserId: toUserId,
        bytes: bytes,
        qos: qos,
        typeu: typeu,
        fingerprint: fingerprint,
      );

  /// 创建收到的确认(ack).
  static IMMessage createRecivedBack(
          {required String fromUserId, required String fingerprint}) =>
      IMMessage(
        type: 4,
        data: utf8.encode(''),
        fromUserId: fromUserId,
        fingerprint: fingerprint,
        qos: false,
      );

  /// 创建被踢通知.
  static IMMessage createPKickout({
    required String toUserId,
    required int code,
    required String reason,
  }) =>
      IMMessage(
        type: 54,
        data: utf8.encode(jsonEncode(<String, dynamic>{
          'code': code,
          'reason': reason,
        })),
        toUserId: toUserId,
        qos: false,
      );

  // endregion

  // region ===== 解析协议 =====

  /// 解析登录响应.
  static PLoginInfoResponse? parsePLoginInfoResponse(String dataContent) {
    final String text = dataContent.trim();
    if (text.isEmpty || !(text.startsWith('{') || text.startsWith('['))) {
      return null;
    }
    try {
      final dynamic parsed = jsonDecode(text);
      if (parsed is Map<String, dynamic>) {
        return PLoginInfoResponse.fromJson(parsed);
      }
    } catch (_) {}
    return null;
  }

  /// 解析错误响应.
  static PErrorResponse? parsePErrorResponse(String dataContent) {
    final String text = dataContent.trim();
    if (text.isEmpty || !text.startsWith('{')) return null;
    try {
      final dynamic parsed = jsonDecode(text);
      if (parsed is Map<String, dynamic>) {
        return PErrorResponse.fromJson(parsed);
      }
    } catch (_) {}
    return null;
  }

  /// 解析被踢信息.
  static PKickoutInfo? parsePKickoutInfo(String dataContent) {
    final String text = dataContent.trim();
    if (text.isEmpty || !text.startsWith('{')) return null;
    try {
      final dynamic parsed = jsonDecode(text);
      if (parsed is Map<String, dynamic>) {
        return PKickoutInfo.fromJson(parsed);
      }
    } catch (_) {}
    return null;
  }

  /// 提取 ack 指纹(dataContent 或 fp 字段).
  static String? extractAckFingerprint(IMMessage m) {
    if (m.fingerprint?.isNotEmpty == true) return m.fingerprint;
    return (m.data.isNotEmpty) ? utf8.decode(m.data, allowMalformed: true) : null;
  }

  // endregion
}
