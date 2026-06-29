import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import '../../../widgets/component/user_tag.dart';
import '../../../widgets/gradient_button.dart';
import 'evaluation_detail_controller.dart';

class EvaluationDetailPage extends GetView<EvaluationDetailController> {
  const EvaluationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => EvaluationDetailController());

    return Scaffold(
      appBar: AppBar(
        title: Text('评价详情'),
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(color: Color(0xffF5F7F9), width: 1),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          spacing: 10,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                foregroundImage: const AssetImage(
                  'assets/example/home_item_image.png',
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    '一个了不起的人',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  UserTag(title: '等级 LV1', color: Color(0xff5E5791)),
                ],
              ),
              contentPadding: EdgeInsets.zero,
              trailing: Text(
                '2025/12/25',
                style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
              ),
            ),
            Text('这是对订单的评价，这是对订单的评价，这是对订单的评价。', style: TextStyle(fontSize: 16)),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffE5E5E5)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        style: TextStyle(fontSize: 12),
                        TextSpan(
                          children: [
                            TextSpan(text: '免费：'),
                            TextSpan(text: '3', style: TextStyle(fontSize: 20)),
                            TextSpan(text: ' 分钟'),
                          ],
                        ),
                      ),
                      Text.rich(
                        style: TextStyle(fontSize: 12),
                        TextSpan(
                          children: [
                            TextSpan(text: '付费：'),
                            TextSpan(text: '6', style: TextStyle(fontSize: 20)),
                            TextSpan(text: ' 分钟'),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text.rich(
                        style: TextStyle(fontSize: 12),
                        TextSpan(
                          children: [
                            TextSpan(text: '消费 '),
                            TextSpan(
                              text: '32.1',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xffFF5733),
                              ),
                            ),
                            TextSpan(text: ' 星钻'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xffF5F7F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    child: DefaultTextStyle(
                      style: TextStyle(color: Color(0xffA6A6A6), fontSize: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Text('购买项目：直播连麦咨询'),
                          Text('订单时间：2025/11/23  12:00'),
                          Text('订单编号：xxxxxxxxxxxxxxxxx'),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 20,
                      foregroundImage: const AssetImage(
                        'assets/example/home_item_image.png',
                      ),
                    ),
                    horizontalTitleGap: 10,
                    minTileHeight: 30,
                    title: Text('白日依山尽'),
                    subtitle: Text(
                      '5.2星钻/分钟',
                      style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                    ),
                    trailing: GradientButton(
                      onPressed: () {},
                      gradient: LinearGradient(
                        colors: [Color(0xffECE3FF), Color(0xffE3EAFF)],
                      ),
                      foregroundColor: Color(0xff2F4791),
                      isRadius: false,
                      child: Text('再次连麦'),
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
