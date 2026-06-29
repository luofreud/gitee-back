import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../utils/dialog_util.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'test_order_controller.dart';

class TestOrderPage extends GetView<TestOrderController> {
  const TestOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TestOrderController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [SizedBox(width: 58)],
        title: TabBar(
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
            insets: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
          tabs: controller.headerNavTabs.map((item) {
            return Tab(text: item);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [_HotPage(), _MyPage()],
      ),
    );
  }
}

class _HotPage extends StatelessWidget {
  const _HotPage({super.key});

  _buildItem() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 12,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(width: 115, height: 86, color: Colors.grey),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '测评信息测评信息测评信',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '测评信息测评信息测评信测评信息测评信息测评信测评信息测评信息测评信测评信息测评信息测评信',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Color(0xff808080)),
                ),
                Row(
                  children: [
                    Text(
                      '￥',
                      style: TextStyle(fontSize: 12, color: Color(0xffFF5733)),
                    ),
                    Text(
                      '40',
                      style: TextStyle(fontSize: 20, color: Color(0xffFF5733)),
                    ),
                    Expanded(
                      child: Text(
                        '1522人已解锁',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xffA6A6A6),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(68, 24),
                        maximumSize: Size(68, 24),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: BorderSide(color: Color(0xffC2A8FF)),
                        ),
                        foregroundColor: Color(0xff4C1FAD),
                      ),
                      onPressed: () {},
                      child: Text('立即解锁', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestOrderController>();
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: controller.hotTestTypes.asMap().entries.map((item) {
                final index = item.key;
                final data = item.value;
                return Obx(() {
                  return GestureDetector(
                    onTap: () {
                      controller.testTypeIndex.value = index;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 7,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.testTypeIndex == index
                            ? Color(0xffF6F2FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data,
                        style: TextStyle(
                          color: controller.testTypeIndex == index
                              ? Color(0xff4C1FAD)
                              : Color(0xff808080),
                          fontWeight: controller.testTypeIndex == index
                              ? FontWeight.w500
                              : null,
                        ),
                      ),
                    ),
                  );
                });
              }).toList(),
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
                padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                separatorBuilder: (_, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (_, index) {
                  return _buildItem();
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MyPage extends StatelessWidget {
  const _MyPage({super.key});

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
          Row(
            spacing: 12,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(width: 115, height: 86, color: Colors.grey),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Text(
                            '测评信息测评信息测评信',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            DialogUtil.showMenuDialog(
                              context: context,
                              items: [
                                DialogMenuItem(title: '投诉', onTap: (_) {}),
                                DialogMenuItem(title: '删除', onTap: (_) {}),
                              ],
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Color(0xffF5F7F9),
                            radius: 11,
                            child: Icon(
                              Icons.more_horiz,
                              color: Color(0xff808080),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '测评信息测评信息测评信测评信息测评信息测评信测评信息测评信息测评信测评信息测评信息测评信',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: Color(0xff808080)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '已购买',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        Text('￥', style: TextStyle(fontSize: 12)),
                        Text('40', style: TextStyle(fontSize: 20)),
                      ],
                    ),
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
                  Text('订单时间：2025/11/23  12:00'),
                  Text('订单编号：xxxxxxxxxxxxxxxxx'),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text('已解锁', style: TextStyle(color: Color(0xffA6A6A6))),
              Spacer(),
              GradientButton(onPressed: () {}, child: Text('查看报告')),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestOrderController>();
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
