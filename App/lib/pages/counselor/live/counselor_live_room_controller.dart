import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/pages/counselor/live/widgets/live_room_notice.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/widgets/live/agora_live.dart';
import 'package:get/get.dart';

import '../../../models/live/live_connect_record.dart';
import '../../../models/live/live_room.dart';
import '../../../models/user/userinfo.dart';
import '../../../utils/dialog_util.dart';

class CounselorLiveRoomController extends GetxController {
  late AgoraLive agoraLive;

  final textMessage = ''.obs;

  final liveMessageList = <String>[].obs;
  late ScrollController messageScrollController;

  final showVoiceChat = false.obs;

  final _context = Get.context;

  late LiveRoomNoticeController noticeController;
  final counselorLiveApi = CounselorLiveApi();
  final liveApi = LiveApi();

  Rx<LiveRoom?> liveRoomDetail = Rx<LiveRoom?>(null);
  List<Userinfo> liveUserList = <Userinfo>[].obs;
  RxList<LiveConnectRecord> liveConnectUserList = <LiveConnectRecord>[].obs;
  final pageLoading = false.obs;

  final likeNumber = 0.obs;
  final liveUserNumber = 0.obs;
  bool miniLiveRoom = false;
  Timer? _timer;

  //用户当前的连麦申请
  Rx<LiveConnectRecord?> currentConnectRecord = Rx<LiveConnectRecord?>(null);
  Timer? _connectTimer;
  RxInt connectElapsedSeconds = 0.obs;
  RxDouble connectCost = 0.0.obs;
  String connectTypeText = '普通连麦';
  int? _connectPrice;

  // 直播间当前连麦信息
  Rx<LiveConnectRecord?> roomCurrentConnect = Rx<LiveConnectRecord?>(null);

  late int roomId;

  @override
  void onInit() {
    super.onInit();
    roomId = Get.arguments["roomId"];
    messageScrollController = ScrollController();
    noticeController = LiveRoomNoticeController();
    miniLiveRoom = false;
    initData();
  }

  initData() async {
    pageLoading.value = true;
    await getLiveRoomInfo();
    await initLiveRoom();
    pageLoading.value = false;
    //_startUserPolling();
    getRoomCurrentIm();
  }

