import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/im_service.dart';
import 'voice_call_controller.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  _buildSenderAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
          label: controller.isMuted.value ? '麦克风已关' : '麦克风已开',
          isActive: !controller.isMuted.value,
          onTap: controller.toggleMute,
        ),
        _HangUpButton(onTap: controller.hangUp),
        _ActionButton(
          icon: controller.isSpeakerOn.value
              ? Icons.volume_up
              : Icons.volume_off_sharp,
          label: controller.isSpeakerOn.value ? '扬声器已开' : '扬声器已关',
          isActive: controller.isSpeakerOn.value,
          onTap: controller.toggleSpeaker,
        ),
      ],
    );
  }

  _buildReceiverAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _HangUpButton(label: '拒绝', onTap: controller.rejectCall),
        _AnswerButton(
          onTap: controller.answerCall,
          isLoading: controller.isAnswering.value,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => VoiceCallController());
    return Scaffold(
      backgroundColor: const Color(0xE6000000),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Obx(
              () => CircleAvatar(
                radius: 55,
                backgroundColor: Colors.transparent,
                backgroundImage: controller.partnerAvatar.value.isNotEmpty
                    ? NetworkImage(controller.partnerAvatar.value)
                    : null,
                child: controller.partnerAvatar.value.isEmpty
                    ? const Icon(Icons.person, size: 55, color: Colors.white70)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Text(
                controller.partnerName.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              switch (controller.callState.value) {
                case VoiceCallAction.accepted:
                  return Text(
                    controller.formattedDuration,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  );
                case VoiceCallAction.calling:
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white70,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '正在呼叫...',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  );
                default:
                  return const SizedBox.shrink();
              }
            }),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Obx(() {
                switch (controller.callState.value) {
                  case VoiceCallAction.ringing:
                    return _buildReceiverAction();
                  case VoiceCallAction.calling:
                  case VoiceCallAction.accepted:
                    return _buildSenderAction();
                  default:
                    return const SizedBox.shrink();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const _AnswerButton({required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff00C853),
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : const Icon(Icons.call, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          const Text(
            '接听',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.15),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black87 : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _HangUpButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HangUpButton({this.label = '挂断', required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFF3B3B),
            ),
            child: const Icon(Icons.call_end, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
