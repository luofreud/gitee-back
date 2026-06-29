import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import 'qa_order_controller.dart';

class QaOrderPage extends GetView<QaOrderController> {
  const QaOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => QaOrderController());
    return Scaffold(
      appBar: AppBar(title: const Text('问答'), backgroundColor: Colors.white),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: controller.tabController,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              dividerHeight: 0,
              // tabAlignment: TabAlignment.start,
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
                insets: EdgeInsets.all(5),
              ),
              tabs: controller.qaTypes.map((item) {
                return Tab(text: item);
              }).toList(),
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
                  padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (_, index) {
                    return _DiceItem();
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

class _DiceItem extends StatelessWidget {
  const _DiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        spacing: 10,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(radius: 20),
            horizontalTitleGap: 10,
            minTileHeight: 30,
            title: Text('白日依山尽'),
            subtitle: Text(
              '5.2星钻/分钟',
              style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            ),
            trailing: Transform.translate(
              offset: Offset(10, 0),
              child: IconButton(
                onPressed: () {
                  DialogUtil.showMenuDialog(
                    context: context,
                    items: [
                      DialogMenuItem(
                        title: '投诉',
                        onTap: (_) async {
                          Get.toNamed(
                            AppRoutes.MINE_COMPLAINT,
                            arguments: {"ctype": 0, "data": {}},
                          );
                        },
                      ),
                      DialogMenuItem(title: '删除', onTap: (_) {}),
                    ],
                  );
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                icon: CircleAvatar(
                  backgroundColor: Color(0xffF5F7F9),
                  radius: 11,
                  child: Icon(
                    Icons.more_horiz,
                    color: Color(0xff808080),
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
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
                      style: TextStyle(fontSize: 20, color: Color(0xffFF5733)),
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
                  Text('骰子提问：这是我问的问题。'),
                  Text('订单时间：2025/11/23  12:00'),
                  Text('订单编号：xxxxxxxxxxxxxxxxx'),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text('已完成', style: TextStyle(color: Color(0xffA6A6A6))),
              Spacer(),
              GradientButton(
                onPressed: () {},
                gradient: LinearGradient(
                  colors: [Color(0xffECE3FF), Color(0xffE3EAFF)],
                ),
                isRadius: false,
                height: 28,
                textStyle: TextStyle(fontSize: 14),
                child: Text('再次咨询', style: TextStyle(color: Color(0xff334D9C))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
