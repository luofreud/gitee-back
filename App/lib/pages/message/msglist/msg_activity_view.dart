import 'package:flutter/material.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import 'msg_activity_controller.dart';

class MsgActivityPage extends GetView<MsgActivityController> {
  const MsgActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MsgActivityController());
    return Scaffold(
      appBar: AppBar(title: Text('活动通知'), backgroundColor: Colors.white),
      body: RefreshLoadmore(
        controller: controller.refreshController,
        onLoad: () async {
          await controller.loadMore();
        },
        child: Obx(() {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConst.PAGE_PADDING,
              vertical: 10,
            ),
            itemCount: controller.listData.length,
            separatorBuilder: (_, index) {
              return SizedBox.shrink();
            },
            itemBuilder: (_, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // todo 跳转到活动通知详情
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://picsum.photos/200/100?random=$index',
                              width: double.infinity,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Text(
                                    '许愿活动：爱情一线牵，珍惜这道缘珍惜这道缘珍惜这道缘。',
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    spacing: 5,
                                    children: [
                                      CircleAvatar(radius: 10),
                                      Text(
                                        '宝瓶星座',
                                        style: TextStyle(
                                          color: Color(0xff808080),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '2025/12/12',
                      style: TextStyle(color: Color(0xffA6A6A6)),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
