import 'package:json_annotation/json_annotation.dart';

import '../user/userinfo.dart';

part 'im_conversation.g.dart';

@JsonSerializable(explicitToJson: true)
class ImConversation {
  final int? id;
  final String? ownerUid;
  final String? targetId;
  final String? targetType;
  final String? lastMessage;
  final String? lastMsgId;
  final String? lastMsgType;
  final String? lastTime;
  final int? unreadCount;
  final int? isTop;
  final String? createdAt;
  final String? updatedAt;
  final Userinfo? targetUser;

  ImConversation({
    this.id,
    this.ownerUid,
    this.targetId,
    this.targetType,
    this.lastMessage,
    this.lastMsgId,
    this.lastMsgType,
    this.lastTime,
    this.unreadCount,
    this.isTop,
    this.createdAt,
    this.updatedAt,
    this.targetUser,
  });

  factory ImConversation.fromJson(Map<String, dynamic> json) =>
      _$ImConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ImConversationToJson(this);
}
