import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/im/im_message.dart';
import 'package:freud/pages/message/chat/widgets/chat_teacher_info.dart';
import 'package:freud/service/notification_service.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/animation/liveing_animation.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import 'chat_controller.dart';
import 'widgets/chat_item.dart';
import 'widgets/chat_you_may_ask.dart';
import 'widgets/image_send_widget.dart';
import 'widgets/voice_record_widget.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  _buildServices(context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.showServiceXp(context);
            },
            child: Image.asset(
              'assets/icons/chat_icon_xp.png',
              // width: 80,
              height: 30,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.showServiceTz(context);
            },
            child: Image.asset(
              'assets/icons/chat_icon_tz.png',
              // width: 80,
              height: 30,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.showServiceHp(context);
            },
            child: Image.asset(
              'assets/icons/chat_icon_hp.png',
              // width: 80,
              height: 30,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              controller.showServiceZhp(context);
            },
            child: Image.asset(
              'assets/icons/chat_icon_zhp.png',
              // width: 80,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }

  /// 消息通知提示，提醒用户开启通知功能
  _buildNoticeTips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('开启消息通知', style: TextStyle(fontSize: 16)),
                Text(
                  '开启消息通知后可即时接受咨询师消息',
                  style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                ),
              ],
            ),
          ),
          GradientButton(
            onPressed: () async {
              await Get.find<NotificationService>().requestPermissions();
              controller.showNoticeTips.value = false;
            },
            height: 32,
            child: Text('立即开启'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChatController());
    return GestureDetector(
      onTap: () {
        CommonUtil.hideKeyShowUnfocus();
        controller.showHideChatTool(status: false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            spacing: 10,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width *
                      0.35, // 根据UI需求调整（比如预留标签宽度）
                ),
                child: Obx(
                  () => Text(
                    controller.chatName.value.isNotEmpty
                        ? controller.chatName.value
                        : '',
                  ),
                ),
              ),
              Obx(() {
                if (controller.teacher.value?.livestate == 1) {
                  return Container(
                    height: 20,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffFF3B3B),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      spacing: 3,
                      children: [
                        LiveingAnimationWidget(),
                        Text(
                          '直播中',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
            ],
          ),
          titleSpacing: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Image.asset(
                'assets/icons/icon_call.png',
                width: 26,
                height: 26,
              ),
              onPressed: () => controller.startVoiceCall(),
            ),
            IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: controller.scrollController,
                    center: ChatController.bottomListKey,
                    slivers: [
                      // 导师卡片（before center）
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: AppConst.PAGE_PADDING,
                          right: AppConst.PAGE_PADDING,
                          top: AppConst.PAGE_PADDING,
                          bottom: 10,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Obx(() {
                            if (controller.initLoading.value ||
                                controller.teacher.value == null) {
                              return SizedBox.shrink();
                            }
                            return ChatTeacherInfo(
                              teacher: controller.teacher.value,
                            );
                          }),
                        ),
                      ),
                      // 历史消息（before center，自动向上生长）
                      SliverPadding(
                        key: ChatController.topListKey,
                        padding: const EdgeInsets.only(
                          left: AppConst.PAGE_PADDING,
                          right: AppConst.PAGE_PADDING,
                        ),
                        sliver: Obx(() {
                          final msgs = controller.historyMessages;
                          final currentUserId = Get.find<UserService>()
                              .userinfo
                              .value
                              ?.id
                              ?.toString();
                          if (msgs.isEmpty) {
                            return SliverToBoxAdapter(child: SizedBox.shrink());
                          }
                          return SliverList.separated(
                            itemCount: msgs.length,
                            separatorBuilder: (context, index) {
                              if (index >= msgs.length - 1) {
                                return const SizedBox(height: 10);
                              }
                              final current = msgs[index];
                              final next = msgs[index + 1];
                              final showDate =
                                  current.createdAt != null &&
                                  _dateOnly(current.createdAt!) !=
                                      _dateOnly(
                                        next.createdAt ?? current.createdAt!,
                                      );
                              return Column(
                                children: [
                                  SizedBox(height: 10),
                                  if (showDate && next.createdAt != null)
                                    Container(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        next.createdAt!,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xff808080),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                            itemBuilder: (context, index) {
                              final msg = msgs[index];
                              final isSend = msg.fromUid == currentUserId;
                              final type = _messageTypeFromString(
                                msg.type,
                                msg,
                              );
                              return ChatItem(
                                index: index,
                                isSend: isSend,
                                type: type,
                                message: msg,
                                avatarUrl: isSend
                                    ? controller.currentUserAvatar.value
                                    : controller.partnerAvatar.value,
                              );
                            },
                          );
                        }),
                      ),
                      // 当前消息（center）
                      SliverPadding(
                        key: ChatController.bottomListKey,
                        padding: const EdgeInsets.only(
                          left: AppConst.PAGE_PADDING,
                          right: AppConst.PAGE_PADDING,
                        ),
                        sliver: Obx(() {
                          final msgs = controller.messages;
                          final currentUserId = Get.find<UserService>()
                              .userinfo
                              .value
                              ?.id
                              ?.toString();
                          return SliverList.separated(
                            itemCount: msgs.length,
                            separatorBuilder: (context, index) {
                              if (index >= msgs.length - 1) {
                                return const SizedBox(height: 10);
                              }
                              final current = msgs[index];
                              final next = msgs[index + 1];
                              final showDate =
                                  current.createdAt != null &&
                                  _dateOnly(current.createdAt!) !=
                                      _dateOnly(
                                        next.createdAt ?? current.createdAt!,
                                      );
                              return Column(
                                children: [
                                  SizedBox(height: 10),
                                  if (showDate && next.createdAt != null)
                                    Container(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        next.createdAt!,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xff808080),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                            itemBuilder: (context, index) {
                              final msg = msgs[index];
                              final isSend = msg.fromUid == currentUserId;
                              final type = _messageTypeFromString(
                                msg.type,
                                msg,
                              );
                              return ChatItem(
                                index: index,
                                isSend: isSend,
                                type: type,
                                message: msg,
                                avatarUrl: isSend
                                    ? controller.currentUserAvatar.value
                                    : controller.partnerAvatar.value,
                              );
                            },
                          );
                        }),
                      ),
                      // 你可能想问（after center）
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: AppConst.PAGE_PADDING,
                          right: AppConst.PAGE_PADDING,
                          top: 10,
                          bottom: 50,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Obx(() {
                            return controller.initLoading.value == false &&
                                    controller.messages.isEmpty
                                ? ChatYouMayAsk()
                                : SizedBox.shrink();
                          }),
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (controller.initLoading.value ||
                        controller.teacher.value == null) {
                      return SizedBox.shrink();
                    }
                    return Positioned(
                      left: AppConst.PAGE_PADDING,
                      right: AppConst.PAGE_PADDING,
                      top: 10,
                      child: ChatTeacherInfo(teacher: controller.teacher.value),
                    );
                  }),
                  Obx(() {
                    if (controller.showNoticeTips.value != true) {
                      return SizedBox.shrink();
                    }
                    return Positioned(
                      left: AppConst.PAGE_PADDING,
                      right: AppConst.PAGE_PADDING,
                      top: 100,
                      child: _buildNoticeTips(),
                    );
                  }),
                  Positioned(
                    left: AppConst.PAGE_PADDING,
                    right: AppConst.PAGE_PADDING,
                    bottom: 10,
                    child: _buildServices(context),
                  ),
                  Positioned(
                    right: AppConst.PAGE_PADDING,
                    bottom: 40,
                    child: GestureDetector(
                      onTap: () => controller.startVoiceCall(),
                      child: Image.asset(
                        'assets/icons/chat_icon_voice.png',
                        width: 76,
                        height: 76,
                      ),
                    ),
                  ),

                  Obx(() {
                    if (controller.initLoading.value) {
                      return Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: Colors.white,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
            _ChatFooter(),
          ],
        ),
      ),
    );
  }
}

MessageType _messageTypeFromString(String? type, ImMessage msg) {
  if (type == 'other') {
    // 单独处理服务类的类型
    try {
      final map = jsonDecode(msg.content!) as Map<String, dynamic>;
      if (map['type'] == 'service') {
        type = map['subtype'];
      }
    } finally {}
  }

  switch (type?.toLowerCase()) {
    case 'text':
      return MessageType.TEXT;
    case 'image':
      return MessageType.IMAGE;
    case 'audio':
      return MessageType.AUDIO;
    case 'video':
      return MessageType.VIDEO;
    case 'file':
      return MessageType.FILE;
    case 'astrolabe':
    case 'xp':
      return MessageType.ASTROLABE;
    case 'dice':
    case 'tz':
      return MessageType.DICE;
    case 'poker':
    case 'zhp':
      return MessageType.POKER;
    case 'composite':
    case 'hp':
      return MessageType.COMPOSITE;
    case 'voice_call':
      return MessageType.VOICE_CALL;
    default:
      return MessageType.TEXT;
  }
}

String _dateOnly(String dateTimeStr) {
  if (dateTimeStr.length >= 10) return dateTimeStr.substring(0, 10);
  return dateTimeStr;
}

class _ChatFooter extends StatelessWidget {
  const _ChatFooter({super.key});

  Widget _buildToolItem(String icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(icon, width: 46, height: 46, fit: BoxFit.fill),
        Text(title, style: TextStyle(fontSize: 14, color: Color(0xff808080))),
      ],
    );
  }

  Widget _buildToolbar(context) {
    final controller = Get.find<ChatController>();
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 80,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.only(top: 10),
      children: [
        GestureDetector(
          onTap: () {
            controller.startVoiceCall();
          },
          child: _buildToolItem(
            'assets/icons/icon_chat_tool_voice.png',
            '语音通话',
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.showServiceXp(context);
          },
          child: _buildToolItem('assets/icons/icon_chat_tool_xp.png', '星盘'),
        ),
        GestureDetector(
          onTap: () {
            controller.showServiceHp(context);
          },
          child: _buildToolItem('assets/icons/icon_chat_tool_hp.png', '合盘'),
        ),
        GestureDetector(
          onTap: () {
            controller.showServiceTz(context);
          },
          child: _buildToolItem('assets/icons/icon_chat_tool_sz.png', '骰子'),
        ),
        GestureDetector(
          onTap: () {
            controller.showServiceZhp(context);
          },
          child: _buildToolItem('assets/icons/icon_chat_tool_zhp.png', '智慧牌'),
        ),
        GestureDetector(
          onTap: () {
            controller.showServiceTip(context);
          },
          child: _buildToolItem('assets/icons/icon_chat_tool_ds.png', '打赏'),
        ),
        GestureDetector(
          child: _buildToolItem('assets/icons/icon_chat_tool_qb.png', '钱包'),
        ),
      ],
    );
  }

  Widget _buildTextWidget() {
    final controller = Get.find<ChatController>();
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: TextField(
            controller: controller.textController,
            cursorHeight: 16,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              constraints: BoxConstraints(maxHeight: 36),
              hintText: '礼貌交流~',
              hintStyle: TextStyle(color: Color(0xffB1BEC7), fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xffF5F5F5),
            ),
            onTap: () {
              controller.showHideChatTool(status: false);
            },
          ),
        ),
        GradientButton(
          onPressed: () {
            controller.sendTextMessage();
          },
          height: 36,
          width: 80,
          isRadius: false,
          child: Text('发送'),
        ),
      ],
    );
  }

  Widget _buildVoiceWidget() {
    final controller = Get.find<ChatController>();
    return VoiceRecordWidget(toUid: controller.uid.value);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    var _toolKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取组件的渲染对象
      final RenderBox? renderBox =
          _toolKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        var _targetHeight = renderBox.size.height;
        controller.chatToolHeightMax = _targetHeight;
      }
    });
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Color(0xffFCFCFC)),
      child: Column(
        spacing: 0,
        children: [
          Obx(() {
            return controller.showVoiceInput.value
                ? _buildVoiceWidget()
                : _buildTextWidget();
          }),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.showVoiceInput.value =
                        !controller.showVoiceInput.value;
                  },
                  child: Obx(() {
                    if (controller.showVoiceInput.value) {
                      return Icon(Icons.keyboard_alt_outlined, size: 28);
                    } else {
                      return Image.asset(
                        'assets/icons/icon_chat_voice.png',
                        width: 28,
                      );
                    }
                  }),
                ),
                ImageSendGallery(toUid: controller.uid.value),
                ImageSendCamera(toUid: controller.uid.value),
                GestureDetector(
                  onTap: () {
                    controller.chatShowTool.value = false;
                  },
                  child: Image.asset(
                    'assets/icons/icon_chat_emote.png',
                    width: 28,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CommonUtil.hideKeyShowUnfocus();
                    controller.showHideChatTool();
                  },
                  child: Obx(() {
                    return Image.asset(
                      'assets/icons/${controller.chatShowTool.value ? 'icon_chat_close.png' : 'icon_chat_add.png'}',
                      width: 28,
                    );
                  }),
                ),
              ],
            ),
          ),

          /// 渲染一个隐藏工具栏用于获取实际高度，让工具栏展开时能够动画展开到实际高度
          Offstage(
            child: Container(key: _toolKey, child: _buildToolbar(context)),
          ),

          /// 渲染实际工具栏
          Obx(() {
            if (!controller.chatShowTool.value) {
              return SizedBox.shrink();
            }
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: controller.chatToolHeight.value,
              width: double.infinity,
              decoration: BoxDecoration(),
              clipBehavior: Clip.hardEdge,
              child: _buildToolbar(context),
            );
          }),
        ],
      ),
    );
  }
}
