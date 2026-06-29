import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class BindMobileController extends GetxController {
  final showPage = BindMobilePageTab.showMobile.obs;
  final mobile = ''.obs;
  late final TextEditingController oldMobileController;
  late final TextEditingController newMobileController;

  @override
  void onInit() {
    super.onInit();
    final userService = Get.find<UserService>();
    oldMobileController = TextEditingController(
      text: userService.userinfo.value?.phone?.masked ?? '',
    );
    newMobileController = TextEditingController();
  }

  bindNewMobile() async {
    ToastUtil.loading();
    await Future.delayed(Duration(seconds: 4));
    ToastUtil.hide();
  }
}

enum BindMobilePageTab { showMobile, verifyMobile, bindMobile }
