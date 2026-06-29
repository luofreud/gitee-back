import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:get/get.dart';

import 'task_center_controller.dart';

class TaskCenterPage extends GetView<TaskCenterController> {
  const TaskCenterPage({super.key});

  _buildSignContainer() {
    final userService = Get.find<UserService>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Obx(() {
            return Text.rich(
              TextSpan(
                text: '已连续签到',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: '${controller.continuousDay}',
                    style: TextStyle(color: Color(0xffFF9354)),
                  ),
                  TextSpan(text: '天'),
                ],
              ),
            );
          }),
          Text(
            '连续签到7天、30天可以获得额外奖励！',
            style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
          ),
          const SizedBox(height: 5),
          Row(
            spacing: 5,
            children: List.generate(7, (index) {
              return Expanded(
                child: Obx(() {
                  final isSign = index < controller.continuousDay.value;
                  final isSeven = index == 6;
                  return Column(
                    spacing: 2,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isSeven
                              ? Color(0xffFFFAE3)
                              : Color(0xffFAFAFF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        constraints: BoxConstraints(maxWidth: 40),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          spacing: 3,
                          children: [
                            Text(
                              isSeven ? '+10' : '+5',
                              style: TextStyle(
                                color: isSign
                                    ? Color(0xff6B6BFF)
                                    : Color(0xffA6A6A6),
                              ),
                            ),
                            isSeven
                                ? IconWidget(
                                    icon: 'icon_check_lw.png',
                                    size: 24,
                                  )
                                : Icon(
                                    Icons.check_circle,
                                    color: isSign
                                        ? Color(0xff6B6BFF)
                                        : Color(0xffcccccc),
                                  ),
                          ],
                        ),
                      ),
                      Text(
                        isSign ? '已签到' : '第${index + 1}天',
                        style: TextStyle(
                          color: Color(0xffA6A6A6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  _buildAdNav() {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [Color(0xffB978FF), Color(0xffE482FF)],
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 3,
                    children: [
                      Text(
                        '智慧牌',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '点击查看日签',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset('assets/images/tlp_ch.png', width: 84, height: 47),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [Color(0xffFFE2D1), Color(0xffFFECC9)],
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 3,
                    children: [
                      Text(
                        '星币商城',
                        style: TextStyle(
                          color: Color(0xffFF8641),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '超值物品免费兑',
                        style: TextStyle(
                          color: Color(0xffFF8641),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconWidget(icon: 'icon_mall.png', size: 40),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TaskCenterController());
    final userService = Get.find<UserService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('任务中心'),
        actions: [
          GestureDetector(onTap: () {}, child: Text('星币明细')),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/task_center_top_bg.png'),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Obx(() {
                    return Text.rich(
                      TextSpan(
                        text:
                            userService.userinfo.value?.xbmoney?.toString() ??
                            '0',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(text: '星币', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    if (controller.todayCheck.value) {
                      return Image.asset(
                        'assets/images/task_center_btn_signed.png',
                        width: 115,
                        height: 36,
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        controller.onCheck();
                      },
                      child: Image.asset(
                        'assets/images/task_center_btn_sign.png',
                        width: 115,
                        height: 36,
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
              child: Transform.translate(
                offset: Offset(0, -20),
                child: Column(
                  spacing: 10,
                  children: [
                    _buildSignContainer(),
                    _buildAdNav(),
                    _TaskListContainer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskListContainer extends StatefulWidget {
  const _TaskListContainer({super.key});

  @override
  State<_TaskListContainer> createState() => _TaskListContainerState();
}

class _TaskListContainerState extends State<_TaskListContainer>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskCenterController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          TabBar(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            dividerHeight: 0,
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
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Color(0Xff4D1FAE), width: 3),
              borderRadius: BorderRadius.circular(4),
              insets: EdgeInsets.symmetric(horizontal: 22, vertical: 2),
            ),
            tabs: [
              Tab(text: '每日任务'),
              Tab(text: '新人任务'),
            ],
            controller: _tabController,
          ),
          Obx(() {
            int index = _tabController?.index ?? 0;
            final list = index == 0
                ? controller.dailyTask.value
                : controller.newUserTask.value;
            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: EmptyTips(
                  leading: Icon(
                    Icons.tips_and_updates_outlined,
                    size: 64,
                    color: Color(0xffd5d5d5).withAlpha(200),
                  ),
                  subTitle: '暂无任务',
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xffFFF8F5),
                    radius: 20,
                  ),
                  minLeadingWidth: 0,
                  title: Text('发布一条帖子并关联话题', style: TextStyle(fontSize: 14)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  subtitle: Row(
                    spacing: 3,
                    children: [
                      IconWidget(icon: 'icon_gold_coin.png', size: 18),
                      Text(
                        '+10',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffFF9354),
                        ),
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xffFFF8F5),
                        foregroundColor: Color(0xffFF792C),
                        side: BorderSide.none,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      child: Text('去完成', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
