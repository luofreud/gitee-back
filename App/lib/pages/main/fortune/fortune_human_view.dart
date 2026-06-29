import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import '../../../widgets/keep_alive_page.dart';
import './component/fortune_day_view.dart';
import './component/fortune_month_view.dart';
import './component/fortune_year_view.dart';
import 'fortune_human_controller.dart';

/// 用户今日运势
class FortuneHumanPage extends GetView<FortuneHumanController> {
  const FortuneHumanPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FortuneHumanController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.currentArchive.value?.name ?? '北鱼')),
          backgroundColor: Colors.white.withAlpha(0),
          actions: [
            GestureDetector(
              onTap: () => controller.onSelectArchive(),
              child: IconWidget(icon: 'icon_change.png', size: 20),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              child: IconWidget(icon: 'icon_share2.png', size: 20),
            ),
            const SizedBox(width: AppConst.PAGE_PADDING),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
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
            Expanded(
              child: Obx(() {
                if (controller.currentArchive.value == null) {
                  return Center(child: CircularProgressIndicator());
                }
                return PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.changeTab(index);
                  },
                  children: [
                    Obx(
                      () => KeepalivePage(
                        key: ValueKey(
                          'day_${controller.currentArchive.value?.id ?? 0}',
                        ),
                        child: FortuneDayComponent(
                          archiveId: controller.currentArchive.value?.id ?? 0,
                        ),
                      ),
                    ),
                    Obx(
                      () => KeepalivePage(
                        key: ValueKey(
                          'month_${controller.currentArchive.value?.id ?? 0}',
                        ),
                        child: FortuneMonthComponent(
                          archiveId: controller.currentArchive.value?.id ?? 0,
                        ),
                      ),
                    ),
                    Obx(
                      () => KeepalivePage(
                        key: ValueKey(
                          'year_${controller.currentArchive.value?.id ?? 0}',
                        ),
                        child: FortuneYearComponent(
                          archiveId: controller.currentArchive.value?.id ?? 0,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
