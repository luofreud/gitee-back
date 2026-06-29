import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/api/im/im_message.dart';
import 'package:freud/api/live/teacher_api.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/im/im_message.dart';
import 'package:freud/models/live/xz_question.dart';
import 'package:freud/models/user/teacher.dart';
import 'package:freud/pages/message/message_controller.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/im_service.dart';
import 'package:freud/service/notification_service.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/utils/voice_util.dart';
import 'package:get/get.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

import 'widgets/chat_service_hp.dart';
import 'widgets/chat_service_tip.dart';
import 'widgets/chat_service_tz.dart';
import 'widgets/chat_service_xp.dart';
import 'widgets/chat_service_zhp.dart';

class ChatController extends GetxController {
  /// 聊天工具栏是否显示
  final chatShowTool = false.obs;

  /// 聊天工具栏的实际高度，默认值200，通过预渲染组件获取工具栏实际渲染高度
  double chatToolHeightMax = 200;

  /// 聊天工具栏高度，用于动画效果，从0-chatToolHeightMax之间切换
  final chatToolHeight = 0.0.obs;

  final showNoticeTips = false.obs;

  /// 语音输入
  final showVoiceInput = false.obs;

  /// 聊天对方的用户 ID
  final uid = 0.obs;

  /// 聊天对方的显示名称
  final chatName = ''.obs;

  /// 当前用户的头像 URL
  final currentUserAvatar = ''.obs;

  /// 聊天对方的头像 URL
  final partnerAvatar = ''.obs;

  /// 导师详情（聊天对象为导师时有值）
  final teacher = Rxn<Teacher>();

  /// 文本输入框控制器
  final textController = TextEditingController();

  /// IM 消息流订阅
  StreamSubscription<IMMessage>? _imSub;

  /// 当前正在播放的语音消息 URL（用于 UI 互斥）
  final playingVoiceUrl = Rxn<String>();

  /// 滚动控制器
  ScrollController scrollController = ScrollController();

  /// 当前分页消息列表（page 1 + 新消息，作为 CustomScrollView 的 center）
  final messages = <ImMessage>[].obs;

  /// 历史分页消息列表（page 2+ 旧消息，位于 center 之上自动向上生长）
  final historyMessages = <ImMessage>[].obs;

  /// CustomScrollView center 所需 key（公开给 view 使用）
  static const bottomListKey = ValueKey<String>('bottom-list');
  static const topListKey = ValueKey<String>('top-list');

  /// 分页页码
  int _page = 1;

  /// 是否还有更多消息
  bool _hasMore = true;

  /// 是否正在加载消息
  final isLoading = false.obs;

  /// 是否正在首次加载
  final initLoading = true.obs;

  /// 打赏固定选项
  List starAppreciateList = [
    {"value": 8, "title": "8星钻"},
    {"value": 12, "title": "12星钻"},
    {"value": 18, "title": "18星钻"},
    {"value": 0, "title": "不赞赏"},
  ];

  /// questionDetail 本地缓存（随 chatpage 销毁清空）
  final questionDetailCache = <int, XzQuestion>{};

