import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/live/live_connect_record.dart';
import 'package:freud/models/user/userinfo.dart';
import 'package:freud/pages/counselor/live/widgets/live_room_notice.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/utils/overlay_util.dart';
import 'package:freud/widgets/common/fixed_tab_indicator.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import 'counselor_live_room_controller.dart';
import 'widgets/live_chat_widget.dart';
import 'widgets/live_message_widget.dart';
import 'widgets/voice_chat_widget.dart';

const double _kBottomChatNavHeight = 80;

class CounselorLiveRoomPage extends StatefulWidget {
  const CounselorLiveRoomPage({super.key});

  @override
  State<CounselorLiveRoomPage> createState() => _CounselorLiveRoomPageState();
}

class _CounselorLiveRoomPageState extends State<CounselorLiveRoomPage> {
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
    final controller = Get.find<CounselorLiveRoomController>();
    final liveRoomDetail = controller.liveRoomDetail.value!;
    controller.miniLiveRoom = true;

    if (await OverlayUtil.show(
      context,
      content: liveRoomDetail.title,
      overlayRoute: AppRoutes.COUNSELOR_LIVE_ROOM,
      overlayTitle: '等待连麦',
      overlayAvatar: liveRoomDetail.teacher?.headimg ?? '',
      arguments: {'roomId': liveRoomDetail.id},
    )) {
      Get.back();
    }
  }

  // 关闭直播间
  void closeRoom() {
    final controller = Get.find<CounselorLiveRoomController>();
    DialogUtil.showMenuDialog(
      context: context,
      items: [
        DialogMenuItem(
          title: '立即下播',
          color: Color(0xffD43030),
          onTap: (_) {
            controller.leaveLiveRoom();
            Get.back();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CounselorLiveRoomController());
    final controller = Get.find<CounselorLiveRoomController>();

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
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/live_room_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            PopScope(
              canPop: false,
              onPopInvokedWithResult: (canPop, __) {
                if (canPop == false) {
                  closeRoom();
                }
              },
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
                            Obx(() {
                              final teacher =
                                  controller.liveRoomDetail.value?.teacher;
                              return CircleAvatar(
                                radius: 20,
                                foregroundImage: ImageView.provider(
                                  teacher?.headimg ?? '',
                                ),
                              );
                            }),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.likeNumber.value}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '本场点赞',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  centerTitle: false,
                  actions: [
                    Text(
                      '${controller.liveUserNumber.value}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
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
                        closeRoom();
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xff383838).withAlpha(100),
                        child: Icon(
                          Icons.power_settings_new,
                          size: 22,
                          color: Colors.white,
                        ),
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
                          ],
                        ),
                        Positioned(
                          left: 0,
                          right: 100,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom +
                              _kBottomChatNavHeight,
                          child: LiveMessageWidget(),
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
            ),
            LiveRoomNotice(controller: controller.noticeController),
          ],
        ),
      );
    });
  }
}

/// 当前直播间用户头像
class _LiveRoomUsers extends StatefulWidget {
  const _LiveRoomUsers({super.key});

  @override
  State<_LiveRoomUsers> createState() => _LiveRoomUsersState();
}

