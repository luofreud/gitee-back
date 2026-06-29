import 'package:freud/models/base/base_response.dart';

import '../../utils/request_util.dart';

class CheckApi {
  /// 用户签到
  Future<bool> checkSubmit() async {
    var res = await RequestUtil.getInstance().post("/appXzCheck/useCheck");
    if (res?.code != 200) return false;
    return true;
  }

  /// 获取签到记录
  Future<List<dynamic>?> checkRecord() async {
    var res = await RequestUtil.getInstance().get("/appXzCheck/useCheck");
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List<dynamic>),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 获取任务列表
  Future<Map<String, dynamic>?> taskList() async {
    var res = await RequestUtil.getInstance().get("/appXzCheck/useTask");
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as Map<String, dynamic>),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }
}
