class PageResponse<T> {
  int? code;
  String? type;
  String? message;
  PageData<T>? result;
  dynamic? extras;
  String? time;

  PageResponse({
    this.code,
    this.type,
    this.message,
    this.result,
    this.extras,
    this.time,
  });

  PageResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic json)? fromJsonResult,
  ]) {
    code = json['code'];
    type = json['type'];
    message = json['message'];
    result = fromJsonResult != null
        ? PageData.fromJson(json['result'], (result) => fromJsonResult(result))
        : json['result'];
    extras = json['extras'];
    time = json['time'];
  }

  Map<String, dynamic> toJson([Object Function(T? value)? toJsonResult]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    data['result'] = toJsonResult != null
        ? result?.toJson((e) => toJsonResult(e))
        : this.result;
    data['extras'] = this.extras;
    data['time'] = this.time;
    return data;
  }
}

class PageData<T> {
  PageData({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.items,
    required this.hasPrevPage,
    required this.hasNextPage,
  });

  int? page;
  int? pageSize;
  int? total;
  int? totalPages;
  List<T>? items;
  bool? hasPrevPage;
  bool? hasNextPage;

  PageData.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic json)? fromJsonResult,
  ]) {
    page = (json['page'] as num?)?.toInt();
    pageSize = (json['pageSize'] as num?)?.toInt();
    total = (json['total'] as num?)?.toInt();
    totalPages = (json['totalPages'] as num?)?.toInt();
    items = fromJsonResult != null
        ? (json['items'] as List<dynamic>)
              .map((e) => fromJsonResult(e))
              .toList()
        : json['items'];
    hasPrevPage = json['hasPrevPage'] as bool?;
    hasNextPage = json['hasNextPage'] as bool?;
  }

  Map<String, dynamic> toJson([Object Function(T? value)? toJsonResult]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['total'] = this.total;
    data['totalPages'] = this.totalPages;
    data['items'] = toJsonResult != null
        ? this.items?.map((e) => toJsonResult(e)).toList()
        : this.items;
    data['hasPrevPage'] = this.hasPrevPage;
    data['hasNextPage'] = this.hasNextPage;
    return data;
  }
}
