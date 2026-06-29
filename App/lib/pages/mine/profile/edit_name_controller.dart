import 'package:flutter/cupertino.dart';
import 'package:freud/api/api.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class EditNameController extends GetxController {
  final nickname = ''.obs;
  late final TextEditingController textFieldController;

  @override
  void onInit() {
    super.onInit();
    nickname.value = Get.arguments;
    textFieldController = TextEditingController(text: nickname.value);
  }

  Future<void> onSave() async {
    if (nickname.value.isEmpty) {
      ToastUtil.info('请输入昵称');
      return;
    }
    final result = await UserApi().updateUserNick({"nickname": nickname.value});
    if (result) {
      Get.find<UserService>().getUserInfo();
      ToastUtil.success('保存成功', duration: Duration(milliseconds: 500));
      Future.delayed(Duration(milliseconds: 500), () {
        Get.back();
      });
    }
  }
}
