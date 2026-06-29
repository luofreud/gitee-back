import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import 'mall_change_controller.dart';

class MallChangePage extends GetView<MallChangeController> {
  const MallChangePage({super.key});

  _buildHeader(context) {
    return Stack(
      children: [
        Container(
          height: controller.kHeaderContainerHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mall_header.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.only(left: 20, top: 40),
          margin: const EdgeInsets.only(bottom: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '200',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '星币余额',
                    style: TextStyle(fontSize: 12, color: Color(0xff8B81CC)),
                  ),
                ],
              ),
              Container(
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(18),
                  ),
                  gradient: LinearGradient(
                    colors: [Color(0xff91B2FF), Color(0xff9780FF)],
                  ),
                ),
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: Row(
                  children: [
                    Text(
                      '获取更多星币',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          bool isFixed = controller.appBarAlpha.value == 255;
          return Positioned(
            left: isFixed ? 0 : AppConst.PAGE_PADDING,
            right: isFixed ? 0 : AppConst.PAGE_PADDING,
            bottom: 0,
            child: _ProductTypeTabs(),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MallChangeController());
    final appBarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    controller.kAppbarHeight.value = appBarHeight;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GetBuilder<MallChangeController>(
          builder: (MallChangeController controller) {
            return Obx(
              () => AppBar(
                title: const Text('星币商城'),
                backgroundColor: Colors.white.withAlpha(
                  controller.appBarAlpha.value,
                ),
                actions: [
                  GestureDetector(onTap: () {}, child: Text('我的奖品')),
                  const SizedBox(width: 20),
                ],
              ),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: RefreshLoadmore(
        onLoad: () async {
          await controller.listLoadMore();
        },
        onRefresh: () async {
          await controller.listLoadMore();
        },
        headerPosition: IndicatorPosition.locator,
        headerSafeArea: false,
        controller: controller.refreshController,
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverPersistentHeader(
              delegate: CustomHeaderDelegate(
                minHeight: appBarHeight + controller.kHeaderTabsHeight,
                maxHeight:
                    controller.kHeaderContainerHeight +
                    controller.kHeaderTabsHeight / 2,
                child: _buildHeader(context),
              ),
              pinned: true,
              floating: false,
            ),
            const HeaderLocator.sliver(),
            SliverPadding(
              padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
              sliver: Obx(() {
                return SliverList.separated(
                  itemCount: (controller.listData.length / 2).ceil(),
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (_, index) {
                    var itemIndex = index * 2;
                    var itemIndex2 = itemIndex + 1;
                    buildItem(dynamic item) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                            colors: [Color(0xffF3F2FF), Color(0xffFCFCFF)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            ImageView.network(
                              'https://picsum.photos/200/200?random=111',
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                spacing: 10,
                                children: [
                                  Text(
                                    '免费快问券免费快问券免费快问券免费快问券免费快问券免费快问券免费快问券',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '800星币',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffFF8D1A),
                                          ),
                                        ),
                                      ),
                                      GradientButton(
                                        onPressed: () {},
                                        child: Text('兑换'),
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

                    return Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: buildItem(controller.listData[itemIndex]),
                        ),
                        Expanded(
                          child: itemIndex2 < controller.listData.length
                              ? buildItem(controller.listData[itemIndex2])
                              : SizedBox.shrink(),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  CustomHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _ProductTypeTabs extends StatefulWidget {
  const _ProductTypeTabs({super.key});

  @override
  State<_ProductTypeTabs> createState() => _ProductTypeTabsState();
}

class _ProductTypeTabsState extends State<_ProductTypeTabs>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<MallChangeController>();
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: controller.typeTabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isFixed = controller.appBarAlpha.value == 255;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isFixed
              ? BorderRadius.vertical(bottom: Radius.circular(10))
              : BorderRadius.circular(10),
        ),
        height: controller.kHeaderTabsHeight,
        child: TabBar(
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
            insets: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          ),
          controller: _controller,
          tabs: controller.typeTabs.map((item) {
            return Tab(text: item);
          }).toList(),
        ),
      );
    });
  }
}
