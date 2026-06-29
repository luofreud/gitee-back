import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'counselor_live_index_controller.dart';

class CounselorLiveIndexPage extends GetView<CounselorLiveIndexController> {
  const CounselorLiveIndexPage({super.key});

  _buildDataCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 12,
        children: [
          Row(
            children: [
              Text('今日'),
              const Spacer(),
              Text('更多数据', style: TextStyle(color: Color(0xff808080))),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded, size: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('140', style: TextStyle(fontSize: 18)),
                  Text(
                    '收益(星钻)',
                    style: TextStyle(color: Color(0xff808080), fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('22', style: TextStyle(fontSize: 18)),
                  Text(
                    '咨询用户数',
                    style: TextStyle(color: Color(0xff808080), fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('23', style: TextStyle(fontSize: 18)),
                  Text(
                    '新增粉丝',
                    style: TextStyle(color: Color(0xff808080), fontSize: 12),
                  ),
                ],
              ),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: '64',
                      style: TextStyle(fontSize: 18),
                      children: [
                        TextSpan(text: ' 分钟', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(
                    '开播时长',
                    style: TextStyle(color: Color(0xff808080), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildLiveService() {
    final controller = Get.find<CounselorLiveIndexController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 20,
        children: [
          Row(
            children: [
              Text(
                '直播服务',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () {},
                child: Column(
                  spacing: 5,
                  children: [
                    IconWidget(icon: 'counselor_live_setting.png', size: 32),
                    Text(
                      '直播设置',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  spacing: 5,
                  children: [
                    IconWidget(icon: 'counselor_live_zbzd.png', size: 32),
                    Text(
                      '主播账单',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  spacing: 5,
                  children: [
                    IconWidget(icon: 'counselor_live_aqzx.png', size: 32),
                    Text(
                      '安全中心',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  spacing: 5,
                  children: [
                    IconWidget(icon: 'counselor_live_rzxy.png', size: 32),
                    Text(
                      '直播协议',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CounselorLiveIndexController());

    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('直播中心'),
          backgroundColor: Colors.white.withAlpha(0),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConst.PAGE_PADDING,
          ),
          child: Obx(() {
            final lastLiveRoom = controller.lastLiveRoom.value;
            return Column(
              spacing: 15,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    CircleAvatar(radius: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '用户昵称',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'zhibo',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff808080),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (lastLiveRoom == null || lastLiveRoom.state == 2)
                      GradientButton(
                        height: 32,
                        textStyle: TextStyle(fontSize: 14),
                        gradient: LinearGradient(
                          colors: [Color(0xffFEA17D), Color(0xffFD6B57)],
                        ),
                        onPressed: () async {
                          await Get.toNamed(AppRoutes.COUNSELOR_LIVE_CREATE);
                          controller.loadRoom();
                        },
                        child: Text('去开播'),
                      ),
                  ],
                ),
                if (lastLiveRoom != null && lastLiveRoom.state != 2)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lastLiveRoom.title ?? ''),
                              Text(
                                '直播进行中',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff808080),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GradientButton(
                          height: 32,
                          gradient: LinearGradient(
                            colors: [Color(0xfff5f7f9), Color(0xfff5f7f9)],
                          ),
                          onPressed: () => controller.closeCurrentRoom(),
                          child: Text(
                            '结束直播',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff383838),
                            ),
                          ),
                        ),
                        GradientButton(
                          height: 32,
                          textStyle: TextStyle(fontSize: 14),
                          gradient: LinearGradient(
                            colors: [Color(0xffFEA17D), Color(0xffFD6B57)],
                          ),
                          onPressed: () async {
                            await Get.toNamed(
                              AppRoutes.COUNSELOR_LIVE_ROOM,
                              arguments: {"roomId": lastLiveRoom.id},
                            );
                            controller.loadRoom();
                          },
                          child: Text('继续直播'),
                        ),
                      ],
                    ),
                  ),
                _buildDataCard(),
                _buildLiveService(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
