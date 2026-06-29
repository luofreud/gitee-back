import 'package:dio/dio.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/models/im/im_conversation.dart';
import 'package:freud/models/im/im_message.dart';
import 'package:freud/utils/request_util.dart';

import '../../models/base/base_response.dart';
import '../../models/system/upload_response.dart';
import '../../models/user/userinfo.dart';

class ImMessageApi {
  /// 获取IM服务配置
  Future<Map<String, dynamic>?> getServerConfig() async {
    var res = await RequestUtil.getInstance().get("/imserver/server-config");
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => data as Map<String, dynamic>,
    );
    if (resJson.code != 200 || resJson.result == null) return null;
    return resJson.result?['data'] as Map<String, dynamic>?;
  }

  /// 分页查询当前用户会话列表
  Future<PageData<ImConversation>?> pageConversations(
    PageRequest req, {
    String? keyword,
  }) async {
    var data = req.toJson();
    if (keyword != null) data['keyword'] = keyword;
    var res = await RequestUtil.getInstance().post(
      "/imMessage/page",
      data: data,
    );
    if (res?.code != 200) return null;
    var resJson = PageResponse<ImConversation>.fromJson(
      res?.data,
      (data) => ImConversation.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 分页获取与指定用户的聊天记录
  Future<PageData<ImMessage>?> messageList(
    PageRequest req, {
    required String uid,
  }) async {
    var data = req.toJson();
    data['uid'] = uid;
    var res = await RequestUtil.getInstance().post(
      "/imMessage/messageList",
      data: data,
    );
    if (res?.code != 200) return null;
    var resJson = PageResponse<ImMessage>.fromJson(
      res?.data,
      (data) => ImMessage.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 通过UID获取用户头像、昵称、utype信息
  Future<Userinfo?> getUserInfo(String uid) async {
    var res = await RequestUtil.getInstance().get(
      "/imMessage/getUserInfo",
      params: {"uid": uid},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse<Userinfo>.fromJson(
      res?.data,
      (data) => Userinfo.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 文件上传
  Future<UploadResponse?> upload(
    String filePath, {
    String? filename,
    ProgressCallback? onSendProgress,
  }) async {
    var res = await RequestUtil.getInstance().upload(
      "/imMessage/uploadFile",
      FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: filename),
      }),
      onSendProgress: onSendProgress,
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse<UploadResponse>.fromJson(
      res?.data,
      (result) => UploadResponse.fromJson(result),
    );
    return resJson.result;
  }

  /// 获取语音通话房间token
  Future<Map<String, dynamic>?> getVoiceCallToken({
    String? channelName,
  }) async {
    var res = await RequestUtil.getInstance().get(
      "/imMessage/getVoiceCallToken",
      params: {
        if (channelName != null) "channelName": channelName,
      },
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => data as Map<String, dynamic>,
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }
}
