import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/article/article_plate.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../widgets/refresh_loadmore.dart';
import '../widgets/post_item.dart';
import 'discover_recommend_controller.dart';

class DiscoverRecommendPage extends GetView<DiscoverRecommendController> {
  const DiscoverRecommendPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DiscoverRecommendController());
    return Obx(() {
      if (controller.listData.isEmpty) {
        return Center(
          child: controller.isLoading.value
              ? CircularProgressIndicator()
              : EmptyTips(title: '暂无数据'),
        );
      }
      return RefreshLoadmore(
        controller: controller.refreshController,
        onRefresh: () async {
          await controller.listRefresh();
        },
        onLoad: () async {
          await controller.loadMore();
        },
        child: WaterfallFlow.builder(
          padding: EdgeInsets.only(
            left: AppConst.PAGE_PADDING,
            right: AppConst.PAGE_PADDING,
            bottom: AppConst.PAGE_PADDING,
          ),
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            lastChildLayoutTypeBuilder: (index) =>
                index == controller.listData.length
                ? LastChildLayoutType.foot
                : LastChildLayoutType.none,
          ),
          itemCount: controller.listData.length,
          itemBuilder: (context, index) {
            var item = controller.listData[index];
            if (index == 1) {
              return Column(
                spacing: 10,
                children: [
                  _HotTopic(data: controller.hotTopics),
                  PostItem(post: item),
                ],
              );
            }
            return PostItem(post: item);
          },
        ),
      );
    });
  }
}

class _HotTopic extends StatelessWidget {
  final List<ArticlePlate> data;

  _HotTopic({super.key, required this.data});

  final List<List<Color>> colors = [
    [Color(0xffF8696E), Color(0xffFEB6B4)],
    [Color(0xffFEAB7A), Color(0xffFCBBB4)],
    [Color(0xff71DAEE), Color(0xffBEFAF7)],
    [Color(0xffBACAFF), Color(0xffE3EEFF)],
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffFFE8F2), Colors.white],
          ),
        ),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 7,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed('/topic/list');
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '热门话题',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xffd9d9d9),
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(4, (index) {
                var title = data.length > index
                    ? (data[index].title ?? '')
                    : '';
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/topic/detail', arguments: data[index].id);
                  },
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: index < 4 ? colors[index] : colors[3],
                          ),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(title, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
