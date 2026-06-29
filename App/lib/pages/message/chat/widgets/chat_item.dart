import 'package:flutter/material.dart';
import 'package:freud/models/im/im_message.dart';
import 'package:freud/widgets/component/image_view.dart';

import 'chat_item_astrolabe.dart';
import 'chat_item_audio.dart';
import 'chat_item_composite.dart';
import 'chat_item_dice.dart';
import 'chat_item_image.dart';
import 'chat_item_poker.dart';
import 'chat_item_text.dart';
import 'chat_item_voice_call.dart';

class ChatItem extends StatelessWidget {
  final int index;
  final MessageType? type;
  final bool isSend;
  final ImMessage? message;
  final String avatarUrl;

  const ChatItem({
    super.key,
    required this.index,
    this.type = MessageType.TEXT,
    this.isSend = true,
    this.message,
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: 22,
      backgroundColor: Colors.transparent,
      foregroundImage: avatarUrl.isNotEmpty
          ? ImageView.provider(avatarUrl)
          : AssetImage('assets/images/default_avatar.png'),
    );
    Widget? title;
    switch (type) {
      case MessageType.TEXT:
        title = ChatItemText(content: message?.content);
        break;
      case MessageType.IMAGE:
        title = ChatItemImage(content: message?.content);
        break;
      case MessageType.AUDIO:
        title = ChatItemAudio(content: message?.content);
        break;
      case MessageType.VIDEO:
        break;
      case MessageType.FILE:
        break;
      case MessageType.ASTROLABE:
        title = ChatItemAstrolabe(content: message?.content);
        break;
      case MessageType.DICE:
        title = ChatItemDice(content: message?.content);
        break;
      case MessageType.POKER:
        title = ChatItemPoker(content: message?.content);
        break;
      case MessageType.COMPOSITE:
        title = ChatItemComposite(content: message?.content);
        break;
      case MessageType.VOICE_CALL:
        title = ChatItemVoiceCall(content: message?.content, isSend: isSend);
        break;
      default:
        title = ChatItemText(content: message?.content);
        break;
    }
    return ListTile(
      leading: isSend ? SizedBox(width: 50) : avatar,
      trailing: !isSend ? SizedBox(width: 50) : avatar,
      titleAlignment: ListTileTitleAlignment.top,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0, //AppConst.PAGE_PADDING,
      ),
      horizontalTitleGap: 12,
      title: Column(
        crossAxisAlignment: isSend
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [title ?? SizedBox.shrink()],
      ),
    );
  }
}

/// 消息类型
enum MessageType {
  /// 文本
  TEXT,

  /// 图片
  IMAGE,

  /// 音频
  AUDIO,

  /// 视频
  VIDEO,

  /// 文件
  FILE,

  /// 星盘
  ASTROLABE,

  /// 筛子
  DICE,

  /// 智慧牌
  POKER,

  /// 合盘
  COMPOSITE,

  /// 语音通话
  VOICE_CALL,
}
