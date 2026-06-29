import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../constants/app_const.dart';
import '../../../models/article/post.dart';
import '../../../widgets/refresh_loadmore.dart';
import '../widgets/post_item.dart';
import 'discover_thoughts_controller.dart';

class DiscoverThoughtsPage extends GetView<DiscoverThoughtsController> {
  const DiscoverThoughtsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DiscoverThoughtsController());
    return RefreshLoadmore(
      onRefresh: () async {
        return controller.listRefresh();
      },
      onLoad: () async {
        return controller.loadMore();
      },
      child: Obx(() {
        return WaterfallFlow.builder(
          padding: EdgeInsets.only(
            left: AppConst.PAGE_PADDING,
            right: AppConst.PAGE_PADDING,
            bottom: AppConst.PAGE_PADDING,
          ),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行显示2列
            mainAxisSpacing: 10.0, // 主轴间距
            crossAxisSpacing: 10.0, // 横轴间距
            lastChildLayoutTypeBuilder: (index) =>
                index == controller.listData.length
                ? LastChildLayoutType.foot
                : LastChildLayoutType.none,
          ),
          itemCount: controller.listData.length,
          itemBuilder: (context, index) {
            var item = controller.listData[index];
            return PostItem(post: Post());
          },
        );
      }),
    );
  }
}
