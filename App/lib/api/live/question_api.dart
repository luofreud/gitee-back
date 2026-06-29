import 'package:freud/models/base/base_response.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/models/live/xz_question.dart';
import 'package:freud/utils/request_util.dart';

/// 用户问答 API
class QuestionApi {
  /// 分页查询用户问答
  Future<PageData<XzQuestion>?> questionPage(
    PageRequest req, {
    Map<String, dynamic>? data,
  }) async {
    var requestData = req.toJson();
    if (data != null) requestData.addAll(data);
    var res = await RequestUtil.getInstance().post(
      "/appXzQuestion/page",
      data: requestData,
    );
    if (res?.code != 200) return null;
    var resJson = PageResponse<XzQuestion>.fromJson(
      res?.data,
      (data) => XzQuestion.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 获取用户问答详情
  Future<XzQuestion?> questionDetail(int id) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzQuestion/detail",
      params: {"Id": id},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse<XzQuestion>.fromJson(
      res?.data,
      (data) => XzQuestion.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 新增用户问答，返回新记录
  Future<XzQuestion?> questionAdd(Map<String, dynamic> data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzQuestion/add",
      data: data,
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse<XzQuestion>.fromJson(
      res?.data,
      (data) => XzQuestion.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 删除用户问答
  Future<bool> questionDelete(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzQuestion/delete",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }
}
