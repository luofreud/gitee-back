import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/pages/login/login_view.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/switch_widget.dart';
import 'package:get/get.dart';

import '../../../widgets/component/menu_list_tile.dart';
import 'setting_controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  static final Widget _divider = Divider(
    height: 1,
    color: Color(0xffF5F7F9),
    indent: AppConst.PAGE_PADDING,
    endIndent: AppConst.PAGE_PADDING,
  );

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SettingController());
    return Scaffold(
      appBar: AppBar(title: Text('设置'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          children: [
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  MenuListTile(
                    title: '个人资料',
                    radiusPosition: RadiusPosition.top,
                    onTap: () {
                      Get.toNamed(AppRoutes.MINE_PROFILE);
                    },
                  ),
                  _divider,
                  MenuListTile(
                    title: '注销账户',
                    onTap: () {
                      Get.toNamed(AppRoutes.MINE_DELETEACCOUNT);
                    },
                  ),
                  _divider,
                  Obx(() {
                    return MenuListTile(
                      title: '清除缓存',
                      titlevalue: controller.cacheSize.value,
                      titleColor: Color(0xff383838),
                      radiusPosition: RadiusPosition.bottom,
                      onTap: () {
                        controller.clearCache();
                      },
                    );
                  }),
                ],
              ),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  MenuListTile(
                    title: '给个好评',
                    radiusPosition: RadiusPosition.top,
                    onTap: () {},
                  ),
                  _divider,
                  MenuListTile(
                    title: '用户反馈',
                    radiusPosition: RadiusPosition.bottom,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  MenuListTile(
                    title: '个性化内容推荐',
                    titleColor: Color(0xff383838),
                    showArrow: false,
                    radiusPosition: RadiusPosition.top,
                    trailing: Obx(() {
                      return SwitchWidget(
                        value: controller.recommend.value,
                        onChanged: (value) {
                          controller.recommend.value = value;
                        },
                      );
                    }),
                  ),
                  _divider,
                  MenuListTile(
                    title: '青少年模式',
                    titleColor: Color(0xff383838),
                    showArrow: false,
                    radiusPosition: RadiusPosition.bottom,
                    trailing: Obx(() {
                      return SwitchWidget(
                        value: controller.teenMode.value,
                        onChanged: (value) {
                          controller.teenMode.value = value;
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  MenuListTile(
                    title: '用户协议',
                    radiusPosition: RadiusPosition.top,
                    onTap: () {},
                  ),
                  _divider,
                  MenuListTile(title: '隐私政策', onTap: () {}),
                  _divider,
                  MenuListTile(title: '设备权限清单', onTap: () {}),
                  _divider,
                  MenuListTile(title: '第三方信息共享清单', onTap: () {}),
                  _divider,
                  MenuListTile(
                    title: '当前版本',
                    titleColor: Color(0xff383838),
                    radiusPosition: RadiusPosition.bottom,
                    showArrow: false,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Text(
                          '有新版本，点击更新',
                          style: TextStyle(
                            color: Color(0xffE85F5F),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'v1.0',
                          style: TextStyle(
                            color: Color(0xff808080),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  MenuListTile(
                    titlevalue: '退出登录',
                    textAlign: TextAlign.center,
                    showArrow: false,
                    radiusPosition: RadiusPosition.both,
                    trailing: null,
                    onTap: () async {
                      DialogUtil.showConfirmDialog(
                        title: '退出登录',
                        content: '确定退出登录吗？',
                        context: context,
                        onConfirm: (_) async {
                          Navigator.of(context).pop();
                          await Get.find<UserService>().logout();
                          Get.offAll(
                            LoginPage(),
                            transition: Transition.downToUp,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
