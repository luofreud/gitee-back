import 'dart:async';
import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

import '../../api/im/im_message.dart';
import '../../models/base/page_request.dart';
import '../../models/im/im_conversation.dart';
import '../../service/im_service.dart';
import '../../widgets/refresh_loadmore.dart';
import 'chat/chat_controller.dart';

class MessageController extends GetxController {
  /// 下拉刷新控制器
  late RefreshController refreshController;

  /// 会话列表
  final RxList<ImConversation> conversations = <ImConversation>[].obs;
  /// 是否正在加载
  final isLoading = false.obs;
  /// 当前分页页码
  int _page = 1;
  /// 每页条数
  static const int _pageSize = 20;

  /// 消息流订阅
  StreamSubscription? _msgSub;

  /// 总未读数（所有会话 unreadCount 之和）
  int get totalUnread =>
      conversations.fold(0, (sum, c) => sum + (c.unreadCount ?? 0));

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    loadData();
    _msgSub = Get.find<ImService>().onNewMessage.listen(_onMessageReceived);
  }

  @override
  void onClose() {
    _msgSub?.cancel();
    refreshController.dispose();
    super.onClose();
  }

  /// 收到新 IM 消息时更新会话列表（置顶 / 更新预览 / 未读计数）
  void _onMessageReceived(IMMessage msg) {
    final im = Get.find<ImService>();
    if (msg.fromUserId == im.currentUserId) return;
    final partnerId = msg.fromUserId;
    final isChatActive = Get.isRegistered<ChatController>() &&
        Get.find<ChatController>().uid.value.toString() == partnerId;
    final idx = conversations.indexWhere((c) => c.targetId == partnerId);

    if (idx >= 0) {
      String lastMsgType = '';
      String lastMessage = '';
      if (msg.data != null) {
        final raw = utf8.decode(msg.data!);
        lastMessage = raw;
        try {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          lastMsgType = json['type'] as String? ?? '';
          lastMsgType = lastMsgType == 'service' ? 'other' : lastMsgType;
        } catch (_) {}
      }
      final orig = conversations[idx];
      final now = DateTime.now().toIso8601String();
      final updated = ImConversation(
        id: orig.id,
        ownerUid: orig.ownerUid,
        targetId: orig.targetId,
        targetType: orig.targetType,
        lastMessage: lastMessage,
        lastMsgId: null,
        lastMsgType: lastMsgType,
        lastTime: now,
        unreadCount: isChatActive ? 0 : (orig.unreadCount ?? 0) + 1,
        isTop: orig.isTop,
        createdAt: orig.createdAt,
        updatedAt: now,
        targetUser: orig.targetUser,
      );
      conversations.removeAt(idx);
      conversations.insert(0, updated);
    } else {
      _fetchAndPrependNewConversation();
    }
  }

  /// 从后端拉取最新一条会话并插入列表头部（适用于新会话场景）
  Future<void> _fetchAndPrependNewConversation() async {
    final req = PageRequest(page: 1, pageSize: 1);
    final result = await ImMessageApi().pageConversations(req);
    if (result == null || result.items == null || result.items!.isEmpty) return;
    final latest = result.items!.first;
    final exists = conversations.any((c) => c.targetId == latest.targetId);
    if (!exists) {
      conversations.insert(0, latest);
    }
  }

  /// 刷新会话列表（重置分页，重新加载第一页）
  Future<void> loadData() async {
    _page = 1;
    conversations.clear();
    refreshController.resetFooter();
    await _fetchPage();
  }

  /// 加载更多历史会话（翻页）
  Future<void> loadMore() async {
    if (isLoading.value) return;
    await _fetchPage();
  }

  /// 分页获取会话列表（内部调用 API）
  Future<void> _fetchPage() async {
    isLoading.value = true;
    var req = PageRequest(page: _page, pageSize: _pageSize);
    var result = await ImMessageApi().pageConversations(req);
    isLoading.value = false;
    if (result != null) {
      conversations.addAll(result.items ?? []);
      if (_page >= (result.totalPages ?? 1)) {
        refreshController.finishLoad(IndicatorResult.noMore, true);
      } else {
        _page++;
      }
    }
  }

  void markAllRead() {}

  /// 标记指定会话为已读（本地将 unreadCount 置 0）
  void markRead(String targetId) {
    final idx = conversations.indexWhere((c) => c.targetId == targetId);
    if (idx == -1) return;
    final orig = conversations[idx];
    if ((orig.unreadCount ?? 0) == 0) return;
    final updated = ImConversation(
      id: orig.id,
      ownerUid: orig.ownerUid,
      targetId: orig.targetId,
      targetType: orig.targetType,
      lastMessage: orig.lastMessage,
      lastMsgId: orig.lastMsgId,
      lastMsgType: orig.lastMsgType,
      lastTime: orig.lastTime,
      unreadCount: 0,
      isTop: orig.isTop,
      createdAt: orig.createdAt,
      updatedAt: orig.updatedAt,
      targetUser: orig.targetUser,
    );
    conversations[idx] = updated;
  }

  /// 从列表中移除指定会话
  void removeConversation(ImConversation conv) {
    conversations.remove(conv);
  }
}
