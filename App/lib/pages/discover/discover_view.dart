import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

import '../../constants/app_const.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/keep_alive_page.dart';
import '../../widgets/page_background.dart';
import 'discover_controller.dart';
import 'recommend/discover_recommend_view.dart';
import 'test/discover_test_view.dart';
import 'thoughts/discover_thoughts_view.dart';

class DiscoverPage extends GetView<DiscoverController> {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DiscoverController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
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
              borderSide: BorderSide(color: Color(0Xff4D1FAE), width: 3),
              borderRadius: BorderRadius.circular(4),
              insets: EdgeInsets.all(5),
            ),
            tabs: controller.tabs.map((item) => Tab(text: item)).toList(),
          ),
          centerTitle: false,
          titleSpacing: 0,
          backgroundColor: Colors.white.withAlpha(0),
          actions: [
            GradientButton(
              height: 32,
              textStyle: const TextStyle(fontSize: 14),
              onPressed: () {
                Get.toNamed(AppRoutes.POST_PUBLISH);
              },
              gradient: const LinearGradient(
                colors: [Color(0xff945EFF), Color(0xff2E2EB8)],
              ),
              isRadius: true,
              child: Row(
                spacing: 5,
                children: [
                  Image.asset('assets/icons/icon_send.png', height: 16),
                  Text('发布', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(width: AppConst.PAGE_PADDING),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: (index) {
            controller.changeTab(index);
          },
          children: [
            KeepalivePage(child: DiscoverRecommendPage()),
            KeepalivePage(child: DiscoverTestPage()),
            KeepalivePage(child: DiscoverThoughtsPage()),
          ],
        ),
      ),
    );
  }
}
