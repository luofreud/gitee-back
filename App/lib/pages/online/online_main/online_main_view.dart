import 'package:flutter/material.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../models/live/live_room.dart';
import '../../../router/app_routes.dart';
import '../../../widgets/common/list_filter_overlay.dart';
import '../../../widgets/common/pinne_hander_delegate.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'online_main_controller.dart';

class OnlineMainPage extends GetView<OnlineMainController> {
  const OnlineMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => OnlineMainController());
    return Stack(
      children: [
        RefreshLoadmore(
          controller: controller.refreshController,
          onRefresh: () async {
            await controller.listRefresh();
          },
          onLoad: () async {
            await controller.loadMore();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConst.PAGE_PADDING,
                    vertical: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset('assets/example/online_ad1.png'),
                      ),
                      Image.asset('assets/icons/icon_gold_tj.png', height: 24),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: Obx(() {
                          return Row(
                            spacing: 10,
                            children: controller.topLiveRoomList.map((room) {
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.LIVE_ROOM,
                                    arguments: {'roomId': room.id?.toString() ?? ''},
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    children: [
                                      ImageView.network(
                                        room.img ?? '',
                                        width: 90,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        isPreview: false,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(100),
                                          ),
                                          child: Text(
                                            room.teacher?.name ?? '未知',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SimplePinnedHeaderDelegate(
                  minExtent: 50,
                  maxExtent: 50,
                  child: _OnlineFilterWidget(),
                ),
              ),
              Obx(() {
                if (controller.liveRoomList.isEmpty) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: controller.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : EmptyTips(title: '暂无在线直播'),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.only(
                    left: AppConst.PAGE_PADDING,
                    right: AppConst.PAGE_PADDING,
                    bottom: AppConst.PAGE_PADDING,
                  ),
                  sliver: SliverGrid.builder(
                    itemCount: controller.liveRoomList.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisSpacing: AppConst.PAGE_PADDING,
                      crossAxisSpacing: AppConst.PAGE_PADDING,
                      childAspectRatio: 0.75,
                      // mainAxisExtent: 220,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.LIVE_ROOM,
                            arguments: {
                              'roomId': controller.liveRoomList[index].id?.toString() ?? '',
                            },
                          );
                        },
                        child: _OnlineItem(
                          liveRoom: controller.liveRoomList[index],
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        // Positioned(
        //   left: AppConst.PAGE_PADDING,
        //   right: AppConst.PAGE_PADDING,
        //   bottom: 10,
        //   child: Image.asset('assets/example/online_ad2.png', fit: BoxFit.fill),
        // ),
      ],
    );
  }
}

class _OnlineFilterWidget extends StatelessWidget {
  const _OnlineFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<OnlineMainController>();
    return Container(
      color: AppConst.PAGE_BACKGROUND_COLOR,
      padding: const EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Text('默认排序', style: TextStyle(fontWeight: FontWeight.w500)),
              Expanded(
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: controller.filterList.map((item) {
                    return GestureDetector(
                      onTap: () {
                        controller.filterActiveKey.value = item["key"];
                        ListFilterOverlay.showFilterOverlay(
                          context: context,
                          padding: EdgeInsets.only(
                            left: AppConst.PAGE_PADDING,
                            right: AppConst.PAGE_PADDING,
                            bottom: AppConst.PAGE_PADDING,
                            top: 5,
                          ),
                          values: item["values"],
                          value: controller.filterQuery[item["key"]],
                          onTap: (value) {
                            controller.filterQuery[item["key"]] = value;
                          },
                          onClose: () {
                            controller.filterActiveKey.value = "";
                          },
                        );
                      },
                      child: Obx(() {
                        bool isActive =
                            controller.filterActiveKey.value == item["key"];
                        return Row(
                          children: [
                            Text(
                              item["title"],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isActive
                                    ? Color(0xff4B65CC)
                                    : Color(0xff383838),
                              ),
                            ),
                            Icon(
                              isActive
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: isActive
                                  ? Color(0xff4B65CC)
                                  : Color(0xffDBDBDB),
                              size: 20,
                            ),
                          ],
                        );
                      }),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnlineItem extends StatelessWidget {
  final LiveRoom liveRoom;

  const _OnlineItem({super.key, required this.liveRoom});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ImageView.network(
            liveRoom.img ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            isPreview: false,
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: [Color(0xff7259FF), Color(0xff927CF9)],
                ),
              ),
              child: Row(
                spacing: 2,
                children: [
                  Icon(Icons.verified_user, size: 14, color: Colors.white),
                  Text(
                    liveRoom.level == 0 ? '普通咨询师' : '认证咨询师',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          if (liveRoom.state == 0)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  spacing: 2,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.white),
                    Text(
                      '直播中',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withAlpha(125)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    liveRoom.teacher?.name ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    liveRoom.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 2,
                        width: 2,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: 2,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        height: 5,
                        width: 2,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${liveRoom.lookrum ?? 0}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
