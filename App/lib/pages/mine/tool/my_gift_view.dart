import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'my_gift_controller.dart';

class MyGiftPage extends GetView<MyGiftController> {
  const MyGiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MyGiftController());
    return Scaffold(
      appBar: AppBar(
        title: Text('我的礼物'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(AppRoutes.TOOL_ADDRESSMANAGE);
            },
            style: TextButton.styleFrom(overlayColor: Colors.transparent),
            child: Text(
              '收货地址',
              style: TextStyle(color: Color(0xff383838), fontSize: 14),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: controller.tabController,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerHeight: 0,
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
                  insets: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                ),
                tabs: controller.headerNavTabs.map((item) {
                  return Tab(text: item);
                }).toList(),
              ),
            ),
            if (controller.listData.isEmpty) Expanded(child: _GiftEmptyPage()),
            if (controller.listData.length > 0)
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [_GiftPage(), _GiftPage(isShipped: true)],
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _GiftEmptyPage extends StatelessWidget {
  const _GiftEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Text('暂无可以领取的礼物', style: TextStyle(fontSize: 16)),
        Text(
          '充值星钻免费领定制手串',
          style: TextStyle(fontSize: 14, color: Color(0xffA6A6A6)),
        ),
        const SizedBox(height: 5),
        GradientButton(
          onPressed: () {},
          height: 28,
          width: 80,
          isRadius: false,
          foregroundColor: Color(0xff2F4791),
          gradient: LinearGradient(
            colors: [Color(0xffECE3FF), Color(0xffE3EAFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          child: Text('去领取', style: TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}

class _GiftPage extends StatelessWidget {
  final bool isShipped;

  const _GiftPage({super.key, this.isShipped = false});

  _buildItem(context) {
    Widget status = Text(
      '等待发货',
      style: TextStyle(fontSize: 14, color: Color(0xff2A82E4)),
    );
    if (isShipped) {
      status = Text(
        '已发货',
        style: TextStyle(fontSize: 14, color: Color(0xff2A82E4)),
      );
      status = Text(
        '已收货',
        style: TextStyle(fontSize: 14, color: Color(0xffA6A6A6)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text('黄水晶手串', style: TextStyle(fontSize: 16)),
                Text(
                  '默认按照用户的星盘定做手串，如有其他要求请咨询客服。',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                ),
                Row(children: [const Spacer(), status]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyGiftController>();
    return RefreshLoadmore(
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
    );
  }
}
