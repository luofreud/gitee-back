// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImConversation _$ImConversationFromJson(Map<String, dynamic> json) =>
    ImConversation(
      id: (json['id'] as num?)?.toInt(),
      ownerUid: json['ownerUid'] as String?,
      targetId: json['targetId'] as String?,
      targetType: json['targetType'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMsgId: json['lastMsgId'] as String?,
      lastMsgType: json['lastMsgType'] as String?,
      lastTime: json['lastTime'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      isTop: (json['isTop'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      targetUser: json['targetUser'] == null
          ? null
          : Userinfo.fromJson(json['targetUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImConversationToJson(ImConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUid': instance.ownerUid,
      'targetId': instance.targetId,
      'targetType': instance.targetType,
      'lastMessage': instance.lastMessage,
      'lastMsgId': instance.lastMsgId,
      'lastMsgType': instance.lastMsgType,
      'lastTime': instance.lastTime,
      'unreadCount': instance.unreadCount,
      'isTop': instance.isTop,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'targetUser': instance.targetUser?.toJson(),
    };
