/// 登录响应(对齐 MobileIMSDK `PLoginInfoResponse`).
class PLoginInfoResponse {
  final int code;
  final int firstLoginTime;

  const PLoginInfoResponse({
    required this.code,
    this.firstLoginTime = 0,
  });

  factory PLoginInfoResponse.fromJson(Map<String, dynamic> json) =>
      PLoginInfoResponse(
        code: (json['code'] as num?)?.toInt() ?? -1,
        firstLoginTime: (json['firstLoginTime'] as num?)?.toInt() ?? 0,
      );
}
