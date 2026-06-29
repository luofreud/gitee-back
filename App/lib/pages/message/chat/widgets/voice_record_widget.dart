import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freud/api/im/im_message.dart';
import 'package:freud/models/im/im_message.dart';
import 'package:freud/service/im_service.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/permission_util.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../chat_controller.dart';

/// 语音录制发送组件
///
/// 封装了完整的语音消息发送流程：
/// 1. 按下按钮开始录音（申请麦克风权限）
/// 2. 录制过程中实时显示已录制时长
/// 3. 松开按钮停止录音
/// 4. 自动上传录音文件到服务器
/// 5. 通过 IM 服务发送语音消息
/// 6. 管理本地消息的插入、更新、删除
class VoiceRecordWidget extends StatefulWidget {
  /// 接收方用户 ID
  final int toUid;

  const VoiceRecordWidget({super.key, required this.toUid});

  @override
  State<VoiceRecordWidget> createState() => _VoiceRecordWidgetState();
}

class _VoiceRecordWidgetState extends State<VoiceRecordWidget> {
  /// 录音器实例
  AudioRecorder? _recorder;

  /// 是否正在录音
  bool _isRecording = false;

  /// 已录制时长（秒）
  int _recordDuration = 0;

  /// 时长计时器
  Timer? _durationTimer;

  /// 是否已获取麦克风权限
  bool _hasPermission = false;

  /// 是否已取消录音（手指滑出按钮区域）
  bool _canceled = false;

  @override
  void dispose() {
    _durationTimer?.cancel();
    _recorder?.dispose();
    super.dispose();
  }

  /// 检查并请求麦克风权限
  Future<bool> _ensurePermission() async {
    if (_hasPermission) return true;
    final granted = await PermissionUtil.checkAndRequestPermission(
      Permission.microphone,
      rationale: '需要麦克风权限才能录制语音',
    );
    _hasPermission = granted;
    return granted;
  }

