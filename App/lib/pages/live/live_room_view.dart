import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/utils/overlay_util.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../constants/app_const.dart';
import '../../widgets/empty_tips.dart';
import 'live_room_controller.dart';
import 'widgets/live_chat_widget.dart';
import 'widgets/live_message_widget.dart';
import 'widgets/live_service_widget.dart';
import 'widgets/voice_chat_widget.dart';

const double _kBottomChatNavHeight = 80;

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  @override
  void initState() {
    super.initState();

    OverlayUtil.hide();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 最小化app直播间
  void miniLiveRoom() async {
    final LiveRoomController controller = Get.find<LiveRoomController>();
    final liveRoomDetail = controller.liveRoomDetail.value!;
    controller.miniLiveRoom = true;
    if (await OverlayUtil.show(
      context,
      content: liveRoomDetail.title,
      overlayRoute: AppRoutes.LIVE_ROOM,
      overlayTitle: '直播中',
      overlayAvatar: liveRoomDetail.teacher?.headimg ?? '',
      arguments: {'roomId': liveRoomDetail.id},
    )) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LiveRoomController());
    final LiveRoomController controller = Get.find<LiveRoomController>();

    return Obx(() {
      if (controller.pageLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (controller.liveRoomDetail.value == null) {
        return Center(
          child: EmptyTips(
            title: '获取直播信息失败',
            subTitle: '请返回重新进入',
            spacing: 5,
            child: Column(
              children: [
                const SizedBox(height: 20),
                GradientButton(
                  width: 100,
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('返回'),
                ),
              ],
            ),
          ),
        );
      }

      final liveRoomDetail = controller.liveRoomDetail.value!;
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ImageView.provider(liveRoomDetail.bgimg ?? ''),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black.withAlpha(0),
            leading: SizedBox.shrink(),
            leadingWidth: 0,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Color(0xff262626).withAlpha(50),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.withAlpha(100),
                        foregroundImage: ImageView.provider(
                          liveRoomDetail.teacher?.headimg ?? '',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            liveRoomDetail.teacher?.name ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${liveRoomDetail.lookrum}人气',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Obx(() {
                        final isSub = controller.isTeacherSubscribed.value == 1;
                        if (isSub) {
                          return SizedBox.shrink();
                        }
                        return GradientButton(
                          height: 40,
                          gradient: LinearGradient(
                            colors: [Color(0xffF0D681), Color(0xffB58750)],
                          ),
                          onPressed: () => controller.toggleSubscribe(),
                          child: Text(
                            '关注',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            centerTitle: false,
            actions: [
              _LiveRoomUsers(),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () async {
                  miniLiveRoom();
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xff383838).withAlpha(100),
                  child: Icon(
                    Icons.close_fullscreen,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  final isSub = controller.isTeacherSubscribed.value == 1;
                  DialogUtil.showMenuDialog(
                    context: context,
                    items: [
                      DialogMenuItem(
                        title: '举报',
                        color: Color(0xffD43030),
                        onTap: (_) {},
                      ),
                      if (!isSub)
                        DialogMenuItem(
                          title: '关注并退出',
                          color: Color(0xff8097FF),
                          onTap: (_) async {
                            await controller.toggleSubscribe();
                            Get.back();
                          },
                        ),
                      DialogMenuItem(
                        title: '退出',
                        onTap: (_) {
                          Get.back();
                        },
                      ),
                    ],
                  );
                },
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xff383838).withAlpha(100),
                  child: Icon(Icons.close, size: 22, color: Colors.white),
                ),
              ),
              const SizedBox(width: AppConst.PAGE_PADDING),
            ],
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsetsGeometry.all(AppConst.PAGE_PADDING),
            child: SizedBox.expand(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    spacing: 10,
                    children: [
                      _LivePriceTips(),
                      VoiceChatWidget(),
                      _VoiceChatTime(),
                      LiveServiceWidget(),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 100,
                    bottom:
                    MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom +
                        _kBottomChatNavHeight,
                    child: LiveMessageWidget(),
                  ),
                  Positioned(
                    right: 0,
                    bottom: _kBottomChatNavHeight,
                    child: _LiveVoiceContainer(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: LiveChatWidget(height: _kBottomChatNavHeight),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// 当前直播间用户头像
class _LiveRoomUsers extends StatelessWidget {
  const _LiveRoomUsers({super.key});

  _buildAvatar(String url) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Color(0xffD9D9D9),
      child: CircleAvatar(
        radius: 13,
        backgroundColor: Colors.grey.withAlpha(100),
        foregroundImage: ImageView.provider(url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveRoomController>();
    final users = controller.liveUserList;
    return Obx(() {
      return GestureDetector(
        onTap: () {
          DialogUtil.showModalBottom(
            context: context,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    '在线用户',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onSurface,
                    ),
                  ),
                ),
                Divider(indent: 0.5, height: 0.5, color: Color(0xffF5F7F9)),
              ],
            ),
            builder: (context) {
              return SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.5,
                child: ListView.builder(
                  itemCount: controller.liveUserList.length,
                  itemBuilder: (_, index) {
                    String indexStr = index < 99 ? '${index + 1}' : '99+';
                    final user = controller.liveUserList[index];
                    return ListTile(
                      leading: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Text(
                          indexStr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: index < 3 ? Color(0xfffe6423) : Colors.grey,
                          ),
                        ),
                      ),
                      minLeadingWidth: 0,
                      title: Row(
                        spacing: 10,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.withAlpha(100),
                            foregroundImage: ImageView.provider(
                              user.headimg ?? '',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              user.nickname ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (users.isNotEmpty)
              Row(
                children: [
                  _buildAvatar(users[0].headimg ?? ''),
                  const SizedBox(width: 14),
                ],
              ),
            if (users.length > 1)
              Positioned(left: 14, child: _buildAvatar(users[1].headimg ?? '')),
          ],
        ),
      );
    });
  }
}

/// 顶部连麦价格显示内容
class _LivePriceTips extends StatelessWidget {
  const _LivePriceTips({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveRoomController>();
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff353B66).withAlpha(50),
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Obx(() {
            final teacher = controller.liveRoomDetail.value?.teacher;
            return Row(
              spacing: 10,
              children: [
                Text.rich(
                  TextSpan(
                    text: '普通连麦：',
                    children: [
                      TextSpan(
                        text: '${teacher?.liveprice ?? ''}',
                        style: TextStyle(color: Color(0xffE8CB7A)),
                      ),
                      TextSpan(text: '星钻/分钟'),
                    ],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: '私密连麦：',
                    children: [
                      TextSpan(
                        text: '${teacher?.oliveprice ?? ''}',
                        style: TextStyle(color: Color(0xffE8CB7A)),
                      ),
                      TextSpan(text: '星钻/分钟'),
                    ],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

/// 连麦价格计时区域
class _VoiceChatTime extends StatelessWidget {
  const _VoiceChatTime({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveRoomController>();
    return Obx(() {
      if (controller.connectElapsedSeconds.value <= 0) {
        return const SizedBox.shrink();
      }
      final minutes = (controller.connectElapsedSeconds.value ~/ 60)
          .toString()
          .padLeft(2, '0');
      final seconds = (controller.connectElapsedSeconds.value % 60)
          .toString()
          .padLeft(2, '0');
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff353B66).withAlpha(50),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              spacing: 10,
              children: [
                Text(
                  '${controller.connectTypeText}开始计时：$minutes:$seconds',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: '星钻消耗：',
                    children: [
                      TextSpan(
                        text: controller.connectCost.toStringAsFixed(1),
                        style: TextStyle(color: Color(0xffE8CB7A)),
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

/// 右侧直播语音工具栏区域
class _LiveVoiceContainer extends StatelessWidget {
  const _LiveVoiceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveRoomController>();
    return Column(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () {
            controller.applyVoiceChat(0);
          },
          child: Image.asset(
            'assets/images/live_voice_normal.png',
            width: 60,
            height: 60,
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.applyVoiceChat(1);
          },
          child: Image.asset(
            'assets/images/live_voice_one.png',
            width: 60,
            height: 60,
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     controller.applyVoiceChat(2);
        //   },
        //   child: Image.asset(
        //     'assets/images/live_voice_qa.png',
        //     width: 60,
        //     height: 60,
        //   ),
        // ),
      ],
    );
  }
}
