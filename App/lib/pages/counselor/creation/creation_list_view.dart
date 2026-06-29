import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import 'creation_list_controller.dart';

class CreationListPage extends GetView<CreationListController> {
  const CreationListPage({super.key});

  _buildItem(context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  'https://picsum.photos/300/200',
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      '你在xxxxx的直播在线xxx分钟，为10位用户解惑答疑。',
                      style: TextStyle(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '2025年11月21日  12:12',
                      style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              var scaleX = constraints.maxWidth / (constraints.maxWidth - 24);
              return Transform.scale(
                scaleX: scaleX,
                child: Divider(color: Color(0xffF2F2F2)),
              );
            },
          ),
          Row(
            spacing: 4,
            children: [
              IconWidget(icon: 'icon_view.png', size: 18),
              Text(
                '999',
                style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
              ),
              const SizedBox(width: 5),
              IconWidget(icon: 'icon_comment3.png', size: 18),
              Text(
                '999',
                style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
              ),
              const SizedBox(width: 5),
              IconWidget(icon: 'icon_zan4.png', size: 18),
              Text(
                '999',
                style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
              ),
              const SizedBox(width: 5),
              IconWidget(icon: 'icon_start.png', size: 18),
              Text(
                '999',
                style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  DialogUtil.showMenuDialog(
                    context: context,
                    items: [
                      DialogMenuItem(title: '编辑', onTap: (_) {}),
                      DialogMenuItem(title: '删除', onTap: (_) {}),
                    ],
                  );
                },
                child: Icon(Icons.more_horiz, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CreationListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('创作管理'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Color(0xff808080),
              overlayColor: Colors.transparent,
            ),
            child: Text('草稿箱'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(AppConst.PAGE_PADDING),
            child: OutlinedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.COUNSELOR_CREATION_CONTENT);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundBuilder: (context, states, Widget? child) {
                  return Ink(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/btn_creation_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: child,
                  );
                },
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  Transform.rotate(
                    angle: -45 * pi / 180,
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  Text(
                    '开始创作',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshLoadmore(
              controller: controller.refreshController,
              onRefresh: () async {
                await controller.listRefresh();
              },
              onLoad: () async {
                await controller.loadMore();
              },
              child: Obx(() {
                return ListView.separated(
                  itemCount: controller.listData.length,
                  padding: const EdgeInsets.only(
                    left: AppConst.PAGE_PADDING,
                    right: AppConst.PAGE_PADDING,
                    bottom: AppConst.PAGE_PADDING,
                  ),
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (_, index) {
                    return _buildItem(context);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
