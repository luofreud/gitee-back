import 'package:freud/models/base/page_request.dart';

class LiveRoomPageRequest extends PageRequest {
  final int? tid;
  final int? roomid;

  LiveRoomPageRequest({
    this.tid,
    this.roomid,
    super.page,
    super.pageSize,
    super.field,
    super.order,
    super.descStr,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['tid'] = this.tid;
    data['roomid'] = this.roomid;
    return data;
  }
}