import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freud/api/im/im_message.dart';
import 'package:freud/models/im/im_message.dart';
import 'package:freud/service/im_service.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/common_util.dart';
import 'package:get/get.dart';

import '../chat_controller.dart';

/// 图片选择发送组件
///
/// 封装了完整的图片消息发送流程：
/// 1. 从相册选择图片或拍照
/// 2. 插入本地消息（显示缩略图 + 上传进度）
/// 3. 上传图片到服务器（带进度回调）
/// 4. 上传成功：通过 IM 服务发送图片消息
/// 5. 上传失败：移除本地消息
///
/// 在底部工具栏中渲染相册和相机两个图标按钮

class ImageSendGallery extends StatelessWidget {
  final int toUid;

  const ImageSendGallery({super.key, required this.toUid});

  /// 从相册选择图片并发送
  Future<void> pickFromGallery(BuildContext context) async {
    final result = await CommonUtil.selectImage(context);
    if (result == null || result.isEmpty) return;
    for (final entity in result) {
      final file = await entity.file;
      if (file == null) continue;

      _ImageSendService().uploadAndSend(toUid.toString(), file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pickFromGallery(context);
      },
      child: Image.asset('assets/icons/icon_chat_image.png', width: 28),
    );
  }
}

class ImageSendCamera extends StatelessWidget {
  final int toUid;

  const ImageSendCamera({super.key, required this.toUid});

  /// 拍照并发送
  Future<void> takePhoto(BuildContext context) async {
    final entity = await CommonUtil.takePhoto(context);
    if (entity == null) return;
    final file = await entity.file;
    if (file == null) return;
    _ImageSendService().uploadAndSend(toUid.toString(), file.path);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => takePhoto(context),
      child: Image.asset('assets/icons/icon_chat_camera.png', width: 28),
    );
  }
}

class _ImageSendService {
  /// 上传图片并发送
  ///
  /// 1. 创建本地消息（立即展示在聊天列表）
  /// 2. 通过 ImMessageApi 上传到服务器
  /// 3. 上传过程中实时更新进度（供 ChatItemImage 显示进度条）
  /// 4. 上传成功：更新本地消息为远程 URL，通过 ImService 发送
  /// 5. 上传失败：移除本地消息
  Future<void> uploadAndSend(String toUid, String filePath) async {
    final controller = Get.find<ChatController>();

    final now = DateTime.now();
    final createdAt =
        '${now.year}-${_pad(now.month)}-${_pad(now.day)} ${_pad(now.hour)}:${_pad(now.minute)}:${_pad(now.second)}';
    final fromUid =
        Get.find<UserService>().userinfo.value?.id?.toString() ?? '';

    // 构建本地消息内容
    final localContent = jsonEncode({'type': 'image', 'localPath': filePath});

    // 插入本地消息
    controller.messages.add(
      ImMessage(
        fromUid: fromUid,
        toUid: toUid,
        type: 'image',
        content: localContent,
        createdAt: createdAt,
      ),
    );
    controller.scrollToBottom();

    final fileName = filePath.replaceAll('\\', '/').split('/').last;

    final uploadRes = await ImMessageApi().upload(filePath, filename: fileName);

    // 上传失败，移除本地消息
    if (uploadRes == null || uploadRes.url == null) {
      removeLocalMessage(filePath);
      cleanupFile(filePath);
      return;
    }

    final imageUrl = uploadRes.url!;
    final fileId = uploadRes.id?.toString() ?? fileName;

    // 更新本地消息为已上传状态
    final newContent = jsonEncode({
      'type': 'image',
      'file_id': fileId,
      'url': imageUrl,
    });
    updateLocalMessage(filePath, newContent);
    controller.messages.refresh();

    // 通过 IM 服务发送图片消息
    final fromUserId = Get.find<UserService>().userinfo.value?.id;
    if (fromUserId != null) {
      await Get.find<ImService>().sendImageMessage(
        fromUserId: fromUserId.toString(),
        toUserId: toUid,
        fileId: fileId,
        url: imageUrl,
      );
    }
  }

  /// 更新本地消息内容（上传成功后替换为远程 URL）
  void updateLocalMessage(String localPath, String newContent) {
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
  void removeLocalMessage(String localPath) {
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

  /// 清理临时文件
  void cleanupFile(String filePath) {
    try {
      File(filePath).delete();
    } catch (_) {}
  }

  /// 数字补零（用于格式化时间）
  String _pad(int n) => n.toString().padLeft(2, '0');
}
