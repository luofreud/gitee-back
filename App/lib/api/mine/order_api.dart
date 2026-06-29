import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/models/live/live_connect_record.dart';
import 'package:freud/utils/request_util.dart';

class OrderApi {
  Future<PageData<LiveConnectRecord>?> imlogPage(
    PageRequest req, {
    Map<String, dynamic>? data,
  }) async {
    var requestData = req.toJson();
    if (data != null) requestData.addAll(data);
    var res = await RequestUtil.getInstance().post(
      "/appXzImlog/page",
      data: requestData,
    );
    if (res?.code != 200) return null;
    var resJson = PageResponse<LiveConnectRecord>.fromJson(
      res?.data,
      (data) => LiveConnectRecord.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  Future<bool> imlogDelete(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzImlog/delete",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }
}
