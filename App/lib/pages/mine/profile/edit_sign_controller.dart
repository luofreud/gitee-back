import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class EditSignController extends GetxController {
  final signature = ''.obs;
  late final TextEditingController textFieldController;

  @override
  void onInit() {
    super.onInit();
    signature.value = Get.arguments;
    textFieldController = TextEditingController(text: signature.value);
  }

  Future<void> onSave() async {
    final result = await UserApi().updateUserSign({"sign": signature.value});
    if (result) {
      Get.find<UserService>().getUserInfo();
      ToastUtil.success('保存成功', duration: Duration(milliseconds: 500));
      Future.delayed(Duration(milliseconds: 500), () {
        Get.back();
      });
    }
  }
}
