import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:freud/models/im/im_conversation.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:get/get.dart';

import '../../constants/app_const.dart';
import '../../widgets/common/pinne_hander_delegate.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/page_background.dart';
import '../../widgets/refresh_loadmore.dart';
import 'message_controller.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MessageController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Row(
              children: [
                const Text('消息'),
                if (controller.totalUnread > 0)
                  Text(
                    '（未读${controller.totalUnread}）',
                    style: TextStyle(fontSize: 14, color: Color(0xff807CA6)),
                  ),
                if (controller.totalUnread > 0)
                  GradientButton(
                    onPressed: () => controller.markAllRead(),
                    isRadius: false,
                    height: 24,
                    radius: 2,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    gradient: LinearGradient(
                      colors: [Color(0xffE6E3FF), Color(0xffC7DAFF)],
                    ),
                    child: Text(
                      '一键已读',
                      style: TextStyle(fontSize: 13, color: Color(0xff4B7EE3)),
                    ),
                  ),
              ],
            ),
          ),
          centerTitle: false,
          backgroundColor: Colors.white.withAlpha(0),
          actions: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withAlpha(150),
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                minimumSize: Size(0, 0),
                fixedSize: Size(double.infinity, 30),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/icon_kefu.png', height: 20),
                  SizedBox(width: 5),
                  Text('客服', style: TextStyle(color: Color(0xff383838))),
                ],
              ),
            ),
            const SizedBox(width: AppConst.PAGE_PADDING),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: _BodyWidget2(),
      ),
    );
  }
}

