/// 错误响应(对齐 MobileIMSDK `PErrorResponse`).
class PErrorResponse {
  final int errorCode;
  final String errorMsg;

  const PErrorResponse({
    required this.errorCode,
    required this.errorMsg,
  });

  factory PErrorResponse.fromJson(Map<String, dynamic> json) => PErrorResponse(
        errorCode: (json['errorCode'] as num?)?.toInt() ?? -1,
        errorMsg: (json['errorMsg'] as String?) ?? '',
      );
}
