import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'creation_index_controller.dart';

class CreationIndexPage extends GetView<CreationIndexController> {
  const CreationIndexPage({super.key});

  _buildUserInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              const SizedBox(width: 2),
              CircleAvatar(radius: 20),
              Expanded(child: Text('这是一个帅气的名字')),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.COUNSELOR_CREATION_LIST);
                },
                child: Image.asset(
                  'assets/images/btn_creation_manage.png',
                  width: 89,
                  height: 28,
                ),
              ),
              const SizedBox(width: 2),
            ],
          ),
          Divider(color: Color(0xffF5F7F9)),
          const SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              const SizedBox(width: 2),
              Text(
                '320',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('互动分', style: TextStyle(fontSize: 12)),
              ),
              const Spacer(),
              Text('当前排名：10', style: TextStyle(fontSize: 12, height: 1)),
              Icon(Icons.arrow_forward_ios, size: 12),
              const SizedBox(width: 2),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
            height: 24,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xffF5F0FF),
            ),
            child: Text(
              '互动分排名结算时间： 2025.05.20  4:00',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xffB894FF),
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTaskCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/title_tgdhdf.png', width: 116, height: 28),
          ListTile(
            leading: Container(
              width: 42,
              height: 52,
              decoration: BoxDecoration(
                color: Color(0xffFAFAFF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+10',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff6481A3),
                    ),
                  ),
                  IconWidget(icon: 'icon_start4.png', size: 23),
                ],
              ),
            ),
            title: Text('发布一条星座知识文章'),
            subtitle: Text(
              '每日首次发布',
              style: TextStyle(fontSize: 12, color: Color(0xff808080)),
            ),
            trailing: Text(
              '0/1',
              style: TextStyle(fontSize: 12, color: Color(0xff808080)),
            ),
          ),
          ListTile(
            leading: Container(
              width: 42,
              height: 52,
              decoration: BoxDecoration(
                color: Color(0xffFAFAFF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+10',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff6481A3),
                    ),
                  ),
                  IconWidget(icon: 'icon_start4.png', size: 23),
                ],
              ),
            ),
            title: Text('发布一道测试题'),
            subtitle: Text(
              '发布一条星座/人格测试问题',
              style: TextStyle(fontSize: 12, color: Color(0xff808080)),
            ),
            trailing: Text(
              '0/1',
              style: TextStyle(fontSize: 12, color: Color(0xff808080)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CreationIndexController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('创作中心'),
          backgroundColor: Colors.white.withAlpha(0),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConst.PAGE_PADDING,
          ),
          child: Column(
            spacing: 10,
            children: [_buildUserInfo(), _buildTaskCard()],
          ),
        ),
      ),
    );
  }
}