class _BodyWidget1 extends StatelessWidget {
  const _BodyWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MessageController>();
    return Column(
      children: [
        _MessageTopNav(showBg: false),
        const SizedBox(height: 5),
        _MessageAd(),
        Expanded(
          child: RefreshLoadmore(
            onRefresh: () => ctrl.loadData(),
            onLoad: () => ctrl.loadMore(),
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xffF5F7F9),
                height: 1,
                indent: AppConst.PAGE_PADDING,
                endIndent: AppConst.PAGE_PADDING,
              ),
              itemCount: ctrl.conversations.length,
              itemBuilder: (context, index) {
                return _MessageItem(conversation: ctrl.conversations[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BodyWidget2 extends StatelessWidget {
  _BodyWidget2();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MessageController>();
    return RefreshLoadmore(
      onRefresh: () => ctrl.loadData(),
      onLoad: () => ctrl.loadMore(),
      controller: ctrl.refreshController,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox.shrink()),
          SliverPersistentHeader(
            pinned: true,
            delegate: SimplePinnedHeaderDelegate(
              minExtent: 80,
              maxExtent: 80,
              child: _MessageTopNav(),
            ),
          ),
          SliverToBoxAdapter(child: _MessageAd()),
          Obx(() {
            if (ctrl.isLoading.value && ctrl.conversations.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (ctrl.conversations.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: EmptyTips(
                    image: 'assets/images/empty_message.png',
                    title: '暂无消息',
                  ),
                ),
              );
            }
            return SlidableAutoCloseBehavior(
              child: SliverList.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xffF5F7F9),
                  height: 1,
                  indent: AppConst.PAGE_PADDING,
                  endIndent: AppConst.PAGE_PADDING,
                ),
                itemCount: ctrl.conversations.length,
                itemBuilder: (context, index) {
                  return _MessageItem(conversation: ctrl.conversations[index]);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MessageTopNav extends StatelessWidget {
  final bool showBg;

  const _MessageTopNav({super.key, this.showBg = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: showBg ? AppConst.PAGE_BACKGROUND_COLOR : Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.MSG_LIKE);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/icons/icon_zan.png',
                        width: 44,
                        height: 44,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Color(0xffFF4E4E),
                          child: Text(
                            '12',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('点赞', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.MSG_COMMENT);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/icons/icon_plhf.png',
                        width: 44,
                        height: 44,
                      ),
                    ],
                  ),
                  Text('评论和回复', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.MSG_ACTIVITY);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/icons/icon_hdtz.png',
                        width: 44,
                        height: 44,
                      ),
                    ],
                  ),
                  Text('活动通知', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.MSG_SERVICE);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/icons/icon_message.png',
                        width: 44,
                        height: 44,
                      ),
                    ],
                  ),
                  Text('服务消息', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageAd extends StatelessWidget {
  const _MessageAd({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/example/message_ad.png');
  }
}

class _MessageItem extends StatelessWidget {
  final ImConversation conversation;

  const _MessageItem({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MessageController>();
    final targetUser = conversation.targetUser;
    final name = targetUser?.nickname ?? '用户${conversation.targetId ?? ""}';
    final uid = int.tryParse(conversation.targetId ?? '') ?? 0;

    Widget item = InkWell(
      onTap: () {
        ctrl.markRead(conversation.targetId ?? '');
        Get.toNamed(AppRoutes.CHAT, arguments: {'uid': uid, 'name': name});
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConst.PAGE_PADDING,
          vertical: 8,
        ),
        child: Row(
          spacing: 10,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(52),
                    child: ImageView.network(
                      targetUser?.headimg ?? '',
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      isPreview: false,
                    ),
                  ),
                ),
                if ((conversation.unreadCount ?? 0) > 0)
                  Positioned(
                    right: 5,
                    bottom: 8,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xff34E053),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDateStr(conversation.lastTime ?? ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffA6A6A6),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _lastMessageDisplay(
                            conversation.lastMessage,
                            conversation.lastMsgType,
                          ),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff808080),
                          ),
                        ),
                      ),
                      if ((conversation.unreadCount ?? 0) > 0) ...[
                        const SizedBox(width: 15),
                        CircleAvatar(radius: 5, backgroundColor: Colors.red),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Slidable(
      groupTag: 'message',
      endActionPane: ActionPane(
        extentRatio: 80 / MediaQuery.of(context).size.width,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              ctrl.removeConversation(conversation);
            },
            backgroundColor: Color(0xFFF24444),
            foregroundColor: Colors.white,
            label: '删除',
          ),
        ],
      ),
      child: item,
    );
  }

  String _formatDateStr(dynamic datetime) {
    String timeStr = CommonUtil.formatDate(datetime, format: "yyyy-MM-dd");
    DateTime dt = DateTime.parse(timeStr);
    DateTime nowDt = DateTime.now();
    String timeStr2 = CommonUtil.formatDate(datetime, format: "hh:mm");

    var dtDifference = DateTime(
      nowDt.year,
      nowDt.month,
      nowDt.day,
    ).difference(DateTime(dt.year, dt.month, dt.day));
    if (dtDifference.inDays == 0) {
      return "今天 $timeStr2";
    } else if (dtDifference.inDays == 1) {
      return "昨天  $timeStr2";
    } else if (dt.year == DateTime.now().year) {
      return timeStr;
    } else if (dt.year != DateTime.now().year) {
      return timeStr;
    }
    return timeStr;
  }

  static String _lastMessageDisplay(String? lastMessage, String? lastMsgType) {
    if (lastMessage == null || lastMessage.isEmpty) return '';
    switch (lastMsgType) {
      case 'text':
        try {
          final json = jsonDecode(lastMessage) as Map<String, dynamic>;
          return json['content'] as String? ?? '';
        } catch (_) {
          return lastMessage;
        }
      case 'image':
        return '[图片]';
      case 'audio':
        return '[语音]';
      case 'video':
        return '[视频]';
      case 'file':
        return '[文件]';
      case 'voice_call':
        return '[语音通话]';
      case 'location':
        return '[位置]';
      case 'system':
        return '[系统消息]';
      case 'other':
        try {
          final json = jsonDecode(lastMessage) as Map<String, dynamic>;
          String jsonType = json['type'] as String? ?? '';
          switch (jsonType) {
            case 'service':
              return '[问答]';
            default:
              return jsonType;
          }
        } catch (error) {
          return lastMessage;
        }
      default:
        return lastMessage;
    }
  }
}
