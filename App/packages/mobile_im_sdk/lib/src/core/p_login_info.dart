/// 登录信息(对齐 MobileIMSDK `PLoginInfo`).
class PLoginInfo {
  final String loginUserId;
  final String loginToken;
  final String? extra;
  final int firstLoginTime;

  const PLoginInfo({
    required this.loginUserId,
    required this.loginToken,
    this.extra,
    this.firstLoginTime = 0,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'loginUserId': loginUserId,
        'loginToken': loginToken,
        'loginExtra': extra,
      };

  factory PLoginInfo.fromJson(Map<String, dynamic> json) => PLoginInfo(
        loginUserId: (json['loginUserId'] as String?) ?? '',
        loginToken: (json['loginToken'] as String?) ?? '',
        extra: json['loginExtra'] as String?,
        firstLoginTime: (json['firstLoginTime'] as num?)?.toInt() ?? 0,
      );
}
