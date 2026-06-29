import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/menu_list_tile.dart';
import 'package:get/get.dart';

import 'bind_mobile_controller.dart';

class BindMobilePage extends GetView<BindMobileController> {
  const BindMobilePage({super.key});

  List<Widget> _showMobile() {
    final userService = Get.find<UserService>();
    return [
      Obx(() {
        String phone = userService.userinfo.value?.phone ?? '-';
        return MenuListTile(
          title: phone.masked,
          trailing: const Text(
            '已绑定',
            style: TextStyle(color: Color(0xff808080), fontSize: 14),
          ),
          radiusPosition: RadiusPosition.both,
          showArrow: false,
        );
      }),
      SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            controller.newMobileController.text = '';
            controller.showPage.value = BindMobilePageTab.bindMobile;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xff383838),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide.none,
            ),
          ),
          child: const Text('更改手机号'),
        ),
      ),
    ];
  }

  // 验证旧手机号码
  List<Widget> _verifyOldMobile() {
    return [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.only(right: 15),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.oldMobileController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: '请输入已绑定的手机号',
                  hintStyle: TextStyle(color: Color(0xff808080)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            Text(
              '发送验证码',
              style: TextStyle(color: Color(0xff2A82E4), fontSize: 16),
            ),
          ],
        ),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: '请输入验证码',
          hintStyle: TextStyle(color: Color(0xff808080)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {},
      ),

      SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            controller.showPage.value = BindMobilePageTab.bindMobile;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xff383838),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide.none,
            ),
          ),
          child: const Text('更改手机号'),
        ),
      ),
    ];
  }

  // 绑定新手机号码
  List<Widget> _boundNewMobile(context) {
    return [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.only(right: 15),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.newMobileController,
                decoration: InputDecoration(
                  hintText: '请输入新的手机号',
                  hintStyle: TextStyle(color: Color(0xff808080)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            Text(
              '发送验证码',
              style: TextStyle(color: Color(0xff2A82E4), fontSize: 16),
            ),
          ],
        ),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: '请输入验证码',
          hintStyle: TextStyle(color: Color(0xff808080)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {},
      ),

      SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () async {
            await controller.bindNewMobile();
            await DialogUtil.showSuccess(
              context: context,
              title: '更换手机号成功！',
              barrierDismissible: false,
            );
            controller.showPage.value = BindMobilePageTab.showMobile;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xff383838),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide.none,
            ),
          ),
          child: const Text('确认更改'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BindMobileController());

    return Scaffold(
      appBar: AppBar(title: const Text('绑定手机号'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Obx(() {
          List<Widget> children = [];
          switch (controller.showPage.value) {
            case BindMobilePageTab.showMobile:
              children = _showMobile();
            case BindMobilePageTab.verifyMobile:
              children = _verifyOldMobile();
            case BindMobilePageTab.bindMobile:
              children = _boundNewMobile(context);
          }
          return Column(spacing: 15, children: [...children]);
        }),
      ),
    );
  }
}
