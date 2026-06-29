import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../models/live/live_room.dart';

class CounselorLiveCreateController extends GetxController {
  final coverImage = ''.obs;
  final title = ''.obs;
  final titleEditing = false.obs;
  late TextEditingController titleController;
  final themeUrl = 'https://picsum.photos/1024/768?t=1'.obs;
  final notice = ''.obs;
  late TextEditingController noticeController;

  final counselorLiveApi = CounselorLiveApi();

  @override
  void onInit() {
    super.onInit();
    title.value =
        '${Get.find<UserService>().userinfo.value?.nickname ?? ''}正在直播';
    titleController = TextEditingController(text: title.value);
    noticeController = TextEditingController(text: notice.value);
  }

  @override
  void onClose() {
    titleController.dispose();
    noticeController.dispose();
    super.onClose();
  }

  selectCoverImage(context) async {
    var result = await CommonUtil.selectImage(
      context,
      maxCount: 1,
      requestType: RequestType.image,
    );
    if (result != null && result.isNotEmpty) {
      final assetEntity = result[0];
      coverImage.value = (await assetEntity.file)?.path ?? '';
    }
  }

  createLiveRoom() async {
    // Get.toNamed(
    //   AppRoutes.COUNSELOR_LIVE_ROOM,
    //   arguments: {'roomId': '807987065421893'},
    // );
    // return;
    if (coverImage.isEmpty) {
      ToastUtil.info('请选择封面');
      return;
    }
    if (title.isEmpty) {
      ToastUtil.info('请填写标题');
      return;
    }
    if (themeUrl.isEmpty) {
      ToastUtil.info('请选择直播背景');
      return;
    }

    ToastUtil.loading(msg: '正在创建直播间...');

    String coverUrl = '';
    final uploadResult = await counselorLiveApi.upload(coverImage.value);
    coverUrl = uploadResult?.url ?? '';
    if (coverUrl.isEmpty) {
      ToastUtil.info('上传封面失败');
      return;
    }
    final roomId = await counselorLiveApi.liveRoomAdd(
      LiveRoom(
        title: title.value,
        img: coverUrl,
        bgimg: themeUrl.value,
        content: notice.value,
      ),
    );
    if (roomId == null) {
      ToastUtil.info('创建直播间失败');
      return;
    }

    final liveRoomToken = await counselorLiveApi.liveRoomToken(roomId);
    if (liveRoomToken != null) {
      ToastUtil.hide();
      final token = liveRoomToken['item1'];
      final appid = liveRoomToken['item2'];
      Get.toNamed(AppRoutes.COUNSELOR_LIVE_ROOM, arguments: {'roomId': roomId});
    }
  }
}
