import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/keep_alive_page.dart';
import 'package:get/get.dart';

import '../../constants/app_const.dart';
import '../../widgets/page_background.dart';
import 'online_controller.dart';
import 'online_main/online_main_view.dart';
import 'online_one/online_one_view.dart';
import 'online_qa/online_qa_view.dart';

class OnlinePage extends GetView<OnlineController> {
  const OnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => OnlineController());
    return PageBackground(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: GetBuilder<OnlineController>(
            builder: (OnlineController ctrl) {
              return Obx(() {
                List<Widget> actions = [];
                if (controller.tabIndex.value == 0) {
                  actions = [
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.LIVERANK);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(150),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        minimumSize: Size(0, 0),
                        fixedSize: Size(double.infinity, 30),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/icon_ranking.png',
                            height: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '全部榜单',
                            style: TextStyle(
                              color: Color(0xff383838),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConst.PAGE_PADDING),
                  ];
                } else if (controller.tabIndex.value == 2) {
                  actions = [
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.QA_SQUARE);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(150),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        minimumSize: Size(0, 0),
                        fixedSize: Size(double.infinity, 30),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/icon_qa.png', height: 20),
                          SizedBox(width: 5),
                          Text(
                            '问题广场',
                            style: TextStyle(
                              color: Color(0xff383838),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConst.PAGE_PADDING),
                  ];
                }
                return AppBar(
                  title: TabBar(
                    onTap: (index) {
                      controller.changeTab(index);
                    },
                    isScrollable: true,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    controller: controller.tabController,
                    dividerHeight: 0,
                    tabAlignment: TabAlignment.start,
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
                      borderSide: BorderSide(
                        color: Color(0Xff4D1FAE),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      insets: EdgeInsets.all(5),
                    ),
                    tabs: controller.tabs
                        .map((item) => Tab(text: item))
                        .toList(),
                  ),
                  centerTitle: false,
                  titleSpacing: 0,
                  backgroundColor: Colors.white.withAlpha(0),
                  actions: actions,
                );
              });
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: (index) {
            controller.changeTab(index);
          },
          children: [
            KeepalivePage(child: OnlineMainPage()),
            KeepalivePage(child: OnlineOnePage()),
            KeepalivePage(child: OnlineQaPage()),
          ],
        ),
      ),
    );
  }
}
