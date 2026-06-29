import 'package:dio/dio.dart';
import 'package:freud/models/base/base_response.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/models/live/live_connect_record.dart';
import 'package:freud/models/live/live_room.dart';
import 'package:freud/models/live/live_room_page_request.dart';
import 'package:freud/models/system/upload_response.dart';
import 'package:freud/utils/request_util.dart';

class CounselorLiveApi {
  /// 老师端直播间列表
  /// [request] 分页请求参数
  /// 返回直播间分页列表
  Future<PageResponse<LiveRoom>?> getRoomList(
    LiveRoomPageRequest request,
  ) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/page",
      data: request.toJson(),
    );
    if (res?.code != 200) return null;
    var resJson = PageResponse.fromJson(
      res?.data,
      (data) => LiveRoom.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) {
      return resJson;
    }
    return null;
  }

  /// 创建直播间
  Future<int?> liveRoomAdd(LiveRoom liveRoom) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/add",
      data: liveRoom.toJson(),
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse<int?>.fromJson(
      res?.data,
      (result) => (result as num?)?.toInt(),
    );
    return resJson.result;
  }

  ///
  /// 上传文件
  Future<UploadResponse?> upload(
    String filePath, {
    String? filename,
    ProgressCallback? onSendProgress,
  }) async {
    var res = await RequestUtil.getInstance().upload(
      "/appXzTeachroom/uploadFile",
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

  /// 老师端 结束直播间
  /// [id] 直播间ID
  /// 返回是否成功关闭
  Future<bool> closeRoom(int id) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzTeachroom/close",
      params: {"id": id},
    );
    if (res?.code != 200) return false;
    var resJson = BaseResponse.fromJson(res?.data, (data) => data);
    return resJson.code == 200;
  }

  /// 获取直播间token
  Future<Map<String, dynamic>?> liveRoomToken(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/getRoomToken",
      data: {"id": id},
    );
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

  /// 查询房间等待连麦用户和连麦中用户列表
  /// [roomId] 房间ID
  /// 返回连麦记录列表
  Future<List<LiveConnectRecord>?> roomWaitImLog(int roomId) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzImlog/roomWaitImLog",
      data: {"roomid": roomId},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List<dynamic>)
          .map((item) => LiveConnectRecord.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 获取连麦记录详情
  /// [id] 连麦记录主键Id
  /// 返回连麦记录详情
  Future<LiveConnectRecord?> getImLogDetail(int id) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzImlog/detail",
      params: {"Id": id},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => LiveConnectRecord.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 更新连麦记录（同意、拒绝、开始、断开）
  /// [record] 连麦记录（传入 id + 需更新的字段）
  /// 返回是否成功
  Future<bool> updateImLog(LiveConnectRecord record) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzImlog/updateImLog",
      data: record.toJson(),
    );
    if (res?.code != 200) return false;
    return true;
  }
}
