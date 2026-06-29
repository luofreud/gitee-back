import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import 'notice_detail_controller.dart';

class NoticeDetailPage extends GetView<NoticeDetailController> {
  const NoticeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => NoticeDetailController());
    return Scaffold(
      appBar: AppBar(
        title: Text('通知详情'),
        backgroundColor: Colors.white,
        shape: Border(bottom: BorderSide(color: Color(0xffF5F7F9), width: 1)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              '你有的直播收益账单请查收',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '2025/11/23  16:23',
              style: TextStyle(color: Color(0xffA6A6A6)),
            ),
            Text('你在xxxxx的直播在线xxx分钟，为10位用户解惑答疑，收到了10个好评，有xx位用户给您赞赏了。'),
          ],
        ),
      ),
    );
  }
}