  void _startUserPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      getLiveRoomUsers();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    _connectTimer?.cancel();
    messageScrollController.dispose();
    noticeController.dispose();
    super.onClose();
  }

  /// 初始化直播
  initLiveRoom() async {
    final tokenRes = await counselorLiveApi.liveRoomToken(roomId);
    if (tokenRes == null) {
      ToastUtil.info('进入直播间失败');
      return;
    }
    String token = tokenRes["token"];
    String appId = tokenRes["appid"];
    String channelName = tokenRes["channelName"];
    try {
      agoraLive = await AgoraLive().init(
        appId: appId,
        token: token,
        uid: Get.find<UserService>().userinfo.value?.roomid ?? 0,
        onMessage: handleLiveMessage,
      );
      await agoraLive.joinChannel(
        channel: channelName,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      );
      // await agoraLive.enableAudio();
    } catch (e) {
      ToastUtil.info(e.toString());
      // Future.delayed(Duration(milliseconds: 1000), () {
      //   Get.back();
      // });
    }
  }

  getLiveRoomInfo() async {
    var res = await liveApi.getRoomDetail(roomId);
    if (res == null) {
      return;
    }
    liveRoomDetail.value = res;
    if (res.content != null && res.content!.isNotEmpty) {
      messageAdd(res.content!);
    }
    likeNumber.value = res.likerum ?? 0;

    var users = await liveApi.firstInRoom(liveRoomDetail.value!.roomid ?? 0);
    liveUserList.addAll(users!);
    liveUserNumber.value = liveUserList.length;
  }

  // 获取连麦等待/连麦中用户列表
  getLiveConnectUsers() async {
    var users = await counselorLiveApi.roomWaitImLog(roomId);
    if (users == null) return;
    liveConnectUserList.value = users;
  }

  // 获取直播间所有用户
  getLiveRoomUsers() async {
    var users = await liveApi.refreshRoom(liveRoomDetail.value!.roomid ?? 0);
    if (users == null) {
      return;
    }
    liveUserList.clear();
    liveUserList.addAll(users);
    liveUserNumber.value = liveUserList.length;
  }

  /// 获取当前直播间连麦信息
  getRoomCurrentIm() async {
    final res = await liveApi.getRoomIm(roomId);
    roomCurrentConnect.value = res;
  }

  /// 处理直播消息
  handleLiveMessage(LiveMessage message) {
    switch (message.type) {
      case LiveMessageType.chat:
        messageAdd("${message.senderName}：${message.message}");
        break;
      case LiveMessageType.voice:
        //收到连麦请求
        handleConnectUser(message);
        break;
      case LiveMessageType.notice:
        //收到连麦请求
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
    if (message.message == "stop" && currentConnectRecord.value != null) {
      //用户主动断开连麦,不需要更新连麦状态，因为在用户那边已经进行了更新
      updateImLogState(currentConnectRecord.value!, 2);
      DialogUtil.showConfirmDialog(
        context: Get.context!,
        cancelShow: false,
        title: '提示',
        content: '已结束连麦，用户主动断开或用户星钻不足',
      );
      return;
    }
    final logId = int.parse(message.message);
    final imLogDetail = await counselorLiveApi.getImLogDetail(logId);
    if (imLogDetail != null && imLogDetail.state == 0) {
      currentConnectRecord.value = imLogDetail;
      noticeController.show(
        record: imLogDetail,
        onCancel: () {
          updateImLogState(imLogDetail, 4);
          noticeController.hide();
        },
        onConfirm: () {
          updateImLogState(imLogDetail, 1);
          noticeController.hide();
        },
      );
    }
  }

  /// 处理通知消息
  handleNoticeMessage(LiveMessage message) async {
    String state = message.message;
    if (state.contains("likenum")) {
      final likeNum = int.parse(state.split(":")[1]);
      if (likeNum > likeNumber.value) {
        likeNumber.value = likeNum;
      }
    }
  }

  /// 更新连麦记录状态（同意/拒绝/断开）
  updateImLogState(LiveConnectRecord record, int newState) async {
    var result = await counselorLiveApi.updateImLog(
      LiveConnectRecord(id: record.id, state: newState),
    );
    String message = "";
    switch (newState) {
      case 1:
        message = "agree";
        currentConnectRecord.value = record;
        break;
      case 2:
        message = "stop";
        break;
      case 4:
        message = "reject";
        break;
      default:
        break;
    }
    // 发消息给用户告诉用户是同意还是拒绝
    agoraLive.publishMessage(
      receive: record.user?.roomid.toString() ?? "", //用户id
      message: LiveMessage(
        type: LiveMessageType.voice,
        message: message, //agree reject
      ),
      channelType: RtmChannelType.user,
    );
    //发送刷新消息给用户
    agoraLive.publishMessage(
      message: LiveMessage(
        type: LiveMessageType.voice,
        message: 'room_im_update', //agree reject
      ),
    );
    getRoomCurrentIm();
    if (result) {
      if (newState == 1) {
        startVoiceChat();
      } else if (newState == 2) {
        stopVoiceChat();
      }
      await getLiveConnectUsers();
    } else {
      ToastUtil.info('操作失败');
    }
  }

  // 离开直播间
  leaveLiveRoom() async {
    //发送消息到后台更新直播状态
    // await counselorLiveApi.closeRoom(int.parse(roomId));
    // 发送消息给所有用户直播结束
    await agoraLive.publishMessage(
      message: LiveMessage(type: LiveMessageType.notice, message: 'liveend'),
    );
    // 关闭直播
    await agoraLive.dispose();
    _timer?.cancel();
    _connectTimer?.cancel();
  }

  /// 发送文本消息
  publishTextMessage() async {
    var isSuccess = await agoraLive.publishMessage(
      message: LiveMessage(
        type: LiveMessageType.chat,
        message: textMessage.value,
        senderName: liveRoomDetail.value?.teacher?.name ?? '匿名用户',
      ),
    );
    if (isSuccess) {
      messageAdd("${liveRoomDetail.value?.teacher?.name}:${textMessage.value}");
      // ToastUtil.info('发送成功');
    }
  }

  /// 添加一条消息
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

  /// 加入私密连麦对话
  /// 1、离开公共频道
  /// 2、加入私密频道并开启音频
  startVoiceChat() async {
    if (currentConnectRecord.value == null) {
      return;
    }
    if (currentConnectRecord.value!.itype == 1) {
      // 私密连麦，获取新的频道token，进入新的频道
      final tokenRes = await liveApi.liveRoomToken(
        currentConnectRecord.value!.id.toString(),
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
    }
    startConnectTimer();
  }

  /// 停止连麦
  /// 需要根据连麦类型处理，公共连麦直接禁止用户音频，私密连麦则需要退出私密频道加入公共频道
  stopVoiceChat() async {
    if (currentConnectRecord.value == null) {
      return;
    }
    ToastUtil.info('已断开连麦');
    if (currentConnectRecord.value!.itype == 1) {
      // 私密连麦退出私密频道，需要从新加入公共频道
      await agoraLive.leaveRtcChannel();
      await agoraLive.joinRtcChannel(
        token: agoraLive.token!,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      );
    }
    stopConnectTimer();
  }

  // 开始连麦计时
  startConnectTimer() {
    stopConnectTimer();
    connectElapsedSeconds.value = 0;
    connectCost.value = 0;
    connectTypeText = currentConnectRecord.value!.itype == 1 ? '私密连麦' : '普通连麦';
    _connectPrice = currentConnectRecord.value!.price;
    _connectTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      connectElapsedSeconds.value++;
      if (_connectPrice != null) {
        connectCost.value =
            _connectPrice! * (connectElapsedSeconds.value / 60).ceilToDouble();
      }
    });
  }

  // 结束连麦计时
  stopConnectTimer() {
    _connectTimer?.cancel();
    _connectTimer = null;
    connectElapsedSeconds.value = 0;
  }
}
