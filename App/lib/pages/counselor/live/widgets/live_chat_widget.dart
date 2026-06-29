import 'package:flutter/material.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../counselor_live_room_controller.dart';

/// 聊天输入框
class LiveChatWidget extends StatelessWidget {
  final double height;

  LiveChatWidget({super.key, this.height = 100});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorLiveRoomController>();
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Row(
        spacing: 5,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.textMessage.value = '';
                DialogUtil.showModalBottom(
                  context: context,
                  barrierColor: Colors.transparent,
                  enableDrag: false,
                  builder: (sheetContext) {
                    return _ChatFormModal();
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 44,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(50),
                  borderRadius: BorderRadius.circular(44),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  '礼貌交流~',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withAlpha(50),
              minimumSize: Size(0, 0),
              fixedSize: Size(44, 44),
            ),
            icon: Image.asset(
              'assets/icons/icon_share.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatFormModal extends StatefulWidget {
  const _ChatFormModal({super.key});

  @override
  State<_ChatFormModal> createState() => _ChatFormModalState();
}

class _ChatFormModalState extends State<_ChatFormModal>
    with WidgetsBindingObserver {
  bool _wasKeyboardVisible = false;
  bool _isClosing = false; // 防止重复关闭

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final bottomInset = View.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = bottomInset > 0;

    // 键盘从可见变为不可见 → 关闭 BottomSheet
    if (_wasKeyboardVisible && !isKeyboardVisible && mounted) {
      _closeBottomSheet();
    }
    _wasKeyboardVisible = isKeyboardVisible;
  }

  void _closeBottomSheet() {
    if (_isClosing) return;
    _isClosing = true;
    // 确保当前路由确实是 BottomSheet，避免误关主页面
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorLiveRoomController>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        // 插入需要执行的代码
        _isClosing = true;
        Navigator.of(context).pop();
      },
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              cursorHeight: 16,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                constraints: BoxConstraints(maxHeight: 36),
                hintText: '礼貌交流~',
                hintStyle: TextStyle(color: Color(0xffB1BEC7), fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xffF5F5F5),
              ),
              onChanged: (value) {
                controller.textMessage.value = value;
              },
              onSubmitted: (value) {
                controller.publishTextMessage();
              },
            ),
          ),
          Obx(() {
            return GradientButton(
              onPressed: controller.textMessage.value.isEmpty
                  ? null
                  : () async {
                      await controller.publishTextMessage();
                      _isClosing = true;
                      Navigator.of(context).pop();
                    },
              height: 36,
              width: 80,
              isRadius: false,
              child: Text('发送'),
            );
          }),
        ],
      ),
    );
  }
}
