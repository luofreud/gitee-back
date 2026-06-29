import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widgets/keep_alive_page.dart';
import '../discover/discover_view.dart';
import '../home/home_view.dart';
import '../message/message_view.dart';
import '../mine/mine_view.dart';
import '../online/online_view.dart';
import 'main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MainController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        _AndroidMinimizer.minimize();
      },
      child: Scaffold(
        body: PageView(
          controller: controller.pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            controller.changeNavIndex(index);
          },
          children: [
            KeepalivePage(child: HomePage()),
            KeepalivePage(child: DiscoverPage()),
            KeepalivePage(child: OnlinePage()),
            KeepalivePage(child: MessagePage()),
            KeepalivePage(child: MinePage()),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory, //移除水波纹效果
          ),
          child: Obx(
            () => BottomNavigationBar(
              elevation: 0,
              currentIndex: controller.navIndex.value,
              enableFeedback: false,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerLowest,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              type: BottomNavigationBarType.fixed,
              items: controller.navItems
                  .map(
                    (item) => BottomNavigationBarItem(
                      label: item['label'].toString(),
                      icon: Image.asset(
                        item['icon'].toString(),
                        width: 24,
                        height: 24,
                      ),
                      activeIcon: Image.asset(
                        item['activeIcon'].toString(),
                        width: 24,
                        height: 24,
                      ),
                    ),
                  )
                  .toList(),
              onTap: (index) {
                controller.changeNavIndex(index);
                controller.pageController.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// android 最小化app
class _AndroidMinimizer {
  static const _methodChannel = MethodChannel('android_minimizer');

  /// Move to background.
  static Future<void> minimize() async {
    await _methodChannel.invokeMethod('minimize');
  }
}
