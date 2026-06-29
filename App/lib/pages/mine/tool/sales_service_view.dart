import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'sales_service_controller.dart';

class SalesServicePage extends GetView<SalesServiceController> {
  const SalesServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SalesServiceController());

    return Scaffold(
      appBar: AppBar(
        title: Text('售后/退款'),
        backgroundColor: Colors.white,
        shape: Border(bottom: BorderSide(color: Color(0xfff5f7f9), width: 1)),
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Color(0xffFF5733),
              textStyle: TextStyle(fontSize: 14),
              overlayColor: Colors.transparent,
            ),
            child: Text('申请售后'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: controller.tabController,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              dividerHeight: 0,
              unselectedLabelColor: Color(0xff808080),
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
                insets: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              ),
              tabs: controller.headerNavTabs.map((item) {
                return Tab(text: item);
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _SalesServicePage(),
                _SalesServicePage(),
                _SalesServicePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesServicePage extends StatelessWidget {
  const _SalesServicePage({super.key});

  _buildItem(context) {
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
            trailing: Text(
              '问答咨询',
              style: TextStyle(fontSize: 16, color: Color(0xff808080)),
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
                    TextSpan(text: '32.1', style: TextStyle(fontSize: 20)),
                    TextSpan(text: ' 星钻'),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.TOOL_SALESSERVICE_DETAIL);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Color(0xffF5F7F9),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: Row(
                spacing: 5,
                children: [
                  Text('退款中'),
                  Text('退款已关闭', style: TextStyle(color: Color(0xff808080))),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Color(0xff696969),
                  ),
                ],
              ),
            ),
          ),
          Row(
            spacing: 10,
            children: [
              Spacer(),
              GradientButton(
                onPressed: () async {
                  var result = await DialogUtil.showConfirmDialog(
                    context: context,
                    position: DialogPosition.center,
                    title: '确定要删除该记录吗？',
                  );
                  if (result) {
                    // todo 删除
                  }
                },
                gradient: LinearGradient(
                  colors: [Color(0xffF5F7F9), Color(0xffF5F7F9)],
                ),
                foregroundColor: Color(0xff383838),
                isRadius: false,
                child: Text('删除记录'),
              ),
              GradientButton(
                onPressed: () async {
                  var result = await DialogUtil.showConfirmDialog(
                    context: context,
                    position: DialogPosition.center,
                    title: '确定要取消此订单的售后吗？',
                  );
                  if (result) {
                    // todo 取消售后单
                  }
                },
                gradient: LinearGradient(
                  colors: [Color(0xffF5F7F9), Color(0xffF5F7F9)],
                ),
                foregroundColor: Color(0xff383838),
                isRadius: false,
                child: Text('取消售后'),
              ),
              GradientButton(
                onPressed: () {},
                gradient: LinearGradient(
                  colors: [Color(0xffECE3FF), Color(0xffE3EAFF)],
                ),
                foregroundColor: Color(0xff2F4791),
                isRadius: false,
                child: Text('联系客服'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesServiceController>();
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
