import 'package:freud/models/base/base_response.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/models/live/live_connect_record.dart';
import 'package:freud/utils/request_util.dart';

import '../../models/live/live_room.dart';
import '../../models/live/live_room_page_request.dart';
import '../../models/user/userinfo.dart';

class LiveApi {
  /// 获取直播间Token
  /// [roomId] 直播间ID
  /// 返回直播间Token信息
  Future<Map<String, dynamic>?> liveRoomToken(
    String roomId, {
    String? type,
  }) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/getRoomToken",
      data: {"id": roomId},
      queryParameters: {"type": type},
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

  /// 获取直播间列表
  /// [request] 分页请求参数
  /// 返回直播间分页列表
  Future<PageResponse<LiveRoom>?> getLiveRoomList(
    LiveRoomPageRequest request,
  ) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/userPage",
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

  /// 获取推荐直播间列表
  /// [request] 分页请求参数
  /// 返回推荐直播间分页列表
  Future<PageResponse<LiveRoom>?> getTopLiveRoomList(
    LiveRoomPageRequest request,
  ) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/userTopPage",
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

  /// 用户第一次进入直播间
  /// [roomid] 直播间ID
  /// 返回直播间详情信息
  Future<List<Userinfo>?> firstInRoom(int roomid) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/firstInRoom",
      data: {"roomid": roomid},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List<dynamic>)
          .map((item) => Userinfo.fromJson(item))
          .toList(),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 用户退出直播间
  /// [roomid] 直播间ID
  /// 返回是否成功退出
  Future<bool> userOutRoom(int roomid) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/userOutRoom",
      data: {"roomid": roomid},
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 刷新直播间数据
  /// [roomid] 直播间ID
  /// 返回直播间最新数据
  Future<List<Userinfo>?> refreshRoom(int roomid) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/refreshRoom",
      data: {"roomid": roomid},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List<dynamic>)
          .map((item) => Userinfo.fromJson(item))
          .toList(),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 导师连麦确认
  /// [id] 直播间ID
  /// [itype] 连麦类型 0：普通连麦，1：1v1连麦，2：及时通话
  /// 返回连麦记录 + Token信息
  Future<BaseResponse<LiveConnectRecord>?> teacherConnectUser(
    int roomId,
    int itype,
  ) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/teacherConnectUser",
      data: {"roomId": roomId, "itype": itype},
    );
    if (res?.code != 200) return BaseResponse.fromJson(res?.data);
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => LiveConnectRecord.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) {
      return resJson;
    }
    return resJson;
  }

  /// 获取导师直播间详情
  /// [id] 直播间主键ID
  /// 返回直播间详情
  Future<LiveRoom?> getRoomDetail(int id) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzTeachroom/detail",
      params: {"Id": id},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => LiveRoom.fromJson(data as Map<String, dynamic>),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 查询房间当前连麦用户信息
  /// [roomId] 房间ID
  /// 返回连麦记录列表
  Future<LiveConnectRecord?> getRoomIm(int roomId) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzImlog/roomWaitImLog",
      data: {"roomid": roomId, "state": 1},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List<dynamic>)
          .map(
            (item) => LiveConnectRecord.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
    if (resJson.code == 200 &&
        resJson.result != null &&
        resJson.result!.isNotEmpty) {
      return resJson.result![0];
    }
    return null;
  }

  /// 用户点赞后增加直播间点赞数量
  /// [id] 直播间ID
  /// [likenum] 点赞数量
  /// 返回当前点赞总数
  Future<int?> addLikenum(int id, int likenum) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/addLikenum",
      data: {"id": id, "likenum": likenum},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as num?)?.toInt(),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 更新用户连麦时长
  /// [id] 连麦申请记录id
  /// 返回结果值：>=0 正常，-1 星币不足
  Future<int?> updateImTime(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTeachroom/updateImTime",
      data: {"id": id},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as num?)?.toInt(),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }
}
