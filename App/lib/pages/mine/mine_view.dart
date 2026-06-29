import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/component/user_tag.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'mine_controller.dart';

class MinePage extends GetView<MineController> {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MineController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('我的'),
          centerTitle: false,
          backgroundColor: Colors.white.withAlpha(0),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/icons/icon_chat.png',
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.MINE_SETTING);
              },
              child: Image.asset(
                'assets/icons/icon_setting.png',
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(width: AppConst.PAGE_PADDING),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: AppConst.PAGE_PADDING,
            right: AppConst.PAGE_PADDING,
            bottom: AppConst.PAGE_PADDING,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _UserWidget(),
              _UserPoints(),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/mine_teacher_bg.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 76,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          Image.asset(
                            'assets/images/mine_teacher_title.png',
                            width: 120,
                            height: 20,
                          ),
                          Text(
                            '开始崭新的一天',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff97A3BD),
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        final userService = Get.find<UserService>();
                        if (userService.userinfo.value?.utype == 1) {
                          Get.toNamed(AppRoutes.COUNSELOR_INDEX);
                        } else {
                          Get.toNamed(AppRoutes.COUNSELOR_GUIDE);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xff0C1D69),
                        minimumSize: Size(0, 0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide.none,
                        ),
                      ),
                      child: Text('进入'),
                    ),
                  ],
                ),
              ),
              _UserOrder(),
              _MarketWidget(),
              _UserTool(),
              _HotTest(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 用户信息组件
class _UserWidget extends StatelessWidget {
  const _UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MineController>();
    final userService = Get.find<UserService>();
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.MINE_PROFILE);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          spacing: 10,
          children: [
            Obx(() {
              return CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.withAlpha(50),
                foregroundImage: ImageView.provider(
                  userService.userinfo.value?.headimg ?? '',
                  maxWidth: 90,
                  maxHeight: 90,
                ),
              );
            }),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Obx(() {
                    return Text(
                      userService.userinfo.value?.nickname ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                  Wrap(
                    spacing: 10,
                    children: [
                      Obx(() {
                        return UserTag(
                          icon: Icon(
                            Icons.cake,
                            size: 12,
                            color: Color(0xff337EFF),
                          ),
                          title: userService.userinfo.value?.xzname ?? '',
                        );
                      }),
                      Obx(() {
                        return UserTag(
                          title:
                              '等级 LV${userService.userinfo.value?.level.toString()}',
                          color: Color(0xff5E5791),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff696969)),
          ],
        ),
      ),
    );
  }
}

/// 用户积分组件
class _UserPoints extends StatelessWidget {
  const _UserPoints({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Get.find<UserService>();
    const valueStyle = TextStyle(fontSize: 20);
    const titleStyle = TextStyle(fontSize: 14, color: Color(0xff808080));
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.WEALTH_COUPON);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                spacing: 5,
                children: [
                  Obx(() {
                    return Text(
                      '${userService.userinfo.value?.couponcount ?? 0}',
                      style: valueStyle,
                    );
                  }),
                  Text('优惠券', style: titleStyle),
                ],
              ),
            ),
            Column(
              spacing: 5,
              children: [
                Obx(() {
                  return Text(
                    '${userService.userinfo.value?.xbmoney ?? 0}',
                    style: valueStyle,
                  );
                }),
                Text('星币', style: titleStyle),
              ],
            ),
            Column(
              spacing: 5,
              children: [
                Obx(() {
                  return Text(
                    '${userService.userinfo.value?.xzmoney ?? 0}',
                    style: valueStyle,
                  );
                }),
                Text('钱包', style: titleStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 用户订单组件
class _UserOrder extends StatelessWidget {
  const _UserOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '我的订单',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.ORDER_QALIST);
                    },
                    child: Column(
                      spacing: 4,
                      children: [
                        Image.asset(
                          'assets/icons/icon_qa2.png',
                          width: 36,
                          height: 36,
                        ),
                        Text('问答', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.ORDER_TESTLIST);
                    },
                    child: Column(
                      spacing: 4,
                      children: [
                        Image.asset(
                          'assets/icons/icon_cp.png',
                          width: 36,
                          height: 36,
                        ),
                        Text('测评', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.ORDER_VOICELIST);
                    },
                    child: Column(
                      spacing: 4,
                      children: [
                        Image.asset(
                          'assets/icons/icon_lm.png',
                          width: 36,
                          height: 36,
                        ),
                        Text('连麦', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.ORDER_MYTIPSlIST);
                    },
                    child: Column(
                      spacing: 4,
                      children: [
                        Image.asset(
                          'assets/icons/icon_zs.png',
                          width: 36,
                          height: 36,
                        ),
                        Text('赞赏', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 活动星币商城
class _MarketWidget extends StatelessWidget {
  const _MarketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          spacing: 20,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.TASK_CENTER);
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '活动中心',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '完成任务领星币',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffA6A6A6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/icons/icon_activity.png',
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.MALL_CHANGE);
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '星币商城',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '超值物品免费兑',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffA6A6A6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/icons/icon_mall.png',
                      width: 40,
                      height: 40,
                    ),
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

/// 用户工具箱导航
class _UserTool extends StatelessWidget {
  const _UserTool({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              '我的工具',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 90,
              ),
              children: [
                _NavItemWidget(
                  icon: 'icon_gzsc.png',
                  title: '关注收藏',
                  onTap: () {
                    Get.toNamed(AppRoutes.TOOL_FOLLOWLIST);
                  },
                ),
                _NavItemWidget(
                  icon: 'icon_wfb.png',
                  title: '我发布的',
                  onTap: () {
                    Get.toNamed(AppRoutes.TOOL_MYPUBLISH);
                  },
                ),
                _NavItemWidget(
                  icon: 'icon_wdpj.png',
                  title: '我的评价',
                  onTap: () {
                    Get.toNamed(AppRoutes.TOOL_MYEVALUATION);
                  },
                ),
                _NavItemWidget(
                  icon: 'icon_wdda.png',
                  title: '我的档案',
                  onTap: () {
                    Get.toNamed(AppRoutes.TOOL_MYARCHIVE);
                  },
                ),
                _NavItemWidget(
                  icon: 'icon_xl.png',
                  title: '星历',
                  onTap: () {
                    Get.toNamed(AppRoutes.TOOL_CALENDAR);
                  },
                ),
                _NavItemWidget(
                  icon: 'icon_wdlw.png',
                  title: '我的礼物',
                  onTap: () {
                    Get.toNamed(AppRoutes.TOOL_MYGIFT);
                  },
                ),
                _NavItemWidget(
                  icon: 'icon_sh.png',
                  title: '售后',
                  onTap: () {
                    Get.toNamed(AppRoutes.TOOL_SALESSERVICE);
                  },
                ),
                _NavItemWidget(
                  icon: 'icon_zxsrz.png',
                  title: '咨询师入驻',
                  onTap: () {
                    Get.toNamed(AppRoutes.COUNSELOR_GUIDE);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;

  const _NavItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        spacing: 4,
        children: [
          Image.asset('assets/icons/$icon', width: 36, height: 36),
          Text(title, style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

/// 热门测评
class _HotTest extends StatelessWidget {
  const _HotTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              spacing: 4,
              children: [
                Expanded(
                  child: Text(
                    '热门测评',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    '全部测评',
                    style: TextStyle(color: Color(0xffA6A6A6), height: 1),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xffA6A6A6),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                spacing: 10,
                children: List.generate(5, (index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      'https://picsum.photos/200/150?random=$index',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 68,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
