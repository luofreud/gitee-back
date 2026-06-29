import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/live/live_connect_record.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/widgets/live/agora_live.dart';
import 'package:get/get.dart';

import '../../models/live/live_room.dart';
import '../../models/user/userinfo.dart';

class LiveRoomController extends GetxController {
  late AgoraLive agoraLive = AgoraLive();

  final textMessage = ''.obs;

  final liveMessageList = <String>[].obs;
  late ScrollController messageScrollController;

  final liveApi = LiveApi();

  final userService = Get.find<UserService>();
  String roomId = "";
  final pageLoading = false.obs;
  Rx<LiveRoom?> liveRoomDetail = Rx<LiveRoom?>(null);
  List<Userinfo> liveUserList = <Userinfo>[].obs;
  bool miniLiveRoom = false;
  Timer? _timer;
  final userApi = UserApi();
  RxInt isTeacherSubscribed = 0.obs;

  //用户当前的连麦申请
  LiveConnectRecord? currentConnectRecord;
  Timer? _connectTimer;
  Timer? _likeDebounceTimer; // 点赞防抖定时器
  RxInt connectElapsedSeconds = 0.obs;
  RxDouble connectCost = 0.0.obs;
  int _pendingLikes = 0; // 暂存的点赞数
  String connectTypeText = '普通连麦';

  // 直播间当前连麦信息
  Rx<LiveConnectRecord?> roomCurrentConnect = Rx<LiveConnectRecord?>(null);

  @override
  void onInit() {
    super.onInit();
    roomId = Get.arguments["roomId"];
    messageScrollController = ScrollController();
    miniLiveRoom = false;
    initData();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _connectTimer?.cancel();
    _likeDebounceTimer?.cancel();
    messageScrollController.dispose();
    if (miniLiveRoom == false) {
      leaveLiveRoom();
    }
    super.onClose();
  }

  initData() async {
    pageLoading.value = true;
    await getLiveRoomInfo();
    await initLiveRoom();
    pageLoading.value = false;
    //_startUserPolling();
    getRoomCurrentIm();
  }

