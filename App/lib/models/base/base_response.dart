class BaseResponse<T> {
  int? code;
  String? type;
  String? message;
  T? result;
  dynamic? extras;
  String? time;

  BaseResponse({
    this.code,
    this.type,
    this.message,
    this.result,
    this.extras,
    this.time,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic json)? fromJsonResult,
    T Function(dynamic json)? fromJsonExtras,
  ]) => BaseResponse(
    code: json['code'],
    type: json['type'],
    message: json['message'],
    result: fromJsonResult != null && json['result'] != null
        ? fromJsonResult(json['result'])
        : json['result'],
    extras: fromJsonExtras != null && json['extras'] != null
        ? fromJsonExtras(json['extras'])
        : json['extras'],
    time: json['time'],
  );

  Map<String, dynamic> toJson([
    Object Function(T? value)? toJsonResult,
    Object Function(T? value)? toJsonExtras,
  ]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    data['result'] = toJsonResult != null
        ? toJsonResult(this.result)
        : this.result;
    data['extras'] = toJsonExtras != null
        ? toJsonExtras(this.extras)
        : this.extras;
    data['time'] = this.time;
    return data;
  }
}