  /// 开始录音
  ///
  /// 1. 检查麦克风权限
  /// 2. 创建临时文件路径（m4a 格式）
  /// 3. 使用 AAC 编码器开始录制
  /// 4. 启动每秒计时器更新录制时长
  Future<void> _startRecording() async {
    if (_isRecording) return;
    if (!await _ensurePermission()) return;

    _canceled = false;

    final dir = Directory.systemTemp;
    final path =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    final recorder = AudioRecorder();
    await recorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        numChannels: 1,
        bitRate: 64000,
        sampleRate: 22050,
      ),
      path: path,
    );

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _recordDuration++;
        });
      }
    });

    setState(() {
      _recorder = recorder;
      _isRecording = true;
      _recordDuration = 0;
    });
  }

  /// 取消录音
  void _cancelRecording() {
    _canceled = true;
    _finishRecording();
  }

  /// 结束录音
  ///
  /// 1. 停止录音器
  /// 2. 如果已取消或时长不足 1 秒则删除文件
  /// 3. 否则进入上传发送流程
  Future<void> _finishRecording() async {
    if (!_isRecording || _recorder == null) return;

    _durationTimer?.cancel();

    try {
      final path = await _recorder!.stop();

      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }

      // 手指滑出取消区域，丢弃录音
      if (_canceled) {
        _cleanupFile(path);
        return;
      }

      // 录音时长不足 1 秒，丢弃
      if (path == null || _recordDuration < 1) {
        _cleanupFile(path);
        return;
      }

      await _uploadAndSend(path);
    } catch (_) {
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  /// 删除临时音频文件
  void _cleanupFile(String? path) {
    if (path != null) {
      try {
        File(path).delete();
      } catch (_) {}
    }
  }

  /// 上传录音文件并发送语音消息
  ///
  /// 1. 创建本地消息（展示在聊天列表中）
  /// 2. 通过 ImMessageApi 上传到服务器
  /// 3. 上传成功：更新本地消息内容，通过 ImService 发送
  /// 4. 上传失败：删除本地消息和临时文件
  Future<void> _uploadAndSend(String filePath) async {
    final now = DateTime.now();
    final createdAt =
        '${now.year}-${_pad(now.month)}-${_pad(now.day)} ${_pad(now.hour)}:${_pad(now.minute)}:${_pad(now.second)}';
    final fromUid =
        Get.find<UserService>().userinfo.value?.id?.toString() ?? '';
    final toUid = widget.toUid.toString();

    final controller = Get.find<ChatController>();

    final localContent = jsonEncode({
      'type': 'audio',
      'localPath': filePath,
      'duration': _recordDuration,
    });

    // 插入本地消息
    controller.messages.add(
      ImMessage(
        fromUid: fromUid,
        toUid: toUid,
        type: 'audio',
        content: localContent,
        createdAt: createdAt,
      ),
    );
    controller.scrollToBottom();

    // 上传到服务器
    final uploadRes = await ImMessageApi().upload(filePath);

    // 上传失败，移除本地消息
    if (uploadRes == null || uploadRes.url == null) {
      _removeLocalMessage(filePath);
      _cleanupFile(filePath);
      return;
    }

    final audioUrl = uploadRes.url!;
    final fileId =
        uploadRes.id?.toString() ?? filePath.split('\\').last.split('/').last;

    // 更新本地消息为已上传状态
    final newContent = jsonEncode({
      'type': 'audio',
      'file_id': fileId,
      'url': audioUrl,
      'duration': _recordDuration,
    });
    _updateLocalMessage(filePath, newContent);

    // 通过 IM 服务发送语音消息
    await Get.find<ImService>().sendAudioMessage(
      fromUserId: fromUid,
      toUserId: toUid,
      fileId: fileId,
      url: audioUrl,
      duration: _recordDuration,
    );

    // 发送完毕，清理临时文件
    _cleanupFile(filePath);
  }

  /// 更新本地消息内容（上传成功后替换为远程 URL）
  void _updateLocalMessage(String localPath, String newContent) {
    final controller = Get.find<ChatController>();
    final index = controller.messages.indexWhere((msg) {
      if (msg.content == null) return false;
      try {
        final map = jsonDecode(msg.content!) as Map<String, dynamic>;
        return map['localPath'] == localPath;
      } catch (_) {
        return false;
      }
    });
    if (index < 0) return;
    final old = controller.messages[index];
    controller.messages[index] = ImMessage(
      fromUid: old.fromUid,
      toUid: old.toUid,
      type: old.type,
      content: newContent,
      createdAt: old.createdAt,
    );
  }

  /// 删除本地消息（上传失败时清理）
  void _removeLocalMessage(String localPath) {
    final controller = Get.find<ChatController>();
    final index = controller.messages.indexWhere((msg) {
      if (msg.content == null) return false;
      try {
        final map = jsonDecode(msg.content!) as Map<String, dynamic>;
        return map['localPath'] == localPath;
      } catch (_) {
        return false;
      }
    });
    if (index >= 0) {
      controller.messages.removeAt(index);
    }
  }

  /// 数字补零（用于格式化时间）
  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: GestureDetector(
        onTapDown: (_) => _startRecording(),
        onTapUp: (_) => _finishRecording(),
        onTapCancel: _cancelRecording,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _isRecording
                ? const Color(0xFFFFE5E5)
                : const Color(0xfff5f7f9),
            border: Border.all(
              color: _isRecording
                  ? const Color(0xFFFF6B6B)
                  : const Color(0xfff5f7f9),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isRecording) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF3B3B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_recordDuration}\'\' 松开 发送',
                  style: const TextStyle(
                    color: Color(0xFFFF3B3B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else ...[
                const Icon(Icons.mic, size: 16, color: Color(0xff383838)),
                const SizedBox(width: 4),
                const Text(
                  '按住 说话',
                  style: TextStyle(color: Color(0xff383838), fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
