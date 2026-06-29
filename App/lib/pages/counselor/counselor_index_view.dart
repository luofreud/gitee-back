import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'counselor_index_controller.dart';

class CounselorIndexPage extends GetView<CounselorIndexPage> {
  const CounselorIndexPage({super.key});

  _buildCard({Widget? child, EdgeInsetsGeometry? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: padding ?? EdgeInsets.all(12),
      child: child,
    );
  }

  _buildToolNav() {
    final textStyle = TextStyle(fontSize: 12, color: Colors.black);
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '常用服务',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.COUNSELOR_CREATION_INDEX);
                },
                child: Column(
                  spacing: 3,
                  children: [
                    IconWidget(icon: 'counselor_service_cczx.png', size: 32),
                    Text('创作中心', style: textStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.COUNSELOR_COMMENT);
                },
                child: Column(
                  spacing: 3,
                  children: [
                    IconWidget(icon: 'counselor_service_hdgl.png', size: 32),
                    Text('互动管理', style: textStyle),
                  ],
                ),
              ),
              GestureDetector(
                child: Column(
                  spacing: 3,
                  children: [
                    IconWidget(icon: 'counselor_service_fsgl.png', size: 32),
                    Text('粉丝管理', style: textStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.COUNSELOR_REVENUE_INDEX);
                },
                child: Column(
                  spacing: 3,
                  children: [
                    IconWidget(icon: 'counselor_service_syzx.png', size: 32),
                    Text('收益中心', style: textStyle),
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
    Get.lazyPut(() => CounselorIndexController());

    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('咨询师中心'),
          backgroundColor: Colors.white.withAlpha(0),
        ),
        backgroundColor: Colors.transparent,

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConst.PAGE_PADDING,
          ),
          child: Column(
            spacing: 12,
            children: [
              _buildCard(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: _UserInfoContainer(),
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Image.asset('assets/images/counselor_dt.png'),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.COUNSELOR_LIVE_INDEX);
                      },
                      child: Image.asset('assets/images/counselor_zb.png'),
                    ),
                  ),
                ],
              ),
              _buildToolNav(),
              _buildCard(child: _UserDataContainer()),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserInfoContainer extends StatelessWidget {
  const _UserInfoContainer({super.key});

  _buildUserTag(String text) {
    var color1 = [
      Color(0xffedfff8),
      Color(0xff8FFFD4),
      Color(0xff38DBFF),
      Color(0xff07C1DE),
    ];
    var color2 = [
      Color(0xffEDF7FF),
      Color(0xff8FDAFF),
      Color(0xff3895FF),
      Color(0xff46A0FF),
    ];
    var color3 = [
      Color(0xffF2EDFF),
      Color(0xff8FBCFF),
      Color(0xff9538FF),
      Color(0xff944BFF),
    ];
    var color = color1;
    if (text == '问答达人') {
      color = color1;
    } else if (text == '专业咨询师') {
      color = color2;
    } else if (text == '资深咨询师') {
      color = color3;
    }
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: color[0],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 2, top: 2, right: 8, bottom: 2),
      child: Row(
        spacing: 5,
        children: [
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [color[1], color[2]],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: IconWidget(icon: 'icon_c_type.png', size: 10),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: color[3], height: 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Row(
            spacing: 12,
            children: [
              CircleAvatar(
                radius: 26,
                foregroundImage: AssetImage(
                  'assets/example/home_item_image.png',
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(
                      '这是一个帅气的名字',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Row(children: [_buildUserTag('资深咨询师')]),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Color(0xff3d56c4), size: 16),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.COUNSELOR_NOTICE);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xfffff2f2),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              spacing: 5,
              children: [
                Icon(Icons.notifications, size: 18, color: Color(0xffffb5b5)),
                Expanded(
                  child: Text(
                    '重要通知',
                    style: TextStyle(color: Color(0xfff56969)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xffffb5b5),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              child: Column(
                children: [
                  Text('56', style: TextStyle(fontSize: 20)),
                  Text(
                    '粉丝数',
                    style: TextStyle(fontSize: 14, color: Color(0xff808080)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Column(
                children: [
                  Text('1564', style: TextStyle(fontSize: 20)),
                  Text(
                    '浏览量',
                    style: TextStyle(fontSize: 14, color: Color(0xff808080)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Column(
                children: [
                  Text('156', style: TextStyle(fontSize: 20)),
                  Text(
                    '创作数',
                    style: TextStyle(fontSize: 14, color: Color(0xff808080)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UserDataContainer extends StatelessWidget {
  const _UserDataContainer({super.key});

  Widget _buildItem({
    required String title,
    required String value,
    required String todayValue,
  }) {
    return Column(
      spacing: 6,
      children: [
        Row(
          spacing: 2,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Color(0xff808080),
                height: 1,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 8),
          ],
        ),
        Text(value),
        Text.rich(
          TextSpan(
            text: '昨日 ',
            style: TextStyle(fontSize: 10, color: Color(0xff808080), height: 1),
            children: [
              TextSpan(
                text: todayValue,
                style: TextStyle(color: Color(0xffFA461E), height: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounselorIndexController());
    return Column(
      spacing: 15,
      children: [
        Row(
          spacing: 2,
          children: [
            Text(
              '数据中心',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.COUNSELOR_REPORT);
              },
              child: Text(
                '更多数据',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff808080),
                  height: 1,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xff383838)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: controller.data1Items.map((item) {
            return _buildItem(
              title: item["title"].toString(),
              value: item["value"].toString(),
              todayValue: item["todayValue"].toString(),
            );
          }).toList(),
        ),
        const SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: controller.data2Items.map((item) {
            return _buildItem(
              title: item["title"].toString(),
              value: item["value"].toString(),
              todayValue: item["todayValue"].toString(),
            );
          }).toList(),
        ),
      ],
    );
  }
}