  /// 打赏快捷选项
  List starTipDefaultList = [
    {"value": 8, "title": "8星钻"},
    {"value": 12, "title": "12星钻"},
    {"value": 18, "title": "18星钻"},
    {"value": 0, "title": "自定义"},
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      final args = Get.arguments as Map;
      uid.value = args['uid'] ?? 0;
      chatName.value = args['name'] ?? '';
    }
    final userSvc = Get.find<UserService>();
    currentUserAvatar.value = userSvc.userinfo.value?.utype == 1
        ? (userSvc.teacherInfo.value?.headimg ?? '')
        : (userSvc.userinfo.value?.headimg ?? '');
    if (Get.isRegistered<MessageController>()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.find<MessageController>().markRead(uid.value.toString());
      });
    }
    _loadPartnerAvatar();
    _loadTeacherDetail();
    scrollController.addListener(_onScroll);
    _imSub = Get.find<ImService>().onNewMessage.listen(_onImMessage);

    Get.find<NotificationService>().hasPermission().then((bool result) {
      showNoticeTips.value = !result;
    });
  }

  @override
  void onClose() {
    questionDetailCache.clear();
    _imSub?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    textController.dispose();
    AudioPlayerManager().dispose();
    super.onClose();
  }

  /// 滚动监听，滚动到顶部时触发加载更多历史消息
  void _onScroll() {
    // scrollController.position.minScrollExtent顶部的最小距离
    // scrollController.position.pixels 当前滚动的位置
    // 当滚动超过CustomScrollView的center组件时就会变成负数，用当前位置间距顶部最小距离判断是否滚动到顶部
    final atTop =
        (scrollController.position.pixels -
            scrollController.position.minScrollExtent) <
        50;
    if (atTop && _hasMore && !isLoading.value) {
      _loadMessages();
    }
  }

  /// 分页加载聊天消息历史
  Future<void> _loadMessages() async {
    if (isLoading.value || !_hasMore) return;
    isLoading.value = true;

    final result = await ImMessageApi().messageList(
      PageRequest(page: _page, pageSize: 20),
      uid: uid.value.toString(),
    );

    if (result != null && result.items != null) {
      if (_page == 1) {
        messages.value = result.items!.reversed.toList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            initLoading.value = false;
          });
        });
      } else {
        // 旧消息添加到 historyMessages（位于 center 上方，自动向上生长）
        // GrowthDirection.reverse 下 index 0 靠近 center，需 [oldest→newest]
        historyMessages.addAll(result.items!.toList());
      }
      _hasMore = result.hasNextPage ?? false;
      _page++;
    }
    // initLoading.value = false;
    isLoading.value = false;
  }

  /// 将消息列表滚动到底部（最新消息）
  void scrollToBottom() {
    if (scrollController.hasClients) {
      if (initLoading.value) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent + 1000,
        );
      } else {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    }
  }

  /// 播放或停止语音（互斥：同一时刻只能有一个语音播放）
  Future<void> playVoice(String url) async {
    if (playingVoiceUrl.value == url) {
      stopVoice();
      return;
    }
    playingVoiceUrl.value = url;
    try {
      final res = await AudioPlayerManager().play(
        url: url,
        onComplete: () {
          if (playingVoiceUrl.value == url) playingVoiceUrl.value = null;
        },
      );
      if (res == false) {
        if (playingVoiceUrl.value == url) playingVoiceUrl.value = null;
        ToastUtil.info('播放失败');
      }
    } catch (_) {
      if (playingVoiceUrl.value == url) playingVoiceUrl.value = null;
    }
  }

  /// 停止语音播放
  void stopVoice() {
    AudioPlayerManager().stop();
    playingVoiceUrl.value = null;
  }

  /// 收到新消息时消息处理
  void _onImMessage(IMMessage msg) {
    final currentUid = Get.find<UserService>().userinfo.value?.id?.toString();
    if (currentUid == null) return;
    if (msg.fromUserId != uid.value.toString()) return;
    if (msg.toUserId != currentUid) return;
    String? type;
    try {
      if (msg.textData.startsWith('{')) {
        final map = jsonDecode(msg.textData) as Map<String, dynamic>;
        type = map['type'] as String?;
        type = type == 'service' ? 'other' : type;
        if (type == 'voice_call') {
          final action = map['action'] as String?;
          if (!_isFinalCallAction(action)) return;
          fetchAndInsertLatestVoiceCall();
          return;
        }
      }
    } catch (_) {}
    messages.add(
      ImMessage(
        fromUid: msg.fromUserId,
        toUid: msg.toUserId,
        content: msg.textData,
        type: type,
        createdAt: _tsToString(msg.timestamp),
      ),
    );
    Future.delayed(Duration(milliseconds: 100), () {
      scrollToBottom();
    });
  }

  /// 将毫秒时间戳转为 "yyyy-MM-dd HH:mm:ss" 格式字符串
  String _tsToString(int ts) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ts);
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)} ${_pad(dt.hour)}:${_pad(dt.minute)}:${_pad(dt.second)}';
  }

  /// 数字补零（如 3 → "03"）
  String _pad(int n) => n.toString().padLeft(2, '0');

  /// 显示隐藏聊天工具栏
  /// status 状态，true显示，false隐藏
  /// 显示工具栏时先设置显示条件为true，让组件渲染到屏幕上，然后间隔100毫秒设置组件的高度为实际高度，以动画的方式展开工具栏
  /// 隐藏时先设置工具栏的高度为0，以动画的方式收起工具栏，260毫秒动画结束后设置显示条件为false，
  showHideChatTool({bool? status}) {
    bool _newStatus = status ?? !chatShowTool.value;
    if (_newStatus) {
      chatShowTool.value = _newStatus;
      Future.delayed(Duration(milliseconds: 100), () {
        chatToolHeight.value = chatToolHeightMax;
      });
    } else {
      Future.delayed(Duration(milliseconds: 100), () {
        chatToolHeight.value = 0;
        Future.delayed(Duration(milliseconds: 260), () {
          chatShowTool.value = false;
        });
      });
    }
  }

  /// 显示星盘服务弹窗
  void showServiceXp(context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ChatServiceXp(starData: starAppreciateList),
      ),
    );
  }

  /// 显示骰子服务弹窗
  void showServiceTz(context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ChatServiceTz(starData: starAppreciateList),
      ),
    );
  }

  /// 显示合盘服务弹窗
  void showServiceHp(context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ChatServiceHp(starData: starAppreciateList),
      ),
    );
  }

  /// 显示智慧牌服务弹窗
  void showServiceZhp(context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ChatServiceZhp(starData: starAppreciateList),
      ),
    );
  }

  /// 发起语音通话
  Future<void> startVoiceCall() async {
    await Get.toNamed(AppRoutes.VOICE_CALL, arguments: {'uid': uid.value});
    fetchAndInsertLatestVoiceCall();
  }

  /// 判断是否为语音通话最终状态
  /// 中间状态（calling/ringing/accepted）不显示在会话中
  bool _isFinalCallAction(String? action) {
    return action == 'ended' ||
        action == 'canceled' ||
        action == 'rejected' ||
        action == 'missed' ||
        action == 'busy';
  }

  /// 从后端获取最新一条语音通话消息并插入会话
  Future<void> fetchAndInsertLatestVoiceCall() async {
    final pageData = await ImMessageApi().messageList(
      PageRequest(page: 1, pageSize: 1),
      uid: uid.value.toString(),
    );
    if (pageData?.items != null && pageData!.items!.isNotEmpty) {
      final latest = pageData.items!.first;
      if (latest.type == 'voice_call') {
        if (messages.isNotEmpty && messages.last.content == latest.content)
          return;
        messages.add(latest);
        scrollToBottom();
      }
    }
  }

  /// 显示打赏服务弹窗
  void showServiceTip(context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ChatServiceTip(starData: starTipDefaultList),
      ),
    );
  }

  /// 加载对方头像（通过 ImService 缓存，不走 TeacherApi）
  Future<void> _loadPartnerAvatar() async {
    if (uid.value <= 0) return;
    final info = await Get.find<ImService>().getUserInfo(uid.value.toString());
    partnerAvatar.value = info?.headimg ?? '';
  }

  /// 加载聊天对方详情（优先从 TeacherApi 获取，失败则从 ImService 获取昵称）
  Future<void> _loadTeacherDetail() async {
    if (uid.value <= 0) return;
    initLoading.value = true;
    final result = await TeacherApi().teacherDetail(uid: uid.value);
    if (result != null) {
      teacher.value = result;
      chatName.value = result.name ?? chatName.value ?? '';
    } else {
      final info = await Get.find<ImService>().getUserInfo(
        uid.value.toString(),
      );
      chatName.value = info?.nickname ?? '';
    }
    _loadMessages();
  }

  /// 发送文本消息（构造 JSON → 调用 ImService → 本地追加消息记录）
  void sendTextMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    final fromUid = Get.find<UserService>().userinfo.value?.id;
    final toUid = uid.value;
    if (fromUid == null || toUid <= 0) return;
    final rc = await Get.find<ImService>().sendTextMessage(
      fromUserId: fromUid.toString(),
      toUserId: toUid.toString(),
      content: text,
    );
    textController.clear();
    if (rc == 0) {
      final now = DateTime.now();
      final createdAt =
          '${now.year}-${_pad(now.month)}-${_pad(now.day)} ${_pad(now.hour)}:${_pad(now.minute)}:${_pad(now.second)}';
      messages.add(
        ImMessage(
          fromUid: fromUid.toString(),
          toUid: toUid.toString(),
          type: 'text',
          content: jsonEncode({'type': 'text', 'content': text}),
          createdAt: createdAt,
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    }
  }
}
