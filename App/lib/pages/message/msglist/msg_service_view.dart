import 'package:flutter/material.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import 'msg_service_controller.dart';

class MsgServicePage extends GetView<MsgServiceController> {
  const MsgServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MsgServiceController());
    return Scaffold(
      appBar: AppBar(title: Text('服务消息'), backgroundColor: Colors.white),
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
              return SizedBox(height: 10);
            },
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  // todo 跳转到服务消息详情
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '许愿活动：爱情一线牵，珍惜这道缘珍惜这道缘珍惜这道缘。',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '免费连麦券就要到期了，全场咨询师均可以进行连麦体验。新人专属福利，快来试试吧。',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xffA6A6A6),
                          ),
                        ),
                        Divider(color: Color(0xffF2F2F2)),
                        Row(
                          spacing: 5,
                          children: [
                            Text(
                              '2025/11/23  16:23',
                              style: TextStyle(
                                color: Color(0xff808080),
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            if (index == 0)
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 3.5,
                              ),
                            Text(
                              '点击查看',
                              style: TextStyle(
                                color: Color(0xff808080),
                                fontSize: 12,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: Color(0xff808080),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
