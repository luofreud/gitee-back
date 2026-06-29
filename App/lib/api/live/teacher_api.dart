import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/models/user/teacher.dart';
import 'package:freud/utils/request_util.dart';

class TeacherApi {
  /// 用户端分页查询咨询师列表
  Future<PageData<Teacher>?> pageTeacher(
    PageRequest req, {
    Map<String, dynamic>? filters,
  }) async {
    var data = req.toJson();
    if (filters != null) data.addAll(filters);
    var res = await RequestUtil.getInstance().post(
      "/appXzTeacher/page",
      data: data,
    );
    if (res?.code != 200) return null;
    var resJson = PageResponse<Teacher>.fromJson(
      res?.data,
      (data) => Teacher.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 获取导师详情（按Id或Uid）
  Future<Teacher?> teacherDetail({int? id, int? uid}) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzTeacher/detail",
      params: {if (id != null) 'id': id, if (uid != null) 'uid': uid},
    );
    if (res?.code != 200 ||
        res?.data['result'] == null ||
        res?.data['result'].isEmpty) {
      return null;
    }
    return Teacher.fromJson(res?.data['result'] as Map<String, dynamic>);
  }
}
