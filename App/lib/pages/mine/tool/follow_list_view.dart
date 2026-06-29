import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/user/subscribe.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../utils/dialog_util.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'follow_list_controller.dart';

class FollowListPage extends GetView<FollowListController> {
  const FollowListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FollowListController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(color: Color(0xffF5F7F9), width: 1),
        ),
        actions: [SizedBox(width: 58)],
        title: TabBar(
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
            insets: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          tabs: controller.headerNavTabs.map((item) {
            return Tab(text: item);
          }).toList(),
        ),
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: controller.tabController,
        children: [_FollowPage(), _CollectionPage()],
      ),
    );
  }
}

class _FollowPage extends StatelessWidget {
  const _FollowPage({super.key});

  _buildFriendItem(context, Subscribe item) {
    final controller = Get.find<FollowListController>();
    final user = item.gzuser;
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: ImageView.provider(user?.headimg ?? ''),
      ),
      title: Text(user?.nickname ?? ''),
      subtitle: Text(
        user?.sign ?? '',
        style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
      ),
      horizontalTitleGap: 10,
      contentPadding: EdgeInsets.only(left: 10),
      minTileHeight: 0,
      trailing: ElevatedButton(
        onPressed: () => controller.unfollow(item),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          minimumSize: Size(0, 0),
          elevation: 0,
          shadowColor: Colors.transparent,
          foregroundColor: Color(0xff383838),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Color(0xffF5F5F5)),
          ),
        ),
        child: Text('取消关注'),
      ),
    );
  }

  _buildCounselorItem(context, Subscribe item) {
    final controller = Get.find<FollowListController>();
    final teacher = item.gzteacher;
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: ImageView.provider(teacher?.headimg ?? ''),
      ),
      title: Text(teacher?.name ?? ''),
      subtitle: Text(
        teacher?.introduction ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
      ),
      horizontalTitleGap: 10,
      contentPadding: EdgeInsets.only(left: 10),
      minTileHeight: 0,
      trailing: GradientButton(
        onPressed: () => controller.unfollow(item),
        isRadius: false,
        radius: 6,
        height: 28,
        gradient: LinearGradient(
          colors: [Color(0xffE8DEFF), Color(0xffDEE6FF)],
        ),
        foregroundColor: Color(0xff4862D9),
        child: Text('取消关注', style: TextStyle(fontSize: 14)),
      ),
    );
  }

  _buildTopicItem(context, Subscribe item) {
    final controller = Get.find<FollowListController>();
    final gztopic = item.gztopic;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Color(0xffB3EDFF), Color(0xff5CA8FF)],
          ),
        ),
        child: Icon(Icons.numbers, size: 28, color: Colors.white),
      ),
      title: Text(gztopic?.title ?? ''),
      subtitle: Text(
        gztopic?.content ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
      ),
      horizontalTitleGap: 10,
      contentPadding: EdgeInsets.only(left: 10),
      minTileHeight: 0,
      trailing: ElevatedButton(
        onPressed: () => controller.unfollow(item),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          minimumSize: Size(0, 0),
          elevation: 0,
          shadowColor: Colors.transparent,
          foregroundColor: Color(0xff383838),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Color(0xffF5F5F5)),
          ),
        ),
        child: Text('取消关注'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowListController>();
    return RefreshLoadmore(
      controller: controller.refreshController,
      onRefresh: () async {
        await controller.listRefresh();
      },
      onLoad: () async {
        await controller.loadMore();
      },
      child: Obx(() {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsetsGeometry.all(AppConst.PAGE_PADDING),
              sliver: SliverToBoxAdapter(
                child: Column(
                  spacing: 12,
                  children: [
                    SearchBar(
                      controller: controller.searchController,
                      elevation: WidgetStatePropertyAll(0),
                      padding: WidgetStatePropertyAll(
                        EdgeInsetsGeometry.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                      ),
                      hintText: '搜索我的关注',
                      hintStyle: WidgetStatePropertyAll(
                        TextStyle(color: Color(0xff808080)),
                      ),
                      leading: Icon(
                        Icons.search,
                        color: Color(0xffC4C4C4),
                        size: 22,
                      ),
                      constraints: BoxConstraints(minHeight: 0, minWidth: 0),
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xffF5F5F5),
                      ),
                      onSubmitted: (_) => controller.onSearchSubmitted(),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(color: Color(0xff808080)),
                      child: Row(
                        children: [
                          Text('我的关注${controller.listData.length}人'),
                          Spacer(),
                          Text('最近关注'),
                        ],
                      ),
                    ),
                    Row(
                      spacing: 12,
                      children: controller.followTypes.asMap().entries.map((
                        item,
                      ) {
                        final index = item.key;
                        return GestureDetector(
                          onTap: () {
                            controller.followTypeIndex.value = index;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: controller.followTypeIndex == index
                                  ? Color(0xffF6F2FF)
                                  : null,
                              border: Border.all(
                                color: controller.followTypeIndex == index
                                    ? Colors.transparent
                                    : Color(0xffF5F5F5),
                              ),
                            ),
                            child: Text(
                              '${item.value}',
                              style: TextStyle(
                                color: controller.followTypeIndex == index
                                    ? Color(0xff4C1FAD)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsetsGeometry.only(
                left: AppConst.PAGE_PADDING,
                right: AppConst.PAGE_PADDING,
                bottom: AppConst.PAGE_PADDING,
              ),
              sliver: Obx(() {
                if (controller.listData.isEmpty) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(
                        child: controller.isLoading.value
                            ? CircularProgressIndicator()
                            : EmptyTips(title: '暂无关注'),
                      ),
                    ),
                  );
                }
                return SliverList.separated(
                  itemCount: controller.listData.length,
                  separatorBuilder: (_, index) {
                    return Divider(color: Color(0xffF5F7F9), indent: 60);
                  },
                  itemBuilder: (_, index) {
                    final item = controller.listData[index];
                    switch (controller.followTypeIndex.value) {
                      case 0:
                        return _buildFriendItem(context, item);
                      case 1:
                        return _buildCounselorItem(context, item);
                      case 2:
                        return _buildTopicItem(context, item);
                    }
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

class _CollectionPage extends StatelessWidget {
  const _CollectionPage({super.key});

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
    final controller = Get.find<FollowListController>();
    return RefreshLoadmore(
      controller: controller.refreshController,
      onRefresh: () async {
        await controller.listRefresh();
      },
      onLoad: () async {
        await controller.loadMore();
      },
      child: Obx(() {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsetsGeometry.all(AppConst.PAGE_PADDING),
              sliver: SliverToBoxAdapter(
                child: Column(
                  spacing: 12,
                  children: [
                    SearchBar(
                      controller: controller.searchController,
                      elevation: WidgetStatePropertyAll(0),
                      padding: WidgetStatePropertyAll(
                        EdgeInsetsGeometry.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                      ),
                      hintText: '搜索我的收藏',
                      hintStyle: WidgetStatePropertyAll(
                        TextStyle(color: Color(0xff808080)),
                      ),
                      leading: Icon(
                        Icons.search,
                        color: Color(0xffC4C4C4),
                        size: 22,
                      ),
                      constraints: BoxConstraints(minHeight: 0, minWidth: 0),
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xffF5F5F5),
                      ),
                      onSubmitted: (_) => controller.onSearchSubmitted(),
                    ),
                    Row(
                      spacing: 12,
                      children: controller.collectionTypes.asMap().entries.map((
                        item,
                      ) {
                        final index = item.key;
                        return GestureDetector(
                          onTap: () {
                            controller.collectionTypeIndex.value = index;
                            controller.listRefresh();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: controller.collectionTypeIndex == index
                                  ? Color(0xffF6F2FF)
                                  : null,
                              border: Border.all(
                                color: controller.collectionTypeIndex == index
                                    ? Colors.transparent
                                    : Color(0xffF5F5F5),
                              ),
                            ),
                            child: Text(
                              '${item.value}',
                              style: TextStyle(
                                color: controller.collectionTypeIndex == index
                                    ? Color(0xff4C1FAD)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsetsGeometry.only(
                left: AppConst.PAGE_PADDING,
                right: AppConst.PAGE_PADDING,
                bottom: AppConst.PAGE_PADDING,
              ),
              sliver: Obx(() {
                if (controller.listData.isEmpty) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(
                        child: controller.isLoading.value
                            ? CircularProgressIndicator()
                            : EmptyTips(title: '暂无收藏'),
                      ),
                    ),
                  );
                }
                return SliverList.separated(
                  itemCount: controller.listData.length,
                  separatorBuilder: (_, index) {
                    return Divider(color: Color(0xffF5F7F9), height: 20);
                  },
                  itemBuilder: (_, index) {
                    final item = controller.listData[index];
                    final post = item.xzArticle;
                    var imgList = _parseImgs(post?.imgs);
                    return Row(
                      spacing: 15,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: ImageView.network(
                            imgList.isNotEmpty ? imgList.first : '',
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Text(
                                post?.title ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(height: 1.5),
                              ),
                              Text(
                                post?.content ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Color(0xffA6A6A6)),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/icon_zan2.png',
                                    width: 18,
                                    height: 18,
                                  ),
                                  Text(
                                    '${post?.likecount ?? 0}',
                                    style: TextStyle(color: Color(0xffA6A6A6)),
                                  ),
                                  const SizedBox(width: 5),
                                  Image.asset(
                                    'assets/icons/icon_comment2.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    '${post?.commentcount ?? 0}',
                                    style: TextStyle(color: Color(0xffA6A6A6)),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      DialogUtil.showMenuDialog(
                                        context: context,
                                        items: [
                                          DialogMenuItem(
                                            title: '取消收藏',
                                            onTap: (_) {
                                              controller.unfollow(item);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: Color(0xffcccccc),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
