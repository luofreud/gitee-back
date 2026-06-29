/// 踢下线信息(对齐 MobileIMSDK `PKickoutInfo`).
class PKickoutInfo {
  final int code;
  final String reason;

  static const int kickoutForDuplicateLogin = 1;
  static const int kickoutForAdmin = 2;

  const PKickoutInfo({required this.code, required this.reason});

  factory PKickoutInfo.fromJson(Map<String, dynamic> json) => PKickoutInfo(
        code: (json['code'] as num?)?.toInt() ?? 0,
        reason: (json['reason'] as String?) ?? '',
      );
}
