// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImMessage _$ImMessageFromJson(Map<String, dynamic> json) => ImMessage(
  id: (json['id'] as num?)?.toInt(),
  msgId: json['msgId'] as String?,
  fromUid: json['fromUid'] as String?,
  toUid: json['toUid'] as String?,
  type: json['type'] as String?,
  content: json['content'] as String?,
  typeu: (json['typeu'] as num?)?.toInt(),
  status: (json['status'] as num?)?.toInt(),
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$ImMessageToJson(ImMessage instance) => <String, dynamic>{
  'id': instance.id,
  'msgId': instance.msgId,
  'fromUid': instance.fromUid,
  'toUid': instance.toUid,
  'type': instance.type,
  'content': instance.content,
  'typeu': instance.typeu,
  'status': instance.status,
  'createdAt': instance.createdAt,
};