  /// 定时刷新用户列表
  /// 同时可以通知后台前台一致在线，如果前台掉线，后台会自动将用户踢出房间
  void _startUserPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      getLiveRoomUsers();
    });
  }

  /// 获取直播间信息
  getLiveRoomInfo() async {
    var res = await liveApi.getRoomDetail(int.parse(roomId));
    if (res == null) {
      ToastUtil.info('获取直播间信息失败');
      return;
    }
    liveRoomDetail.value = res;
    isTeacherSubscribed.value = liveRoomDetail.value?.teacher?.isSubscribe ?? 0;
    if (res.content != null && res.content!.isNotEmpty) {
      messageAdd(res.content!);
    }
    var users = await liveApi.firstInRoom(liveRoomDetail.value!.roomid ?? 0);
    liveUserList.addAll(users!);
  }

  /// 获取直播间用户列表
  getLiveRoomUsers() async {
    var users = await liveApi.refreshRoom(liveRoomDetail.value!.roomid ?? 0);
    if (users == null) return;
    liveUserList.clear();
    liveUserList.addAll(users);
  }

  /// 获取当前直播间连麦信息
  getRoomCurrentIm() async {
    final res = await liveApi.getRoomIm(int.parse(roomId));
    roomCurrentConnect.value = res;
  }

  /// 初始化直播间
  /// 加入rtc频道和rtm频道
  initLiveRoom() async {
    var tokenRes = await liveApi.liveRoomToken(roomId);
    if (tokenRes == null) {
      ToastUtil.info('进入直播间失败');
      return;
    }
    String token = tokenRes["token"];
    String appId = tokenRes["appid"];
    String channelName = tokenRes["channelName"];
    try {
      agoraLive = await agoraLive.init(
        appId: appId,
        token: token,
        uid: Get.find<UserService>().userinfo.value?.roomid ?? 0,
        onMessage: handleLiveMessage,
      );
      await agoraLive.setDefaultSpeakerphone(true);
      await agoraLive.joinChannel(
        channel: channelName,
        clientRoleType: ClientRoleType.clientRoleAudience,
      );

      agoraLive.publishMessage(
        message: LiveMessage(
          type: LiveMessageType.join,
          senderName: userService.userinfo.value?.nickname ?? '匿名用户',
          message: userService.userinfo.value?.nickname ?? '匿名用户',
        ),
      );
    } catch (e) {
      ToastUtil.info(e.toString());
    }
  }

  /// 处理直播消息
  handleLiveMessage(LiveMessage message) {
    switch (message.type) {
      case LiveMessageType.chat:
        messageAdd("${message.senderName}：${message.message}");
        break;
      case LiveMessageType.voice:
        handleConnectUser(message);
        break;
      case LiveMessageType.notice:
        handleNoticeMessage(message);
        break;
      case LiveMessageType.join:
        messageAdd("${message.message} 进入直播间");
        break;
      case LiveMessageType.leave:
        messageAdd("${message.message} 离开直播间");
        break;
      default:
        break;
    }
  }

  // 处理连麦请求
  handleConnectUser(LiveMessage message) async {
    String state = message.message;
    if (state == "agree") {
      startVoiceChat();
    } else if (state == "stop") {
      stopVoiceChat();
    } else if (state == "reject") {
      ToastUtil.info('主播拒绝你的连麦');
    } else if (state == "room_im_update") {
      getRoomCurrentIm();
    }
  }

  /// 处理通知消息
  handleNoticeMessage(LiveMessage message) async {
    String state = message.message;
    if (state == "liveend") {
      // 直播结束
      await DialogUtil.showConfirmDialog(
        context: Get.context!,
        title: '直播结束',
        content: '直播已结束，请返回首页查看其他直播',
        confirmText: '返回',
        cancelShow: false,
        isDismissible: false,
        position: DialogPosition.center,
        onConfirm: (context) async {
          Navigator.of(context).pop();
        },
      );
      Get.back();
    }
  }

  // 离开直播间
  leaveLiveRoom() async {
    await liveApi.userOutRoom(liveRoomDetail.value!.roomid ?? 0);
    await agoraLive.publishMessage(
      message: LiveMessage(
        type: LiveMessageType.leave,
        senderName: userService.userinfo.value?.nickname ?? '匿名用户',
        message: userService.userinfo.value?.nickname ?? '匿名用户',
      ),
    );
    await agoraLive.leaveChannel();
  }

  /// 发送文本消息
  publishTextMessage() async {
    var isSuccess = await agoraLive.publishMessage(
      message: LiveMessage(
        type: LiveMessageType.chat,
        senderName: userService.userinfo.value?.nickname ?? '匿名用户',
        message: textMessage.value,
      ),
    );
    if (isSuccess) {
      messageAdd(
        "${userService.userinfo.value!.nickname}:${textMessage.value}",
      );
    }
  }

  messageAdd(String message) {
    liveMessageList.add(message);
    // 2. 数据更新后，在下一帧滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 因为 reverse: true，所以 jumpTo(0.0) 就是滚动到底部
      if (messageScrollController.hasClients) {
        messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 申请连麦,type = 0 1 2
  applyVoiceChat(int type) async {
    if (type == 2) {
      applyStopVoiceChat();
      return;
    }
    DialogUtil.showConfirmDialog(
      context: Get.context!,
      title: type == 1 ? '私密连麦' : '普通连麦',
      content: '确定要申请${type == 1 ? '私密连麦' : '普通连麦'}吗？',
      onConfirm: (context) async {
        Navigator.of(context).pop();
        final applyRes = await liveApi.teacherConnectUser(
          liveRoomDetail.value?.id ?? 0,
          type,
        );
        currentConnectRecord = applyRes?.result;
        if (applyRes == null || applyRes.result == null) {
          ToastUtil.info(applyRes?.message ?? '申请连麦失败');
          return;
        }

        var isSuccess = await agoraLive.publishMessage(
          receive: liveRoomDetail.value?.uroomid?.toString(), //主播id
          message: LiveMessage(
            type: LiveMessageType.voice,
            message: applyRes.result!.id.toString(), //"809101436289093", //
            senderName: userService.userinfo.value?.nickname ?? '匿名用户',
          ),
          channelType: RtmChannelType.user,
        );
        if (isSuccess) {
          ToastUtil.info('已发送申请，等待主播接通');
        }
      },
    );
  }

  /// 用户主动停止连麦
  /// 发布消息给主播，在主播那边更新连麦状态后，下发停止连麦消息给用户
  applyStopVoiceChat() async {
    await agoraLive.publishMessage(
      receive: liveRoomDetail.value?.uroomid?.toString(), //主播id
      message: LiveMessage(
        type: LiveMessageType.voice,
        message: "stop", //applyRes.result!.id.toString(),
        senderName: userService.userinfo.value?.nickname ?? '匿名用户',
      ),
      channelType: RtmChannelType.user,
    );
  }

  /// 加入私密连麦对话
  /// 1、离开公共频道
  /// 2、加入私密频道并开启音频
  startVoiceChat() async {
    if (currentConnectRecord == null) {
      return;
    }
    ToastUtil.info('开始连麦');
    if (currentConnectRecord!.itype == 1) {
      // 私密连麦 需要进入私密频道
      final tokenRes = await liveApi.liveRoomToken(
        currentConnectRecord!.id.toString(),
        type: "private",
      );
      if (tokenRes == null) {
        ToastUtil.info('开启私密连麦失败');
        return;
      }
      String token = tokenRes["token"];
      String appId = tokenRes["appid"];
      String channelName = tokenRes["channelName"];
      agoraLive.joinRtcChannel(
        token: token,
        channel: channelName,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      );
    } else {
      //普通连麦，直接启用本地音频即可
      agoraLive.enableAudio();
    }
    startConnectTimer();
  }

  /// 停止连麦
  /// 需要根据连麦类型处理，公共连麦直接禁止用户音频，私密连麦则需要退出私密频道加入公共频道
  stopVoiceChat() async {
    if (currentConnectRecord == null) {
      return;
    }
    ToastUtil.info('已断开连麦');
    if (currentConnectRecord!.itype == 1) {
      // 私密连麦退出私密频道，需要从新加入公共频道
      await agoraLive.leaveRtcChannel();
      await agoraLive.joinRtcChannel(token: agoraLive.token!);
    } else {
      await agoraLive.disableAudio();
    }
    stopConnectTimer();
  }

  /// 开始计时
  startConnectTimer() {
    stopConnectTimer();
    connectTypeText = currentConnectRecord?.itype == 1 ? '私密连麦' : '普通连麦';
    connectElapsedSeconds.value = 0;
    _connectTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      connectElapsedSeconds.value++;
      if (currentConnectRecord?.price != null) {
        connectCost.value =
            currentConnectRecord!.price! *
            (connectElapsedSeconds.value / 60).ceilToDouble();
      }
      // 每5秒上报连麦时长
      if (connectElapsedSeconds.value % 5 == 0 &&
          currentConnectRecord?.id != null) {
        final result = await liveApi.updateImTime(currentConnectRecord!.id!);
        if (result == -1) {
          DialogUtil.showConfirmDialog(
            context: Get.context!,
            cancelShow: false,
            title: '提示',
            content: '星钻不足，连麦已结束',
          );
          applyStopVoiceChat();
        }
      }
    });
  }

  /// 停止计时
  stopConnectTimer() {
    _connectTimer?.cancel();
    _connectTimer = null;
    connectElapsedSeconds.value = 0;
  }

  /// 点赞按钮点击处理（防抖2秒批量发送）
  void onLikePressed() {
    _pendingLikes++;
    _likeDebounceTimer?.cancel();
    _likeDebounceTimer = Timer(const Duration(seconds: 2), () async {
      int likeNum =
          await liveApi.addLikenum(
            liveRoomDetail.value?.id ?? 0,
            _pendingLikes,
          ) ??
          0;
      agoraLive.publishMessage(
        message: LiveMessage(
          type: LiveMessageType.notice,
          message: "likenum:${likeNum}",
        ),
      );
      _pendingLikes = 0;
    });
  }

  /// 关注/取消关注老师
  toggleSubscribe() async {
    final teacher = liveRoomDetail.value?.teacher;
    if (teacher == null) return;
    if (await userApi.userSubAdd({"corrid": teacher.id, "stype": 1})) {
      isTeacherSubscribed.value = 1;
      ToastUtil.info('关注成功');
    }
  }
}
