import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../utils/dialog_util.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'mytips_order_controller.dart';

class MytipsOrderPage extends GetView<MytipsOrderController> {
  const MytipsOrderPage({super.key});

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
            trailing: Transform.translate(
              offset: Offset(10, 0),
              child: IconButton(
                onPressed: () {
                  DialogUtil.showMenuDialog(
                    context: context,
                    items: [
                      DialogMenuItem(title: '投诉', onTap: (_) {}),
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
              Text(
                '2025/11/26 23:15',
                style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
              ),
              Spacer(),
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '赞赏 '),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MytipsOrderController());
    return Scaffold(
      appBar: AppBar(title: const Text('我的赞赏'), backgroundColor: Colors.white),
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
