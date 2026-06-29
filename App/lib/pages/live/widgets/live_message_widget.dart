import 'package:flutter/material.dart';
import 'package:freud/pages/live/live_room_controller.dart';
import 'package:get/get.dart';

/// 直播消息区域
class LiveMessageWidget extends StatelessWidget {
  const LiveMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveRoomController>();
    return SizedBox(
      height: 250,
      child: Obx(() {
        return ListView.separated(
          itemCount: controller.liveMessageList.length,
          controller: controller.messageScrollController,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      controller.liveMessageList[index],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff4DDDE7),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
    return Container(
      height: 250,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: List.generate(10, (index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
              child: Text(
                '我们从分享时机、分享形式、分享动机、分享场景4个维度来聊聊「社交分享」的那些事儿。在常用的社交分享组件中，微信（微信',
                style: TextStyle(fontSize: 12, color: Color(0xff4DDDE7)),
              ),
            );
          }),
        ),
      ),
    );
  }
}
