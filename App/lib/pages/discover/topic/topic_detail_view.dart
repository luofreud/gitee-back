import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:get/get.dart';

import '../widgets/topic_refresh_indicator.dart';
import 'topic_detail_controller.dart';

class TopicDetailPage extends GetView<TopicDetailController> {
  const TopicDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TopicDetailController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GetBuilder<TopicDetailController>(
          builder: (TopicDetailController home) {
            return Obx(
              () => AppBar(
                title: Text(
                  '话题详情',
                  style: TextStyle(color: controller.appBarTextColor.value),
                ),
                backgroundColor: controller.appBarColor.value,
                foregroundColor: controller.appBarTextColor.value,
              ),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      floatingActionButtonLocation: _TopicPublishButtonLocation(
        verticalOffset: -50,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(
            AppRoutes.POST_PUBLISH,
            arguments: {
              'topicId': controller.topicId,
              'topicTitle': controller.topicInfo.value?.title ?? '',
            },
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        shape: CircleBorder(),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff5C2EBF), Color(0xff133394)],
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/icon_send.png', width: 16, height: 16),
              const Text('发布', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
      body: TopicRefreshIndicator(
        displacement: kToolbarHeight,
        //MediaQuery.of(context).padding.top,
        onRefresh: () async {
          await controller.listRefresh();
        },
        onPullDownUpdate: (value) {
          if (value >= 0) {
            controller.updateOffsetHeight(value);
          }
        },
        onPullDownEnd: () {
          // 构建高度动画：从_minExpandedHeight到_maxExpandedHeight
          controller.pullDownEnd();
        },
        onScrollUpdate: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            double distanceToTop = notification.metrics.pixels;

            controller.updateAppBarColor(distanceToTop);

            // 打印顶部距离（保留2位小数）
            // debugPrint("当前距离顶部：${distanceToTop.toStringAsFixed(2)} 像素");

            double distanceToBottom = notification.metrics.extentAfter;
            // 打印底部距离
            // print("当前距离底部：${distanceToBottom.toStringAsFixed(2)} 像素");

            // 判断：距离底部小于100像素时，触发提示（如加载更多）
            if (distanceToBottom < 100) {
              // debugPrint("⚠️ 即将到达底部，剩余距离：$distanceToBottom 像素");
              controller.loadMore();
              // 此处可添加加载更多数据的逻辑
            }
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Obx(() {
                    return Stack(
                      children: [
                        ImageView.network(
                          controller.topicInfo.value?.image ??
                              'https://picsum.photos/200/300',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: controller.offsetHeight.value,
                          isPreview: false,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Container(color: Colors.black.withAlpha(80)),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 40,
                          right: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12,
                                  children: [
                                    Text(
                                      '# ${controller.topicInfo.value?.title ?? ""}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      spacing: 15,
                                      children: [
                                        Text(
                                          '${controller.topicInfo.value?.count ?? 0}条帖子',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Obx(
                                          () => Text(
                                            '${controller.subscribeCount.value}关注',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Obx(
                                () => OutlinedButton(
                                  onPressed: () => controller.toggleSubscribe(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        controller.isSubscribed.value == 1
                                        ? Colors.grey
                                        : Colors.white,
                                    side: BorderSide(
                                      color: controller.isSubscribed.value == 1
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 0,
                                    ),
                                    minimumSize: Size(50, 25),
                                    maximumSize: Size(100, 25),
                                  ),
                                  child: Text(
                                    controller.isSubscribed.value == 1
                                        ? '已关注'
                                        : '+ 关注',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  Transform.translate(
                    offset: Offset(0, -10),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (controller.listData.isEmpty) {
                return SliverToBoxAdapter(
                  child: controller.isLoading.value
                      ? Container(
                          height: 60,
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : SizedBox(height: 200, child: EmptyTips(title: '暂无帖子')),
                );
              }
              return SliverList.separated(
                itemCount: controller.listData.length,
                separatorBuilder: (context, index) {
                  return Container(height: 10, color: Color(0xffF5F7F9));
                },
                itemBuilder: (context, index) {
                  return _ItemWidget(post: controller.listData[index]);
                },
              );
            }),
            Obx(() {
              return SliverToBoxAdapter(
                child: controller.listData.isEmpty
                    ? SizedBox.shrink()
                    : Container(height: 10, color: Color(0xffF5F7F9)),
              );
            }),
          ],
        ),
      ),
    );
  }
}

///发布按钮位置
class _TopicPublishButtonLocation extends FloatingActionButtonLocation {
  final double? horizontalOffset; // 水平偏移量（右正左负）
  final double? verticalOffset; // 垂直偏移量（上负下正）
  final FloatingActionButtonLocation targetLocation; // 基础预设位置

  const _TopicPublishButtonLocation({
    this.targetLocation = FloatingActionButtonLocation.endFloat,
    this.horizontalOffset,
    this.verticalOffset,
  });

  // 重写核心定位方法：计算FAB的最终位置
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // 获取基础预设位置的偏移
    Offset baseOffset = targetLocation.getOffset(scaffoldGeometry);
    // 叠加自定义偏移量，得到最终位置
    return Offset(
      baseOffset.dx + (horizontalOffset ?? 0),
      baseOffset.dy + (verticalOffset ?? 0),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final Post post;

  const _ItemWidget({super.key, required this.post});

  final TextStyle _tipTextStyle = const TextStyle(
    fontSize: 14,
    color: Color(0xffA6A6A6),
  );

  List<String> _parseImgs(String? imgs) {
    if (imgs == null || imgs.isEmpty) return [];
    try {
      var decoded = jsonDecode(imgs);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return imgs
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> imgList = _parseImgs(post.imgs);
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.POST_DETAIL, arguments: post.id);
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: AppConst.PAGE_PADDING,
          right: AppConst.PAGE_PADDING,
          bottom: AppConst.PAGE_PADDING,
        ),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  post.user?.headimg ?? 'https://picsum.photos/200/300',
                ),
              ),
              title: Text(
                post.isanonymous == 1 ? '匿名用户' : (post.user?.nickname ?? ''),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              subtitle: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffA1CAFF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    child: Text(
                      'Lv.${post.user?.level ?? 0}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(child: Icon(Icons.more_horiz)),
            ),
            if (post.content != null && post.content!.isNotEmpty)
              Text(post.content!, style: TextStyle(color: Color(0xff5E5E5E))),
            if (imgList.isNotEmpty)
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: imgList.length,
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (_, i) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: ImageView.network(imgList[i], isPreview: true),
                  );
                },
              ),
            Row(
              spacing: 15,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffE5E5E5)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(post.tags ?? '星盘'),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/topic_icon_sc.png',
                      width: 22,
                      height: 22,
                    ),
                    Text('${post.collectioncount ?? 0}', style: _tipTextStyle),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/topic_icon_pl.png',
                      width: 22,
                      height: 22,
                    ),
                    Text('${post.commentcount ?? 0}', style: _tipTextStyle),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/topic_icon_zan.png',
                      width: 22,
                      height: 22,
                    ),
                    Text('${post.likecount ?? 0}', style: _tipTextStyle),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
