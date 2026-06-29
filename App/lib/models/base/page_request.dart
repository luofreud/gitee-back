///分页请求参数
class PageRequest {
  ///当前页码
  int? page;

  ///分页大小
  int? pageSize;

  ///排序字段
  String? field;

  ///排序方向
  String? order;

  ///降序排序
  String? descStr;

  PageRequest({
    this.page,
    this.pageSize,
    this.field,
    this.order,
    this.descStr = "desc",
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['field'] = this.field;
    data['order'] = this.order;
    data['descStr'] = this.descStr;
    return data;
  }
}
