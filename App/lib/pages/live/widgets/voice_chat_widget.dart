import 'package:flutter/material.dart';
import 'package:freud/pages/live/live_room_controller.dart';
import 'package:get/get.dart';

import '../../../widgets/component/image_view.dart';

String _formatCount(int? count) {
  if (count == null) return '0';
  if (count >= 10000) {
    return '${(count / 10000).toStringAsFixed(2)}w';
  }
  return count.toString();
}

int _calcDays(String? createtime) {
  if (createtime == null || createtime.isEmpty) return 0;
  final date = DateTime.tryParse(createtime);
  if (date == null) return 0;
  return DateTime.now().difference(date).inDays;
}

/// 连麦用户区域
class VoiceChatWidget extends StatelessWidget {
  const VoiceChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveRoomController>();
    final liveRoomDetail = controller.liveRoomDetail.value!;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff353B66).withAlpha(50),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.withAlpha(100),
                    foregroundImage: ImageView.provider(
                      liveRoomDetail.teacher?.headimg ?? '',
                    ),
                  ),
                  Text(
                    liveRoomDetail.teacher?.name ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Image.asset(
                'assets/icons/live_user_vs.png',
                width: 40,
                height: 40,
              ),
              Obx(() {
                final roomCurrentConnect =
                    controller.roomCurrentConnect.value ?? null;
                String title = roomCurrentConnect?.itype == 1
                    ? '私密连麦中'
                    : '公开连麦中';
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xff4A6B95),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: roomCurrentConnect != null
                            ? ImageView.network(
                                roomCurrentConnect.user?.headimg ?? '',
                                isPreview: false,
                              )
                            : Image.asset(
                                'assets/icons/icon_voice.png',
                                width: 18,
                                height: 23,
                              ),
                      ),
                    ),
                    Text(
                      roomCurrentConnect != null ? title : '连麦答疑',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                );
              }),
            ],
          ),
          Obx(() {
            final teacher = controller.liveRoomDetail.value?.teacher;
            return DefaultTextStyle(
              style: const TextStyle(fontSize: 10, color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('累计解惑 ${_formatCount(teacher?.doubtnum)} 次'),
                  const SizedBox(
                    height: 10,
                    child: VerticalDivider(width: 1, color: Colors.white),
                  ),
                  Text('近期连麦 ${teacher?.livenum ?? 0}次'),
                  const SizedBox(
                    height: 10,
                    child: VerticalDivider(width: 1, color: Colors.white),
                  ),
                  Text('入驻天数 ${_calcDays(teacher?.checktime)} 天'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
