import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../utils/dialog_util.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'my_publish_controller.dart';

class MyPublishPage extends GetView<MyPublishController> {
  const MyPublishPage({super.key});

  _buildItem(BuildContext context, Post item) {
    String? firstImg;
    if (item.imgs != null && item.imgs!.isNotEmpty) {
      try {
        final list = jsonDecode(item.imgs!) as List;
        if (list.isNotEmpty) firstImg = list.first as String?;
      } catch (_) {
        firstImg = item.imgs;
      }
    }
    return Row(
      spacing: 15,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: firstImg != null
              ? ImageView.network(
                  firstImg,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                )
              : Container(width: 96, height: 96, color: Color(0xffCCCCCC)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                item.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1.5),
              ),
              Text(
                item.content ?? '',
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
                    '${item.likecount ?? 0}',
                    style: TextStyle(color: Color(0xffA6A6A6)),
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    'assets/icons/icon_comment2.png',
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    '${item.commentcount ?? 0}',
                    style: TextStyle(color: Color(0xffA6A6A6)),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      DialogUtil.showMenuDialog(
                        context: context,
                        items: [
                          DialogMenuItem(
                            title: '删除',
                            onTap: (_) async {
                              final result = await DialogUtil.showConfirmDialog(
                                context: context,
                                position: DialogPosition.center,
                                title: '确定要删除该发布吗？',
                              );
                              if (result == true && item.id != null) {
                                controller.deleteItem(item.id!);
                              }
                            },
                          ),
                        ],
                      );
                    },
                    child: Icon(Icons.more_horiz, color: Color(0xffcccccc)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MyPublishController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(color: Color(0xffF5F7F9), width: 1),
        ),
        title: Text('我的发布'),
        actions: [
          TextButton(
            onPressed: () async {
              final addRes = await Get.toNamed(AppRoutes.POST_PUBLISH);
              if (addRes) {
                controller.listRefresh();
              }
            },
            style: TextButton.styleFrom(
              overlayColor: Colors.transparent,
              foregroundColor: Color(0xff383838),
            ),
            child: Text('发布'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.listData.isEmpty && !controller.isLoading.value) {
          return EmptyTips(
            title: '暂无发布内容',
            subTitle: '点击发布按钮立即发布',
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GradientButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.POST_PUBLISH);
                },
                gradient: LinearGradient(
                  colors: [Color(0xffECE3FF), Color(0xffE3EAFF)],
                ),
                foregroundColor: Color(0xff2F4791),
                radius: 6,
                isRadius: false,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('去发布'),
              ),
            ),
          );
        }
        return RefreshLoadmore(
          controller: controller.refreshController,
          onRefresh: () async {
            await controller.listRefresh();
          },
          onLoad: () async {
            await controller.listLoadMore();
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsetsGeometry.all(AppConst.PAGE_PADDING),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    spacing: 12,
                    children: [
                      SearchBar(
                        elevation: WidgetStatePropertyAll(0),
                        padding: WidgetStatePropertyAll(
                          EdgeInsetsGeometry.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                        ),
                        hintText: '搜索我的发布',
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
                sliver: SliverList.separated(
                  itemCount: controller.listData.length,
                  separatorBuilder: (_, index) {
                    return Divider(color: Color(0xffF5F7F9), height: 20);
                  },
                  itemBuilder: (_, index) {
                    return _buildItem(context, controller.listData[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
