import 'dart:io';

import 'package:freud/api/api.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/component/image_crop.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> cropperAvatar(AssetEntity entity) async {
    final File? file = await entity.file;
    if (file == null) return false;
    final filePath = await ImageCrop.cropImage(file.path);
    if (filePath != null) {
      String fileName = filePath.split('/').last; // 获取文件名
      final uploadRes = await SystemApi().upload(filePath, filename: fileName);
      if (uploadRes != null) {
        final result = await UserApi().updateUserAvatar({
          "headimg": uploadRes.url,
        });
        await Get.find<UserService>().getUserInfo();
        return result;
      }
    }
    return false;
  }

  Future<bool> updateSex(int sex) async {
    final result = await UserApi().updateUserSex({"sex": sex});
    await Get.find<UserService>().getUserInfo();
    return result;
  }

  Future<bool> updateBirthday(DateTime birthday) async {
    final result = await UserApi().updateUserBirthday({
      "birthday": CommonUtil.formatDate(birthday, format: 'yyyy-MM-dd hh:mm:0'),
    });
    await Get.find<UserService>().getUserInfo();
    return result;
  }

  Future<bool> updateAddress(String address) async {
    final result = await UserApi().updateUserAddress({"address": address});
    await Get.find<UserService>().getUserInfo();
    return result;
  }

  Future<bool> updateNowAddress(String address) async {
    final result = await UserApi().updateUserNowAddress({
      "nowaddress": address,
    });
    await Get.find<UserService>().getUserInfo();
    return result;
  }
}