class _LiveRoomUsersState extends State<_LiveRoomUsers>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  _buildAvatar(String url) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Color(0xffD9D9D9),
      child: CircleAvatar(
        radius: 13,
        backgroundColor: Colors.grey.withAlpha(100),
        foregroundImage: ImageView.provider(url ?? ''),
      ),
    );
  }

  _buildOnlineUser(int index, Userinfo user) {
    String indexStr = index < 99 ? '${index + 1}' : '99+';
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
            foregroundImage: ImageView.provider(user?.headimg ?? ''),
          ),
          Expanded(
            child: Text(user?.nickname ?? '', overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  _buildConnectUser(int index, LiveConnectRecord record) {
    final controller = Get.find<CounselorLiveRoomController>();
    String indexStr = index < 99 ? '${index + 1}' : '99+';
    final user = record.user;
    List<Widget> _actions = [];
    if (record.state == 1) {
      _actions = [
        GradientButton(
          onPressed: () => controller.updateImLogState(record, 2),
          height: 26,
          padding: EdgeInsets.symmetric(horizontal: 0),
          textStyle: TextStyle(fontSize: 12),
          child: Text('断开连麦'),
        ),
      ];
    } else {
      _actions = [
        GradientButton(
          onPressed: () => controller.updateImLogState(record, 4),
          height: 26,
          width: 50,
          gradient: LinearGradient(
            colors: [Color(0xffF5F7F9), Color(0xffF5F7F9)],
          ),
          padding: EdgeInsets.symmetric(horizontal: 0),
          textStyle: TextStyle(fontSize: 12),
          foregroundColor: Color(0xff383838),
          child: Text('拒绝'),
        ),
        GradientButton(
          onPressed: () => controller.updateImLogState(record, 1),
          height: 26,
          width: 50,
          padding: EdgeInsets.symmetric(horizontal: 0),
          textStyle: TextStyle(fontSize: 12),
          child: Text('同意'),
        ),
      ];
    }
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
            foregroundImage: ImageView.provider(user?.headimg ?? ''),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.nickname ?? '', overflow: TextOverflow.ellipsis),
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xff7961fe),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '普通连麦',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xffffffff),
                          height: 1,
                        ),
                      ),
                    ),
                    if (record.state == 1)
                      Text(
                        '连麦中',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff999999),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          ..._actions,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorLiveRoomController>();
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(0, duration: Duration.zero);
        controller.getLiveRoomUsers();
        controller.getLiveConnectUsers();
        DialogUtil.showModalBottom(
          context: context,
          padding: EdgeInsets.zero,
          child: TabBar(
            controller: _tabController,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            dividerHeight: 0.5,
            dividerColor: Color(0xffF5F7F9),
            unselectedLabelColor: Color(0xff7986B0),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            labelColor: Colors.black,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            indicator: FixedTabIndicator(
              borderSide: BorderSide(color: Color(0Xff4D1FAE), width: 4),
              borderRadius: BorderRadius.circular(2),
              width: 20,
            ),
            indicatorPadding: EdgeInsets.symmetric(vertical: 0),
            onTap: (index) {
              _pageController.jumpToPage(index);
            },
            tabs: [
              Tab(text: '在线用户'),
              Tab(text: '连麦用户'),
            ],
          ),
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView.builder(
                itemCount: 2,
                controller: _pageController,
                onPageChanged: (index) {
                  _tabController.animateTo(index);
                },
                itemBuilder: (_, pageIndex) {
                  return Obx(() {
                    final dataCount = pageIndex == 1
                        ? controller.liveConnectUserList.length
                        : controller.liveUserList.length;
                    return ListView.builder(
                      itemCount: dataCount,
                      itemBuilder: (_, index) {
                        if (pageIndex == 1) {
                          final record = controller.liveConnectUserList[index];
                          return _buildConnectUser(index, record);
                        } else {
                          final user = controller.liveUserList[index];
                          return _buildOnlineUser(index, user);
                        }
                      },
                    );
                  });
                },
              ),
            );
          },
        );
      },
      child: Obx(() {
        final users = controller.liveUserList;
        return Stack(
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
        );
      }),
    );
  }
}

/// 顶部连麦价格显示内容
class _LivePriceTips extends StatelessWidget {
  const _LivePriceTips({super.key});

  @override
  Widget build(BuildContext context) {
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
              Text.rich(
                TextSpan(
                  text: '普通连麦：',
                  children: [
                    TextSpan(
                      text: '12',
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
                      text: '13',
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
          ),
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
    final controller = Get.find<CounselorLiveRoomController>();
    return Obx(() {
      if (controller.connectElapsedSeconds.value <= 0) {
        return const SizedBox.shrink();
      }
      final minutes = (controller.connectElapsedSeconds.value ~/ 60)
          .toString()
          .padLeft(2, '0');
      final seconds =
          (controller.connectElapsedSeconds.value % 60)
              .toString()
              .padLeft(2, '0');
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              spacing: 10,
              children: [
                Text.rich(
                  TextSpan(
                    text: '${controller.connectTypeText}开始计时：',
                    children: [
                      TextSpan(
                        text: '$minutes:$seconds',
                        style: const TextStyle(color: Color(0xff2A82E4)),
                      ),
                    ],
                    style: const TextStyle(fontSize: 10, height: 1),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: '星钻消耗：',
                    children: [
                      TextSpan(
                        text: controller.connectCost.toStringAsFixed(1),
                        style: const TextStyle(color: Color(0xffFF6B4A)),
                      ),
                    ],
                    style: const TextStyle(fontSize: 10, height: 1),
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
