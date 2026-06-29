import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';
import 'notice_list_controller.dart';

class NoticeListPage extends GetView<NoticeListController> {
  const NoticeListPage({super.key});

  _buildItem(context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.COUNSELOR_NOTICE_DETAIL);
      },
      child: Container(
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
            Text('你有的直播收益账单请查收', style: TextStyle(fontSize: 16)),
            Text(
              '你在xxxxx的直播在线xxx分钟，为10位用户解惑答疑，收到了10个好评，有xx位用户给您赞赏了。',
              style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            ),
            Divider(color: Color(0xffF2F2F2)),
            Row(
              spacing: 4,
              children: [
                Text(
                  '2025/11/23  16:23',
                  style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                ),
                const Spacer(),
                CircleAvatar(radius: 4, backgroundColor: Color(0xffFF5454)),
                Text(
                  '点击查看',
                  style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xff808080),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => NoticeListController());

    return Scaffold(
      appBar: AppBar(title: const Text('通知'), backgroundColor: Colors.white),
      body: RefreshLoadmore(
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
            padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
            separatorBuilder: (_, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (_, index) {
              return _buildItem(context);
            },
          );
        }),
      ),
    );
  }
}
