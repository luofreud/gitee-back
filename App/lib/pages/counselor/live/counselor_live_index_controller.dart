import 'package:flutter/material.dart';
import 'package:freud/api/counselor/counselor_live_api.dart';
import 'package:freud/models/live/live_room.dart';
import 'package:freud/models/live/live_room_page_request.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/widgets/live/agora_live.dart';
import 'package:get/get.dart';

class CounselorLiveIndexController extends GetxController {
  final counselorLiveApi = CounselorLiveApi();
  final lastLiveRoom = Rx<LiveRoom?>(null);
  bool _isLoading = false;
  AgoraLive agoraLive = AgoraLive();

  @override
  void onInit() {
    super.onInit();
    loadRoom();
  }

  void loadRoom() async {
    if (_isLoading) return;
    _isLoading = true;
    var request = LiveRoomPageRequest(page: 1, pageSize: 1);
    var result = await counselorLiveApi.getRoomList(request);
    if (result?.result?.items != null && result!.result!.items!.isNotEmpty) {
      lastLiveRoom.value = result.result!.items!.first;
    }
    _isLoading = false;
  }

  void closeCurrentRoom() {
    final room = lastLiveRoom.value;
    if (room == null || room.id == null) return;
    DialogUtil.showMenuDialog(
      context: Get.context!,
      items: [
        DialogMenuItem(
          title: '结束直播',
          color: const Color(0xffD43030),
          onTap: (_) async {
            var success = await counselorLiveApi.closeRoom(room.id!);
            if (success) {
              lastLiveRoom.value = null;
              ToastUtil.info('直播间已关闭');
            } else {
              ToastUtil.info('关闭失败');
            }
          },
        ),
      ],
    );
  }
}
