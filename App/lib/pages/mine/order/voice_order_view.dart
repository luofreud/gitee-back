import 'package:flutter/material.dart';
import 'package:freud/models/live/live_connect_record.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../utils/dialog_util.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'voice_order_controller.dart';

class VoiceOrderPage extends GetView<VoiceOrderController> {
  const VoiceOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => VoiceOrderController());
    return Scaffold(
      appBar: AppBar(title: Text('连麦'), backgroundColor: Colors.white),
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
                insets: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              ),
              onTap: (index) {
                controller.navTabIndex.value = index;
                controller.listRefresh();
              },
              tabs: controller.headerNavTabs.map((item) {
                return Tab(text: item);
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [_LivePage(), _VoicePage()],
            ),
          ),
        ],
      ),
    );
  }
}

class _LivePage extends StatelessWidget {
  const _LivePage({super.key});

  _buildItem(context, LiveConnectRecord item) {
    final controller = Get.find<VoiceOrderController>();
    final productName = item.itype == 2 ? '语音通话咨询' : '直播连麦咨询';
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
            leading: CircleAvatar(
              radius: 20,
              foregroundImage: ImageView.provider(item.teacher?.headimg ?? ''),
            ),
            horizontalTitleGap: 10,
            minTileHeight: 30,
            title: Text(item.teacher?.name ?? ''),
            subtitle: Text(
              '${item.price ?? 0}星钻/分钟',
              style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            ),
            trailing: Transform.translate(
              offset: Offset(10, 0),
              child: IconButton(
                onPressed: () {
                  DialogUtil.showMenuDialog(
                    context: context,
                    items: [
                      DialogMenuItem(title: '投诉', onTap: (_) {}),
                      DialogMenuItem(
                        title: '删除',
                        onTap: (_) async {
                          var confirmed = await DialogUtil.showConfirmDialog(
                            context: context,
                            title: '提示',
                            content: '确定要删除该条记录吗？',
                          );
                          if (confirmed == true) {
                            controller.deleteItem(item);
                          }
                        },
                      ),
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
                    TextSpan(
                      text: '${item.freetime ?? 0}',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextSpan(text: ' 分钟'),
                  ],
                ),
              ),
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '付费：'),
                    TextSpan(
                      text: '${item.paytime ?? 0}',
                      style: TextStyle(fontSize: 20),
                    ),
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
                      text: '${item.xzmoney ?? 0}',
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
                  Text('购买项目：$productName'),
                  Text('订单时间：${item.createtime ?? ''}'),
                  Text('订单编号：${item.orderno ?? ''}'),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text(
                _stateText(item.state),
                style: TextStyle(color: Color(0xffA6A6A6)),
              ),
              Spacer(),
              GradientButton(
                onPressed: () {},
                gradient: LinearGradient(
                  colors: [Color(0xffECE3FF), Color(0xffE3EAFF)],
                ),
                isRadius: false,
                height: 28,
                child: Text(
                  '再次连麦',
                  style: TextStyle(color: Color(0xff334D9C), fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _stateText(int? state) {
    switch (state) {
      case 0:
        return '未连麦';
      case 1:
        return '正在连麦';
      case 2:
        return '已完成';
      case 3:
        return '投诉';
      case 4:
        return '导师拒绝';
      default:
        return '待评价';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoiceOrderController>();
    return RefreshLoadmore(
      controller: controller.refreshController,
      onRefresh: () async {
        await controller.listRefresh();
      },
      onLoad: () async {
        await controller.loadMore();
      },
      child: Obx(() {
        if (controller.listData.isEmpty) {
          return Center(
            child: controller.isLoading.value
                ? CircularProgressIndicator()
                : EmptyTips(title: '暂无记录'),
          );
        }
        return ListView.separated(
          itemCount: controller.listData.length,
          padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
          separatorBuilder: (_, index) {
            return SizedBox(height: 10);
          },
          itemBuilder: (_, index) {
            return _buildItem(context, controller.listData[index]);
          },
        );
      }),
    );
  }
}

class _VoicePage extends StatelessWidget {
  const _VoicePage({super.key});

  _buildItem(context, LiveConnectRecord item) {
    final controller = Get.find<VoiceOrderController>();
    final productName = item.itype == 2 ? '语音通话咨询' : '直播连麦咨询';
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
            title: Text(item.user?.nickname ?? ''),
            subtitle: Text(
              '${item.price ?? 0}星钻/分钟',
              style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            ),
            trailing: Transform.translate(
              offset: Offset(10, 0),
              child: IconButton(
                onPressed: () {
                  DialogUtil.showMenuDialog(
                    context: context,
                    items: [
                      DialogMenuItem(title: '投诉', onTap: (_) {}),
                      DialogMenuItem(
                        title: '删除',
                        onTap: (_) async {
                          Navigator.of(context).pop();
                          var confirmed = await DialogUtil.showConfirmDialog(
                            context: context,
                            title: '提示',
                            content: '确定要删除该条记录吗？',
                          );
                          if (confirmed == true) {
                            controller.deleteItem(item);
                          }
                        },
                      ),
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
                    TextSpan(
                      text: '${item.freetime ?? 0}',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextSpan(text: ' 分钟'),
                  ],
                ),
              ),
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '付费：'),
                    TextSpan(
                      text: '${item.paytime ?? 0}',
                      style: TextStyle(fontSize: 20),
                    ),
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
                      text: '${item.xzmoney ?? 0}',
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
                  Text('购买项目：$productName'),
                  Text('订单时间：${item.createtime ?? ''}'),
                  Text('订单编号：${item.orderno ?? ''}'),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text(
                _stateText(item.state),
                style: TextStyle(color: Color(0xffA6A6A6)),
              ),
              Spacer(),
              GradientButton(
                onPressed: () {},
                gradient: LinearGradient(
                  colors: [Color(0xffECE3FF), Color(0xffE3EAFF)],
                ),
                isRadius: false,
                height: 28,
                child: Text(
                  '再次连麦',
                  style: TextStyle(color: Color(0xff334D9C), fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _stateText(int? state) {
    switch (state) {
      case 0:
        return '未连麦';
      case 1:
        return '正在连麦';
      case 2:
        return '已完成';
      case 3:
        return '投诉';
      case 4:
        return '导师拒绝';
      default:
        return '待评价';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoiceOrderController>();
    return RefreshLoadmore(
      controller: controller.refreshController,
      onRefresh: () async {
        await controller.listRefresh();
      },
      onLoad: () async {
        await controller.loadMore();
      },
      child: Obx(() {
        if (controller.listData.isEmpty) {
          return Center(
            child: controller.isLoading.value
                ? CircularProgressIndicator()
                : EmptyTips(title: '暂无记录'),
          );
        }
        return ListView.separated(
          itemCount: controller.listData.length,
          padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
          separatorBuilder: (_, index) {
            return SizedBox(height: 10);
          },
          itemBuilder: (_, index) {
            return _buildItem(context, controller.listData[index]);
          },
        );
      }),
    );
  }
}
